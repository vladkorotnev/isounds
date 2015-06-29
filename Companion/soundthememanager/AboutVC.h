//
//  AboutVC.h
//  soundthememanager
//
//  Created by Jane Doe on 22.10.11.
//  Copyright (c) 2011 Tigr@Soft. All rights reserved.
//
#import "ChibiXM.h"
#import "XMSample.h"
#import "XMFile.h"
#import "soundthememanagerAppDelegate.h"
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
@class EAGLView;
@interface AboutVC : UIViewController <UIAlertViewDelegate> {
    EAGLView *glView;
    IBOutlet UITextView *text;
    IBOutlet UIView *animationSpot;
    IBOutlet UIBarButtonItem *nowPl;
    NSMutableArray *musics;
}
- (IBAction)donate:(id)sender;
@property (nonatomic,retain) NSMutableArray *musics;
@property (nonatomic, retain) IBOutlet EAGLView *glView;
- (IBAction)myMovieFinishedCallback:(id)sender;
- (IBAction)otherSong:(id)sender;
@end
