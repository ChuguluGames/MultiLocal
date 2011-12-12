#import "Browser.h"
#import "MultiPlayer.h"

#import <sys/types.h>
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>

@implementation Browser

@synthesize browser;
@synthesize services;
@synthesize streams;

@synthesize callbackOnUpdateConfig;

- (id)init
{
	self = [super init];
	if (self != nil)
	{
        services = [NSMutableArray new];
        streams = [NSMutableArray new];

        self.browser = [NSNetServiceBrowser new];
        self.browser.delegate = self;
    }
	return self;    
}

- (void)setCallbackOnUpdate:(PGPlugin *)plugin andRespondTo:(NSString *)callbackJS
{
    NSLog(@"Setting callback on services list update");
    callbackOnUpdateConfig = [[NSMutableArray alloc] initWithObjects:plugin, callbackJS, nil];
}

- (void)start
{
    NSLog(@"Service search started");    
    [self.browser searchForServicesOfType:@"_http._tcp." 
                                 inDomain:@""];
    
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)browser didFindService:(NSNetService *)service moreComing:(BOOL)more 
{
    NSLog(@"New service detected");
    
    [service setDelegate:self];
    [service resolveWithTimeout:10];    
    
    // add the service
    [services addObject:service];
    
    if (more == NO)
        [self sendServicesToCallback];

}

- (void)netServiceBrowser:(NSNetServiceBrowser *)browser didRemoveService:(NSNetService *)service moreComing:(BOOL)more 
{
    NSLog(@"A service was removed");
       
    // remove the service
    [services removeObject:service];
    
    if (more == NO)
        [self sendServicesToCallback];    
}

- (void)sendServicesToCallback
{
    MultiPlayer *plugin = [callbackOnUpdateConfig objectAtIndex:0];
    NSString *jsFunction = [callbackOnUpdateConfig objectAtIndex:1];
    
    NSMutableArray *servicesInfos = [NSMutableArray new];
    
    for (NSNetService *service in services) 
    {
        
        [servicesInfos addObject:[[NSMutableArray alloc] initWithObjects:[service domain],[service type], [service name], nil]];
    }    

    
    [plugin callback:jsFunction withArguments:servicesInfos];    
}

- (void)netServiceWillResolve:(NSNetService *)service
{
    NSLog( @"Attempting to resolve address for %@", [service name] );
}

- (void)netService:(NSNetService *)service didNotResolve:(NSDictionary *)errorDict
{
    NSLog( @"There was an error while attempting to resolve address for %@", [service name] );
}

- (void)netServiceDidResolveAddress:(NSNetService *)service
{
    // on a resolu l'adresse on peut cree els connection
    NSLog(@"netServiceDidResolveAddress");
//    NSString *ip;
//    struct sockaddr_in *addr;
//    int port;
//    
//    addr = (struct sockaddr_in *) [[[service adresses] objectAtIndex:0]
//                                   bytes];
//    ip = [NSString stringWithCString:(char *) inet_ntoa(addr->sin_addr)];
//    NSLog(@"%@", ip);
}

-(void)dealloc {

}

@end