//
//  OpenOtherRepoView.h
//  soundthememanager
//
//  Created by Jane Doe on 20.10.11.
//  Copyright (c) 2011 Tigr@Soft. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OtherRepoDelegate;

@interface OpenOtherRepoView : UIViewController <UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UIAlertViewDelegate> {
    NSString *repo;
    IBOutlet UITableView *table;
    UIActionSheet *repoActions;
    NSIndexPath *storedIndexpath;
    IBOutlet UIView *wereLoading;
    NSDictionary *storeRepo;
    NSDictionary *commuRepo;
    NSMutableArray *userRepos;
}
- (IBAction)add:(id)sender;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *add;
- (IBAction)Cancel:(id)sender;
@property (nonatomic, assign) id <OtherRepoDelegate> delegate;
@property (nonatomic,retain) NSString *repo;
@property (nonatomic,retain) NSDictionary *storeRepo;
@property (nonatomic,retain)NSDictionary *commuRepo;
@property (nonatomic,retain)NSMutableArray *userRepos;
- (IBAction)editTable:(UIButton *)sender;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *editbtn;

@end

@protocol OtherRepoDelegate
- (void)RepoChooserControllerDidFinish:(OpenOtherRepoView *)controller withRepo:(NSString *)url;
@end
