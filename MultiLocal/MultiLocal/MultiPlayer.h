#import <Foundation/Foundation.h>
#import <PhoneGap/PGPlugin.h>

@class Browser;
@class Server;
@class Client;

@interface MultiPlayer : PGPlugin {
    Client *client;    
    Server *server;
    Browser *browser;
}

- (void)sendToServer:(NSMutableArray *)arguments withDict:(NSMutableDictionary *)options;
- (void)sendToClients:(NSMutableArray *)arguments withDict:(NSMutableDictionary *)options;
- (void)sendToClient:(NSMutableArray *)arguments withDict:(NSMutableDictionary *)options;

- (void)connectToServer:(NSMutableArray *)arguments withDict:(NSMutableDictionary *)options;

- (void)searchServers:(NSMutableArray *)arguments withDict:(NSMutableDictionary *)options;
- (void)stopSearchServers:(NSMutableArray *)arguments withDict:(NSMutableDictionary *)options;

- (void)createServer:(NSMutableArray *)arguments withDict:(NSMutableDictionary *)options;

- (void)trigger:(NSString *)event forObject:(NSString *)object withData:(NSMutableDictionary *)arguments;

@property (readwrite, retain) Client *client;
@property (readwrite, retain) Server *server;
@property (readwrite, retain) Browser *browser;

@end