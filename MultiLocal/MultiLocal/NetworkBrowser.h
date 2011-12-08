#import <UIKit/UIKit.h>;

@interface NetworkBrowser : NSObject
{
    NSNetServiceBrowser *browser;
    NSMutableArray *services;
}

- (id)init;
- (NSMutableArray *)getConnectedDevices;
- (void)netServiceBrowser:(NSNetServiceBrowser *)aBrowser didFindService:(NSNetService *)aService moreComing:(BOOL)more;
- (void)netServiceBrowser:(NSNetServiceBrowser *)aBrowser didRemoveService:(NSNetService *)aService moreComing:(BOOL)more;

@property (readwrite, retain) NSNetServiceBrowser *browser;
@property (readonly, retain) NSMutableArray *services;

@end