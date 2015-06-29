//
//  Previewer.m
//  soundthememanager
//
//  Created by Jane Doe on 23.10.11.
//  Copyright (c) 2011 Tigr@Soft. All rights reserved.
//

#import "Previewer.h"

@implementation Previewer
@synthesize bootSound;
@synthesize switcher;
@synthesize folderOpen;
@synthesize altThemePath;
@synthesize previewedThemePath;
@synthesize useAltTheme;
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
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:true];
    // Do any additional setup after loading the view from its nib.
    if (useAltTheme) {
        NSString *escapedShit = [altThemePath stringByReplacingOccurrencesOfString:@" " withString:@"\\ "];
        NSString *command = [NSString stringWithFormat:@"mv /var/mobile/Library/iSounds/%@/* /var/mobile/Library/iSounds/.InUse",escapedShit];
        system("mv /var/mobile/Library/iSounds/.InUse /var/mobile/Library/iSounds/.InUseBack");
        system("mkdir  /var/mobile/Library/iSounds/.InUse");
        system([command UTF8String]);
        previewedThemePath = altThemePath;
    } 
}

- (void)viewDidUnload
{
    [navItem release];
    navItem = nil;
    [slider release];
    slider = nil;
    
    [progView release];
    progView = nil;
    [self setSwitcher:nil];
    [switcher release];
    switcher = nil;
    [smallLSClock release];
    smallLSClock = nil;
    [bigLSClock release];
    bigLSClock = nil;
    [self setFolderOpen:nil];
    [self setBootSound:nil];
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
    [navItem release];
    [slider release];

    [progView release];
    [switcher release];
    [switcher release];
    [smallLSClock release];
    [bigLSClock release];
    [folderOpen release];
    [bootSound release];
    [super dealloc];
}
- (IBAction)done:(id)sender {
    if (useAltTheme) {
        system("rm -rf /var/mobile/Library/iSounds/.InUse");
        system("mv /var/mobile/Library/iSounds/.InUseBack /var/mobile/Library/iSounds/.InUse");
    }
    [self dismissModalViewControllerAnimated:TRUE];
}

- (IBAction)alert:(id)sender {
    [[[UIAlertView alloc]initWithTitle:@"Hello!" message:@"Test" delegate:self cancelButtonTitle:@"iSounds" otherButtonTitles:@"iSounds", nil]show];
}

- (IBAction)switcherPress:(UIButton *)sender {
    if (sender.selected) {
        [sender setSelected:FALSE];
    } else {
        [sender setSelected:TRUE];
        [[[SoundCtrl alloc]init]playSystemSoundAtPath:[NSString stringWithFormat:@"%@/switcher_edit.wav",previewedThemePath]];
    }
}
- (IBAction)air:(id)sender {
     [[[SoundCtrl alloc]init]playSystemSoundAtPath:[NSString stringWithFormat:@"%@/airplane.wav",previewedThemePath]];
}
- (IBAction)soundVol:(id)sender {
    [[[SoundCtrl alloc]init]playSystemSoundAtPath:[NSString stringWithFormat:@"%@/vol.wav",previewedThemePath]];
}
- (IBAction)appDel:(id)sender {
    [[[SoundCtrl alloc]init]playSystemSoundAtPath:[NSString stringWithFormat:@"%@/app_delete.wav",previewedThemePath]];
}

- (IBAction)action:(id)sender {
    [[[UIActionSheet alloc]initWithTitle:@"iSounds" delegate:self cancelButtonTitle:@"iSounds" destructiveButtonTitle:@"iSounds" otherButtonTitles:@"iSounds", nil]showInView:self.view];
}
- (IBAction)progUpdate:(id)sender {
    [progView setProgress:slider.value];
}

- (IBAction)BootSound:(id)sender {
    [[[SoundCtrl alloc]init]playSystemSoundAtPath:[NSString stringWithFormat:@"%@/startup.wav",previewedThemePath]];
}
- (IBAction)expandClock:(id)sender {
    smallLSClock.hidden = YES;
    bigLSClock.hidden = false;
    [[[SoundCtrl alloc]init]playSystemSoundAtPath:[NSString stringWithFormat:@"%@/showlsipod.wav",previewedThemePath]];
}

- (IBAction)collapseClock:(id)sender {
    bigLSClock.hidden = YES;
    smallLSClock.hidden = false;
    [[[SoundCtrl alloc]init]playSystemSoundAtPath:[NSString stringWithFormat:@"%@/hidelsipod.wav",previewedThemePath]];
}

- (IBAction)folder:(id)sender {
    if (folderOpen.hidden) {
        [[[SoundCtrl alloc]init]playSystemSoundAtPath:[NSString stringWithFormat:@"%@/folder.wav",previewedThemePath]];
        folderOpen.hidden = NO;
    } else {
        [[[SoundCtrl alloc]init]playSystemSoundAtPath:[NSString stringWithFormat:@"%@/folder_close.wav",previewedThemePath]];
        folderOpen.hidden = YES;
    }
}

- (IBAction)applaunch:(id)sender {
    [[[SoundCtrl alloc]init]playSystemSoundAtPath:[NSString stringWithFormat:@"%@/applaunch.wav",previewedThemePath]];
}

- (IBAction)didendonexit:(id)sender {
}
@end
