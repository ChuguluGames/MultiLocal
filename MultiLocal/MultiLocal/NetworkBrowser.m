#import "NetworkBrowser.h"

@implementation NetworkBrowser

@synthesize browser;
@synthesize services;

- (id)init
{
	self = [super init];
	if (self != nil)
	{
        services = [NSMutableArray new];
        self.browser = [NSNetServiceBrowser new];
        self.browser.delegate = self;
    }
	return self;    
}

- (NSMutableArray *)getConnectedDevices
{
    [self.browser searchForServicesOfType:@"_cocoaforsci._tcp." inDomain:@""];
    
    NSMutableArray *devices = [NSMutableArray arrayWithObjects: @"one", @"two", @"three", @"four", nil];
    return devices;
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)browser didFindService:(NSNetService *)service moreComing:(BOOL)more 
{
    [services addObject:service];
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)browser didRemoveService:(NSNetService *)service moreComing:(BOOL)more 
{
    [services removeObject:service];
}

@end