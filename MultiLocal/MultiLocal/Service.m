#import "Service.h"
#import "MultiPlayer.h"

@implementation Service

@synthesize callbackOnMessageConfig;
@synthesize callbackOnCreateConfig;

- (void)setCallbackOnCreate:(PGPlugin *)plugin andRespondTo:(NSString *)callbackJS
{
    NSLog(@"Setting callback on service create");
    callbackOnCreateConfig = [[NSMutableArray alloc] initWithObjects:plugin, callbackJS, nil];    
}

- (void)setCallbackOnMessage:(PGPlugin *)plugin andRespondTo:(NSString *)callbackJS
{
    NSLog(@"Setting callback on service create");
    callbackOnMessageConfig = [[NSMutableArray alloc] initWithObjects:plugin, callbackJS, nil];    
}

-(void)start {
    NSLog(@"NSNetService started");
    
    NSString *domain = @"";
    NSString *type = @"_http._tcp.";
    NSString *name = [NSString stringWithFormat:@"dede%d", arc4random() % 42] ;
    NSInteger port = 4242;
    
//    NSError *error;
//    socket = [[[AsyncSocket alloc] initWithDelegate:self] autorelease];
//    if ( ![socket acceptOnPort:port error:&error] ) {
//        NSLog(@"Failed to create listening socket");
//        return;
//    }    
    
    netService = [[NSNetService alloc] initWithDomain:domain
                                                 type:type
                                                 name:name
                                                 port:port];

    netService.delegate = self;
    [netService publish];
    
    // send the infos to js
    [self sendServiceToCallback:domain
                           type:type
                           name:name];
}


-(void)stop {
    [netService stop];
//    [netService release]; 
    netService = nil;
}

- (void)sendServiceToCallback:(NSString *)domain type:(NSString *)type name:(NSString *)name
{
    MultiPlayer *plugin = [callbackOnCreateConfig objectAtIndex:0];
    NSString *jsFunction = [callbackOnCreateConfig objectAtIndex:1];
    
    NSMutableArray *service = [[NSMutableArray alloc] initWithObjects:domain, type, name, nil];  
    
    [plugin callback:jsFunction withArguments:service];    
}

- (void)sendMessageToCallback:(NSString *)message from:(NSString *)name 
{
    MultiPlayer *plugin = [callbackOnCreateConfig objectAtIndex:0];
    NSString *jsFunction = [callbackOnCreateConfig objectAtIndex:1];
    
    NSMutableArray *data = [[NSMutableArray alloc] initWithObjects:name, message, nil];  
    
    [plugin callback:jsFunction withArguments:data];    
}

-(void)dealloc {
    
}

@end