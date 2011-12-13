//
//  Client.h
//  MultiLocal
//
//  Created by David Billamboz on 12/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PhoneGap/PGPlugin.h>
#import "GCDAsyncSocket.h"

@class MultiPlayer;

@interface Client : NSObject {
    NSMutableArray *serverAddresses;
    GCDAsyncSocket *socket;        
    BOOL connected;
    
    MultiPlayer *plugin;
}
- (id)initWithPlugin:(MultiPlayer *)aPlugin;
- (void)connectTo:(NSNetService *)remoteService;
- (void)connectToNextAddress;
- (void)onConnection;
- (void)sendMessageToCallback:(NSString *)message;
- (void)setCallbacksFor:(PGPlugin *)plugin withCallbacks:(NSDictionary *)callbacks;
- (void)send:(NSString *)message;

@property (readwrite, retain) GCDAsyncSocket *socket;
@property (readwrite, retain) MultiPlayer *plugin;

@end
