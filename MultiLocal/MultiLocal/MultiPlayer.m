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
@synthesize triggerBlock;

- (id)initWithPlugin:(MultiPlayer *)aPlugin
{
	self = [super init];
	if (self != nil)
	{
        [self createBlock];
    }
	return self;    
}


- (void)createBlock
{
    self.triggerBlock = ^(NSString *event, NSString *object, NSMutableArray *arguments) {
        NSString *response = [arguments JSONString];
        NSString* jsString = [[NSString alloc] initWithFormat:@"multiplayer.events.%@.%@(%@);", object, event, response ];
        NSLog(@"calling: %@", jsString);
        [self.webView stringByEvaluatingJavaScriptFromString:jsString];  
    };
}

- (void)createServer:(NSMutableArray *)arguments withDict:(NSMutableDictionary *)options
{
    NSLog(@"Native createServer method responded");      

    // Start the service
<<<<<<< HEAD
    server =  [[Server alloc] initAndRespondTo:[self triggerBlock]];
=======
    server =  [[Server alloc] initWithPlugin:self];
>>>>>>> temp
    
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
    NSLog(@"Native send method responded");      
    
    [client send: [options valueForKey:@"message"]];
}

- (void)sendToClients:(NSMutableArray *)arguments withDict:(NSMutableDictionary *)options
{
    NSLog(@"Native send method responded");      
    
    [server sendToAll: [options valueForKey:@"message"]];
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

- (void)trigger:(NSString *)event forObject:(NSString *)object withData:(NSMutableArray *)arguments
{
    NSString *response = [arguments JSONString];
    NSString* jsString = [[NSString alloc] initWithFormat:@"multiplayer.events.%@.%@(%@);", object, event, response ];
    NSLog(@"calling: %@", jsString);
    [self.webView stringByEvaluatingJavaScriptFromString:jsString];
}

@end