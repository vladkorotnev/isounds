//
//  FlipsideViewController.h
//  soundthememanager
//
//  Created by Vladislav on 18.07.11.
//  Copyright 2011 Tigr@Soft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OpenOtherRepoView.h"

#import "DownloadView.h"
@protocol FlipsideViewControllerDelegate;

@interface FlipsideViewController : UIViewController <UIAlertViewDelegate,UITableViewDelegate,UITableViewDataSource,OtherRepoDelegate> {
    NSDictionary *currentStoreItems;
  
    UIImage *storeHeadImg;
    UIImage *storeFooterImg;
    IBOutlet UIView *wereLoading;
    NSString *repo;
    IBOutlet UINavigationItem *navitem;
    UIButton *_alert;
    IBOutlet UITableView *table;
    NSDictionary *storeRepo;
    IBOutlet UIView *AdSpot;
}

@property (nonatomic, assign) id <FlipsideViewControllerDelegate> delegate;
@property (nonatomic,retain) NSDictionary *currentStoreItems;
@property (nonatomic,retain) NSString *repo;
@property (nonatomic,retain)  NSDictionary *storeRepo;
@property (nonatomic,retain) UIImage *storeHeadImg;
@property (nonatomic,retain) UIImage *storeFooterImg;
- (IBAction)done:(id)sender;


@end


@protocol FlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller;
@end
