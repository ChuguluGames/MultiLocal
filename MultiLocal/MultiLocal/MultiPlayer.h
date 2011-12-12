#import <Foundation/Foundation.h>
#import <PhoneGap/PGPlugin.h>


@interface MultiPlayer : PGPlugin {

}

- (void)createHost:(NSMutableArray *)arguments withDict:(NSMutableDictionary *)options;
- (void)callback:(NSString *)jsFunction withArguments:(NSMutableArray *)arguments;

@end