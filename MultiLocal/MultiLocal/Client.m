//
//  Client.m
//  MultiLocal
//
//  Created by David Billamboz on 12/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Client.h"
#import "GCDAsyncSocket.h"
#import "MultiPlayer.h"

@implementation Client

@synthesize socket;
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

#pragma mark - Connection

/* connect to a remote bonjour service */
- (void)connectTo:(NSNetService *)remoteService
{
    NSLog(@"connecting to %@", [remoteService name]);
    serverAddresses = [[remoteService addresses] mutableCopy];
    socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    [socket readDataWithTimeout:-1 tag:0]; // read the message
    
    [self connectToNextAddress];
}

/* try to connect to the last address of the service */
- (void)connectToNextAddress
{
    BOOL done = NO;
    
    while (!done && ([serverAddresses count] > 0))
    {
        NSData *addr;
               
        if (YES) // Iterate forwards
        {
            addr = [[serverAddresses objectAtIndex:0] retain];
            [serverAddresses removeObjectAtIndex:0];
        }
        else // Iterate backwards
        {
            addr = [[serverAddresses lastObject] retain];
            [serverAddresses removeLastObject];
        }
        
        NSLog(@"Attempting connection to %@", addr);
        
        NSError *err = nil;
        if ([socket connectToAddress:addr error:&err])
        {
            done = YES;
        }
        else
        {
            NSLog(@"Unable to connect: %@", err);
        }
        
        [addr release];
    }
    
    if (!done)
    {
        NSLog(@"Unable to connect to any resolved address");
    }
}

/* when the socket is connected to the server */
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)server port:(UInt16)port
{
    NSLog(@"Socket %@:didConnectToHost: %@ Port: %hu", sock, server, port);
    
    [sock readDataWithTimeout:-1 tag:0]; // read the first message
    
    [plugin trigger:@"onConnection" forObject:@"client" withData: [NSMutableDictionary new]];
    
    connected = YES;   
}

#pragma mark - Deconnection

/* when the socket is disconnected from the server */
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    NSLog(@"SocketDidDisconnect:WithError: %@", err);
    [plugin trigger:@"onDisconnection" forObject:@"client" withData: [NSMutableDictionary new]];
}

#pragma mark - Send message

/* send operation */
- (void)send:(NSString *)message
{
    NSLog(@"sending %@", message);
    message = [NSString stringWithFormat:@"%@\r\n", message]; // adding the carriage return and the line feed
    
    NSData *messageData = [message dataUsingEncoding:NSUTF8StringEncoding];
    [socket writeData:messageData withTimeout:-1.0 tag:0];
}

/* when the socket send data */ 
- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    NSLog(@"socket:%p didWriteDataWithTag:%d", sock, tag);
}

#pragma mark - Receive message

/* when the socket receives data */
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    [sock readDataWithTimeout:-1 tag:0]; // read the next message   
    
    NSString *message = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"didReadData: %@ to %@", message, sock);
    
    [plugin trigger:@"onMessage" forObject:@"client" withData: [[NSMutableDictionary alloc] initWithObjectsAndKeys:message, @"message", nil]];
}

@end
