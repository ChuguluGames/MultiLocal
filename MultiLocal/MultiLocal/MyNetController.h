# pragma mark -
# pragma mark ￼Class Header￼

#import <UIKit/UIKit.h>;

@interface MyNetController : NSObject
{
    NSMutableArray *_peers;
    UITableView *_peerListTableView;
}

@property (nonatomic, retain) NSMutableArray *peers;
@property (nonatomic, retain) UITableView *peerListTableView;
@end
