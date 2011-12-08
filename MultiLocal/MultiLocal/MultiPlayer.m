#import "MultiPlayer.h"
#import <PhoneGap/JSONKit.h>
#import "NetworkBrowser.h"

#import <netinet/in.h>

@implementation MultiPlayer

@synthesize browser;
@synthesize services;

- (void)print:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    NSString *callbackId = [arguments objectAtIndex:0];
    PluginResult *result = nil;
    NSString *jsString = nil;
    
    NSString *message = [arguments objectAtIndex:1];
    
    result = [PluginResult resultWithStatus: PGCommandStatus_OK messageAsString: [ message stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ];
    jsString = [result toSuccessCallbackString:callbackId];     
    
    NSLog(message);
    
    [self writeJavascript: jsString];
}

/* return to javascript the list of connected devices */
- (void)getConnectedDevices:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    NetworkBrowser *browser = [[NetworkBrowser alloc] init];
    NSMutableArray *devices = [browser getConnectedDevices];
    
    NSString *callbackId = [arguments objectAtIndex:0];
    PluginResult *result = nil;
    NSString *jsString = nil;
    
    // encode the array in json
    NSString *response = [devices JSONString];
        
    NSLog(response);
    
    result = [PluginResult resultWithStatus: PGCommandStatus_OK messageAsString: response ];
    jsString = [result toSuccessCallbackString:callbackId];    
    
    [self writeJavascript: jsString];
}

@end