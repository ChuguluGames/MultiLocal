#import <Foundation/Foundation.h>
#import <PhoneGap/PGPlugin.h>

@interface Service : NSObject<NSNetServiceDelegate> {
    NSNetService *netService;
    NSMutableArray *callbackOnCreateConfig;    
    NSMutableArray *callbackOnMessageConfig;       

}

- (void)start;
- (void)stop;
- (void)sendServiceToCallback:(NSString *)domain type:(NSString *)type name:(NSString *)name;
- (void)setCallbackOnCreate:(PGPlugin *)plugin andRespondTo:(NSString *)callbackJS;
- (void)setCallbackOnMessage:(PGPlugin *)plugin andRespondTo:(NSString *)callbackJS;
- (void)sendMessageToCallback:(NSString *)message from:(NSString *)name;

@property (readwrite, retain) NSMutableArray *callbackOnCreateConfig;
@property (readwrite, retain) NSMutableArray *callbackOnMessageConfig;

@end