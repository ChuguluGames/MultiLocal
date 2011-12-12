#import "MultiPlayer.h"
#import <PhoneGap/JSONKit.h>
#import "Browser.h"
#import "Service.h"

#import <netinet/in.h>

@implementation MultiPlayer

- (void)searchServices:(NSMutableArray *)arguments withDict:(NSMutableDictionary *)options
{
    NSString *callbackJSOnUpdateServices = [arguments objectAtIndex:1];   
    
    // Start the browsering
    Browser *browser = [[Browser alloc] init];
    
    // callback each time the list is updated
    [browser setCallbackOnUpdate: self 
                    andRespondTo: callbackJSOnUpdateServices];  
    
    [browser start];  
}

- (void)createService:(NSMutableArray *)arguments withDict:(NSMutableDictionary *)options
{
    NSString *callbackJSOnCreateService = [arguments objectAtIndex:1];
    NSString *callbackJSOnMessage = [arguments objectAtIndex:2];
    
    // Start the service
    Service *service =  [[Service alloc] init];
    
    // callback when the service is started
    [service setCallbackOnCreate: self 
                    andRespondTo: callbackJSOnCreateService]; 
 
    // callback when a message arrived to the service
    [service setCallbackOnMessage: self 
                    andRespondTo: callbackJSOnMessage];     
    
    [service start];    
}

- (void)callback:(NSString *)jsFunction withArguments:(NSMutableArray *)arguments
{
    NSLog(@"Multiplayer callback called");

    NSString *response = [arguments JSONString];

    NSString* jsString = [[NSString alloc] initWithFormat:@"multiplayer.%@(%@);", jsFunction, response ];
    
    NSLog(@"Sending to javascript the callback");
    NSLog(@"calling: %@", jsString);
    
    [self.webView stringByEvaluatingJavaScriptFromString:jsString];
}

@end