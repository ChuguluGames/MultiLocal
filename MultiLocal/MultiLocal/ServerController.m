#import "ServerController.h"

@interface ServerController ()

-(void)startService;
-(void)stopService;

@end


@implementation ServerController

-(void)awakeFromNib {    
    [self startService];
}

-(void)startService {
    netService = [[NSNetService alloc] initWithDomain:@"" type:@"_cocoaforsci._tcp." 
                                                 name:@"" port:7865];
    netService.delegate = self;
    [netService publish];
}

-(void)stopService {
    [netService stop];
    [netService release]; 
    netService = nil;
}

-(void)dealloc {
    [self stopService];
    [super dealloc];
}

#pragma mark Net Service Delegate Methods
-(void)netService:(NSNetService *)aNetService didNotPublish:(NSDictionary *)dict {
    NSLog(@"Failed to publish: %@", dict);
}

@end