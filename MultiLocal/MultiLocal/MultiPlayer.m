#import "MultiPlayer.h"
#import <PhoneGap/JSONKit.h>
#import "Browser.h"
#import "Server.h"
#import "Client.h"

#import <netinet/in.h>

@implementation MultiPlayer

@synthesize client;
@synthesize server;
@synthesize browser;

- (void)createServer:(NSMutableArray *)arguments withDict:(NSMutableDictionary *)options
{
    NSLog(@"Native createServer method responded");      

    // Start the service
    server =  [[Server alloc] initWithPlugin:self];
    
    [server start];   
}

#pragma mark - Connection

- (void)connectToServer:(NSMutableArray *)arguments withDict:(NSMutableDictionary *)options
{
    NSLog(@"Native connectToHost method responded");      
    
    NSString *serverName = [options valueForKey:@"name"];
    
    for (NSNetService *aServer in [browser servers]) 
    {
        if ([[aServer name] isEqualToString:serverName]) {
            NSLog(@"Host found");
            
            client = [[Client alloc] initWithPlugin:self];
            
            [client connectTo:aServer];
            
        }
    }        
}

#pragma mark - Send message
- (void)sendToServer:(NSMutableArray *)arguments withDict:(NSMutableDictionary *)options
{
    NSLog(@"Native sendToServer method responded");      
    
    [client send: [options valueForKey:@"message"]];
}

- (void)sendToAllClients:(NSMutableArray *)arguments withDict:(NSMutableDictionary *)options
{
    NSLog(@"Native sendToAllClients method responded");   
    [server sendToAll: [options valueForKey:@"message"]];
}

- (void)sendToClientsFromList:(NSMutableArray *)arguments withDict:(NSMutableDictionary *)options
{
    NSLog(@"Native sendToAllClients method responded");   
    NSEnumerator *e = [[options valueForKey:@"clients"] objectEnumerator];
    NSString *clientName;
    while (clientName = [e nextObject]) {
        [server sendToWithName: clientName withMessage: [options valueForKey:@"message"]];
    }
}

- (void)sendToClient:(NSMutableArray *)arguments withDict:(NSMutableDictionary *)options
{
    NSLog(@"Native sendToClient method responded");      
    
    [server sendToWithName: [options valueForKey:@"clientName"] withMessage: [options valueForKey:@"message"]];
}

#pragma mark - Search server   
- (void)searchServers:(NSMutableArray *)arguments withDict:(NSMutableDictionary *)options
{
    NSLog(@"Native searchServers method responded");    
    
    // Start the browsering
    browser = [[Browser alloc] initWithPlugin:self];
    
    [browser start];      
}

- (void)stopSearchServers:(NSMutableArray *)arguments withDict:(NSMutableDictionary *)options
{
    NSLog(@"Native stopSearchServers method responded");      
    
    [browser stop];  
}


#pragma mark - Specific phonegap

- (void)trigger:(NSString *)event forObject:(NSString *)object withData:(NSMutableDictionary *)arguments
{
    NSString *response = [arguments JSONString];
    NSString* jsString = [[NSString alloc] initWithFormat:@"application.multi.events.%@.%@(%@);", object, event, response ];
    NSLog(@"calling: %@", jsString);
    [self.webView stringByEvaluatingJavaScriptFromString:jsString];
}

@end