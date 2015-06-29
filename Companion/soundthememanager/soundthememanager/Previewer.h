//
//  Previewer.h
//  soundthememanager
//
//  Created by Jane Doe on 23.10.11.
//  Copyright (c) 2011 Tigr@Soft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AudioMaster.h"
@interface Previewer : UIViewController {
    
    IBOutlet UIButton *switcher;
    IBOutlet UIButton *smallLSClock;
    IBOutlet UISlider *slider;
    IBOutlet UIProgressView *progView;
    IBOutlet UINavigationItem *navItem;
    IBOutlet UIButton *bigLSClock;
    bool useAltTheme;
    NSString *altThemePath;
    NSString *previewedThemePath;
}
- (IBAction)done:(id)sender;
- (IBAction)alert:(id)sender;
- (IBAction)switcherPress:(id)sender;
- (IBAction)action:(id)sender;
- (IBAction)progUpdate:(id)sender;
- (IBAction)BootSound:(id)sender;
@property (retain, nonatomic) IBOutlet UIButton *switcher;
@property (retain, nonatomic) IBOutlet UIImageView *folderOpen;
@property (retain, nonatomic) NSString *altThemePath;
@property (nonatomic, retain) NSString *previewedThemePath;
@property (nonatomic) bool useAltTheme;
- (IBAction)expandClock:(id)sender;
- (IBAction)collapseClock:(id)sender;
- (IBAction)folder:(id)sender;
- (IBAction)applaunch:(id)sender;
- (IBAction)didendonexit:(id)sender;
@property (retain, nonatomic) IBOutlet UIImageView *bootSound;

@end
