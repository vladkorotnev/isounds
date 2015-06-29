//
//  MainViewController.h
//  soundthememanager
//
//  Created by Vladislav on 18.07.11.
//  Copyright 2011 Tigr@Soft. All rights reserved.
//
#import "Previewer.h"
#import "FlipsideViewController.h"

#import "AboutVC.h"
#import "CyStoreCheck.h"
#import "SoundCombinator.h"
@interface MainViewController : UIViewController <FlipsideViewControllerDelegate,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,SoundCombinatorEvt> {
    IBOutlet UITableView *tableVw;
    IBOutlet UINavigationBar *navbar;
    bool didLic;
    IBOutlet UIBarButtonItem *storeButton;
    IBOutlet UIView *wereLoading;
    IBOutlet UINavigationItem *titleVieww;
    IBOutlet UIImageView *canUpdateBadge;
    IBOutlet UIBarButtonItem *hapticButton;
    IBOutlet UIView *hapticPanel;
    IBOutlet UISwitch *hapticSwitch;
    IBOutlet UILabel *hapticLabel;
}

- (IBAction)respring:(id)sender;
- (IBAction)createNew:(id)sender;
- (IBAction)hapticToggle:(id)sender;
- (IBAction)hapticPress:(id)sender;

- (IBAction)showInfo:(id)sender;
- (IBAction)editTable:(id)sender;
- (IBAction)disable:(id)sender;
- (IBAction)themeTest:(id)sender;
@property (nonatomic, retain) IBOutlet UITableView *tableVw;
@end
