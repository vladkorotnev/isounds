//
//  soundthememanagerAppDelegate.h
//  soundthememanager
//
//  Created by Vladislav on 18.07.11.
//  Copyright 2011 Tigr@Soft. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MainViewController;

@interface soundthememanagerAppDelegate : NSObject <UIApplicationDelegate,UIAlertViewDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet MainViewController *mainViewController;

@end
