#import "MyNetController.h"

# pragma mark -
# pragma mark ￼Class Implementation

@implementation MyNetController

@synthesize peers = _peers;
@synthesize peerListTableView = _peerListTableView;

- (id) init
{
	self = [super init];
	if (self != nil)
	{
		self.peers = [NSMutableArray array];
	}
	return self;
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)netServiceBrowser
		   didFindService:(NSNetService *)netService
			   moreComing:(BOOL)moreServicesComing
{
	// Resolve the service to get our peer's name.
	[netService resolve];
    
	// Add the object to our collection so that
	// it gets retained for future use.
	[_peers addObject:netService];
    
	NSLog(@"Found a new peer.  Resolve started...");
}

- (void)netServiceDidResolveAddress:(NSNetService *)sender
{
	// Peer will never show up in our table view.
	[_peerListTableView reloadData];
    
	NSLog(@"This line will never get printed.");
}

@end
