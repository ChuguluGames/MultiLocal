#import <Foundation/Foundation.h>
#import <PhoneGap/PGPlugin.h>

@interface MultiPlayer : PGPlugin {
    //---use for browsing services---
    NSNetServiceBrowser *browser;
    NSMutableArray *services;
}

- (void) print:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
- (void) getConnectedDevices:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;

@property (readwrite, retain) NSNetServiceBrowser *browser;
@property (readwrite, retain) NSMutableArray *services;

@end