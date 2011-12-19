#import "MultiPlayer.h"
#import "Browser.h"

@implementation Browser

@synthesize browser;
@synthesize servers;
@synthesize plugin;

- (id)initWithPlugin:(MultiPlayer *)aPlugin
{
	self = [super init];
	if (self != nil)
	{
        servers = [NSMutableArray new];
        plugin = aPlugin;
        
        self.browser = [NSNetServiceBrowser new];
        self.browser.delegate = self;
    }
	return self;    
}

- (void)start
{
    NSLog(@"Service search started");    
    [self.browser stop]; // stop the search before searching
    [self.browser searchForServicesOfType:@"_http._tcp." 
                                 inDomain:@""];
    
}

- (void)stop
{
    NSLog(@"Service search stopped");     
    
    [self.browser stop];
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)browser didFindService:(NSNetService *)service moreComing:(BOOL)more 
{
    if ([[[service name] substringWithRange:NSMakeRange(0, 6)] isEqualToString:@"server"]) {
        [service retain];
        [service setDelegate:self];
        [service resolveWithTimeout:10];            
    } else {
        NSLog(@"Service %@ detected", [service name]);
    }
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)browser didRemoveService:(NSNetService *)service moreComing:(BOOL)more 
{
    NSLog(@"A service was removed");
       
    // remove the service
    [servers removeObject:service];
    
    [self updateServersList];  
}

/* send the servers list to the plugin */
- (void)updateServersList
{
    NSMutableArray *serverList = [NSMutableArray new];
    
    for (NSNetService *service in servers) 
    {
        
        [serverList addObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                [service domain], @"domain",
                                [service type], @"type",
                                [service name], @"name",
                              nil]];
    }    
    
    [plugin trigger:@"onUpdate" forObject:@"browser" withData: [[NSMutableDictionary alloc] initWithObjectsAndKeys:serverList, @"servers", nil]];
}

/* starting the resolution of the service address */
- (void)netServiceWillResolve:(NSNetService *)service
{
    NSLog( @"Attempting to resolve address for %@", [service name] );
}

/* did not resolve the service address */
- (void)netService:(NSNetService *)service didNotResolve:(NSDictionary *)errorDict
{
    NSLog( @"There was an error while attempting to resolve address for %@", [service name] );
}

/* when the address of the service has been resolved */
- (void)netServiceDidResolveAddress:(NSNetService *)service
{
    NSLog(@"netServiceDidResolveAddress");
   
    // add the service
    [servers addObject:service];    
    
    [self updateServersList];  
}

-(void)dealloc {
    [super dealloc];
}

@end