#import "Server.h"
#import "GCDAsyncSocket.h"
#import "MultiPlayer.h"
#import <PhoneGap/JSONKit.h>

#define WELCOME_MSG 0
#define ECHO_MSG 1
#define WARNING_MSG 2

#define READ_TIMEOUT 15.0
#define READ_TIMEOUT_EXTENSION 10.0

@implementation Server

@synthesize socket;
@synthesize connectedClients;
@synthesize service;
@synthesize plugin;

- (id)initWithPlugin:(MultiPlayer *)aPlugin
{
	self = [super init];
	if (self != nil)
	{
        plugin = aPlugin;
    }
	return self;    
}

- (void)start 
{
    
    // Create our socket.
    // We tell it to invoke our delegate methods on the main thread.    
    
    socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    // Create an array to hold accepted incoming connections.
        
    connectedClients = [[NSMutableArray alloc] init];
        
    // Now we tell the socket to accept incoming connections.
    // We don't care what port it listens on, so we pass zero for the port number.
    // This allows the operating system to automatically assign us an available port.
        
    NSError *err = nil;
    if ([socket acceptOnPort:0 error:&err])
    {
        // get an available port
        UInt16 port = [socket localPort];
                
        service = [[NSNetService alloc] initWithDomain:@""
                                                  type:@"_http._tcp."
                                                  name:[NSString stringWithFormat:@"server_%d", arc4random() % 42]
                                                  port:port];

        [service setDelegate:self];
        [service publish];
                
    } else {
        [plugin trigger:@"onError" forObject:@"server" withData: [[NSMutableDictionary alloc] initWithObjectsAndKeys:err, @"error", nil]];        
        NSLog(@"Error: %@", err);
    }
}

#pragma mark - Connection

/* when a socket is connected to the server */
- (void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket
{
    NSLog(@"Accepted new socket from %@:%hu", [newSocket connectedHost], [newSocket connectedPort]);
    
    // The newSocket automatically inherits its delegate & delegateQueue from its parent.
    
    [newSocket readDataWithTimeout:-1 tag:0]; // r\    // create the client name
    NSInteger clientId = [connectedClients count] + 1;
    NSString *clientName = [NSString stringWithFormat:@"client_%d", clientId];
    
    [plugin trigger:@"onConnection" forObject:@"server" withData: [[NSMutableDictionary alloc] initWithObjectsAndKeys: clientName, @"clientName", nil]];
    
    [connectedClients addObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                    clientName, @"name",
                                    newSocket, @"socket",
                                 nil]]; 
}

#pragma mark - Deconnection

/* when a socket deconnected from the server */
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    NSLog(@"Socket disconnected %@ with error: %@", sock, err);

    for (NSMutableDictionary *client in connectedClients) 
    {
        if([client valueForKey: @"socket"] == sock) {
            [plugin trigger:@"onDisconnection" forObject:@"server" withData: [[NSMutableDictionary alloc] initWithObjectsAndKeys: 
                                                                              [client valueForKey: @"name"], @"clientName", 
                                                                              nil]];
            [connectedClients removeObject:client];
        }
    }      
    
}

#pragma mark - Sending message\

/* send a message to each connected socket */
- (void)sendToAll:(NSString *)message 
{
    for (NSMutableDictionary *client in connectedClients) 
    {
        [self sendTo:[client valueForKey: @"socket"] withMessage: message];
    }          
}

/* send a message to a specific socket */
- (void)sendTo:(GCDAsyncSocket *)sock withMessage:(NSString *)message 
{
    NSLog(@"sending %@", message);    
    message = [NSString stringWithFormat:@"%@\r\n", message]; // adding the carriage return and the line feed    
    
    NSData* messageData = [message dataUsingEncoding:NSUTF8StringEncoding];
    [sock writeData:messageData withTimeout:-1 tag:0];
}

/* send a message to a specific client */
- (void)sendToWithName:(NSString *)clientName withMessage:(NSString *)message 
{
    NSLog(@"finding client socket by his name %@", clientName);\
    for (NSMutableDictionary *client in connectedClients) 
    {
        if([[client valueForKey: @"name"] isEqualToString: clientName]) {
            NSLog(@"client socket found");
            [self sendTo:[client valueForKey: @"socket"] withMessage: message];
            return;
        }
    }
}

/* when the server send a message */
- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    NSLog(@"socket:%p didWriteDataWithTag:%d", sock, tag);
}

#pragma mark - Receive message

/* when the server received a message */
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSString *message = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"didReadData: %@ to %@", message, sock);
    
    [sock readDataWithTimeout:-1 tag:0]; // read the next message
    
    [plugin trigger:@"onMessage" forObject:@"server" withData: [[NSMutableDictionary alloc] initWithObjectsAndKeys: message, @"message", nil]];
}

- (void)socket:(GCDAsyncSocket *)sock didReadPartialDataOfLength:(NSUInteger)partialLength tag:(long)tag 
{
    NSLog(@"socket:%p didReadPartialDataOfLength:%d", sock, partialLength);
}

#pragma mark - Bonjour service

/* when the bonjour service publish on the domain */
- (void)netServiceDidPublish:(NSNetService *)ns
{
    NSLog(@"Bonjour Service Published: domain(%@) type(%@) name(%@) port(%i)",
              [ns domain], [ns type], [ns name], (int)[ns port]);
    
    NSMutableDictionary *server = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                     [ns domain], @"domain",
                                     [ns type], @"type",
                                     [ns name], @"name",
                                   nil];
    
    [plugin trigger:@"onCreate" forObject:@"server" withData: [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                                                server, @"server",
                                                               nil]];
}

/* if the bonjour service did not publish */
- (void)netService:(NSNetService *)ns didNotPublish:(NSDictionary *)errorDict
{
    // Override me to do something here...
    //
    // Note: This method in invoked on our bonjour thread.
    
    NSLog(@"Failed to Publish Service: domain(%@) type(%@) name(%@) - %@",
               [ns domain], [ns type], [ns name], errorDict);
    
    [plugin trigger:@"onError" forObject:@"server" withData: [[NSMutableDictionary alloc] initWithObjectsAndKeys:errorDict, @"error", nil]];
}

- (void)dealloc 
{
    [super dealloc];
}

@end