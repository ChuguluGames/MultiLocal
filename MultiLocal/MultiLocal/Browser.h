#import <UIKit/UIKit.h>
#import <PhoneGap/PGPlugin.h>

@interface Browser : NSObject<NSNetServiceBrowserDelegate>
{
    NSNetServiceBrowser *browser;
    NSMutableArray *services;
    NSMutableArray *streams;    
    NSMutableArray *callbackOnUpdateConfig;    
}

- (id)init;
- (void)setCallbackOnUpdate:(PGPlugin *)plugin andRespondTo:(NSString *)callbackJS;
- (void)start;
- (void)netServiceBrowser:(NSNetServiceBrowser *)browser didFindService:(NSNetService *)service moreComing:(BOOL)more;
- (void)netServiceBrowser:(NSNetServiceBrowser *)browser didRemoveService:(NSNetService *)service moreComing:(BOOL)more;
- (void)sendServicesToCallback;

@property (readwrite, retain) NSNetServiceBrowser *browser;
@property (readonly, retain) NSMutableArray *services;
@property (readonly, retain) NSMutableArray *streams;
@property (readwrite, retain) NSMutableArray *callbackOnUpdateConfig;

@end