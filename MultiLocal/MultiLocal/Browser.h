#import <Foundation/Foundation.h>

@class MultiPlayer;

@interface Browser : NSObject<NSNetServiceBrowserDelegate, NSNetServiceDelegate>
{
    NSNetServiceBrowser *browser;
    NSMutableArray *servers;
    NSMutableArray *streams;    
    MultiPlayer *plugin;    
}
- (id)initWithPlugin:(MultiPlayer *)aPlugin;
- (void)start;
- (void)stop;
- (void)netServiceBrowser:(NSNetServiceBrowser *)browser didFindService:(NSNetService *)service moreComing:(BOOL)more;
- (void)netServiceBrowser:(NSNetServiceBrowser *)browser didRemoveService:(NSNetService *)service moreComing:(BOOL)more;
- (void)updateServersList;

@property (readwrite, retain) NSNetServiceBrowser *browser;
@property (readonly, retain) NSMutableArray *servers;
@property (readwrite, retain) MultiPlayer *plugin; 

@end