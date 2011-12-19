#import <Foundation/Foundation.h>
#import "GCDAsyncSocket.h"

@class MultiPlayer;

@interface Server : NSObject<NSNetServiceBrowserDelegate, NSNetServiceDelegate> {
    GCDAsyncSocket *socket;
    NSMutableArray *connectedClients;
    NSNetService *service;
    MultiPlayer *plugin;
}

- (void)start;

- (void)sendToAll:(NSString *)message;
- (void)sendTo:(GCDAsyncSocket *)sock withMessage:(NSString *)message;
- (void)sendToWithName:(NSString *)clientName withMessage:(NSString *)message;

@property (readwrite, retain) GCDAsyncSocket *socket;
@property (readwrite, retain) NSMutableArray *connectedClients;
@property (readwrite, retain) NSNetService *service;
@property (readwrite, retain) MultiPlayer *plugin;

@end