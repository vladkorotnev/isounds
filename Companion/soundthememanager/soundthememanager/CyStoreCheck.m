//
//  CyStoreCheck.m
//  soundthememanager
//
//  Created by Jane Doe on 06.11.11.
//  Copyright (c) 2011 Tigr@Soft. All rights reserved.
//

#import "CyStoreCheck.h"
#import "EncryptionModule.h"
#import "Piracy.h"
#define StoreURL @"kwws=22lv3xqgv1wn2dssgdwd2fxuyhu1solvw"

@implementation CyStoreCheck

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UIApplication sharedApplication]setStatusBarHidden:TRUE withAnimation:UIStatusBarAnimationFade];
    // Do any additional setup after loading the view from its nib.
}
- (void)viewDidAppear:(BOOL)animated {
[NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(updCheck) userInfo:nil repeats:FALSE];
}
-(void)updCheck {
    if ([[NSFileManager defaultManager]fileExistsAtPath:@"/isounds.deb"]) {
        [text setText:@"Found DEVELOPER update. Use iFile to install."];
    }
    EncryptionModule *crypt = [EncryptionModule new];
    NSString *urlToVerify = [NSString stringWithFormat:@"%@",[crypt decryptString:StoreURL withOffset:3]];
    NSDictionary *info = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"Info" ofType:@"plist"]];
    float instVer = [[info objectForKey:@"CFBundleShortVersionString"]floatValue];
    NSDictionary *result = [NSDictionary dictionaryWithContentsOfURL:[NSURL URLWithString:urlToVerify]];
    if (result == nil) {
        void (^animations)(void) = nil;
        animations = ^{
            [spin setAlpha:0.0f];
            [text setText:@"Error when checking"];
            CGRect NewFrame = CGRectMake(text.frame.origin.x, ((self.view.bounds.size.height / 2)-(text.frame.size.height/2)), text.frame.size.width, text.frame.size.height);
            text.frame = NewFrame;
        };
        [UIView animateWithDuration:1 animations:animations];
        [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(hideSuccess) userInfo:nil repeats:FALSE];
    } else {
        float curVer = [[result objectForKey:@"Version"]floatValue];
        if (curVer != instVer) {
            void (^animations)(void) = nil;
            animations = ^{
                [spin setAlpha:0.0f];
                [text setText:@"Update available"];
                CGRect NewFrame = CGRectMake(text.frame.origin.x, ((self.view.bounds.size.height / 2)-(text.frame.size.height/2)), text.frame.size.width, text.frame.size.height);
                text.frame = NewFrame;
            };
            [UIView animateWithDuration:1 animations:animations];
            [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(hidePirat) userInfo:nil repeats:FALSE];
        } else {
            void (^animations)(void) = nil;
            animations = ^{
                [spin setAlpha:0.0f];
                [text setText:@"No updates"];
                CGRect NewFrame = CGRectMake(text.frame.origin.x, ((self.view.bounds.size.height / 2)-(text.frame.size.height/2)), text.frame.size.width, text.frame.size.height);
                text.frame = NewFrame;
            };
            [UIView animateWithDuration:1 animations:animations];
            [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(hideSuccess) userInfo:nil repeats:FALSE];
        }
    }
}

- (void)hideSuccess {
    [self setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [[UIApplication sharedApplication]setStatusBarHidden:FALSE withAnimation:UIStatusBarAnimationFade];
    [self dismissModalViewControllerAnimated:TRUE];
}

- (void)hidePirat {
    Piracy *upd = [Piracy new];
    EncryptionModule *crypt = [EncryptionModule new];
    NSString *urlToVerify = [NSString stringWithFormat:@"%@",[crypt decryptString:StoreURL withOffset:3]];
    NSDictionary *result = [NSDictionary dictionaryWithContentsOfURL:[NSURL URLWithString:urlToVerify]];
    [upd setTitleFor:[result objectForKey:@"UserReadableName"]];
    [upd setDescrippy:[NSString stringWithFormat:@"What's new in this version:\n%@",[result objectForKey:@"ChangeLog"]]];
    [upd setDelegate:self];
    [upd setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [[UIApplication sharedApplication]setStatusBarHidden:FALSE withAnimation:UIStatusBarAnimationSlide];
    [self presentModalViewController:upd animated:YES];
}

- (void)weHaveFinished {
    [self hideSuccess];
}

- (void)viewDidUnload
{
    [spin release];
    spin = nil;
    [text release];
    text = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [spin release];
    [text release];
    [super dealloc];
}
@end
