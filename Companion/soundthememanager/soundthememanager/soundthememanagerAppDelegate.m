//
//  soundthememanagerAppDelegate.m
//  soundthememanager
//
//  Created by Vladislav on 18.07.11.
//  Copyright 2011 Tigr@Soft. All rights reserved.
//
#import "DownloadView.h"
#import "EncryptionModule.h"
#import "soundthememanagerAppDelegate.h"
#define CURVER @"lxxt>33mw4yrhw2xo3etthexe3gyvziv2tpmwx"
#define CRYPTR [EncryptionModule new]
#import "MainViewController.h"

@implementation soundthememanagerAppDelegate


@synthesize window=_window;

@synthesize mainViewController=_mainViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    // Add the main view controller's view to the window and display.
/* #ifdef __BETA__
    NSDictionary *curv = [NSDictionary dictionaryWithContentsOfURL:[NSURL URLWithString:[CRYPTR decryptString:CURVER withOffset:4]]];
    NSLog(@"%@",curv);
 
    NSLog(@"The beta is %@",[curv objectForKey:@"BetaAvailableToPublic"]);
    if ([[curv objectForKey:@"BetaAvailableToPublic"]isEqualToString:@"NO"]) {
        NSLog(@"Beta is ended!");
        UIAlertView *hello = [[UIAlertView alloc]initWithTitle:@"Thank you!" message:@"iSounds is out of beta now. Thanks for your betatesting. This beta has expired. You can get iSounds on cydia for just $1.99." delegate:self cancelButtonTitle:nil otherButtonTitles:@"Get iSounds on Cydia",nil];
    	[hello show];
    	[hello release];
        system("rm -rf /var/mobile/Library/iSounds/.InUse");
        return YES;
    } else
        NSLog(@"Beta still goes on...");
#endif */

    NSFileManager *fm=[NSFileManager defaultManager];
    system("mkdir  /var/mobile/Library/iSounds/.InUse");
    if(![fm fileExistsAtPath:@"/Library/MobileSubstrate/DynamicLibraries/iSounds.dylib"]){
        UIAlertView *hello = [[UIAlertView alloc]initWithTitle:@"Error" message:@"iSounds DyLib extension not found. Reinstall iSounds from Cydia." delegate:self cancelButtonTitle:nil otherButtonTitles:@"Cydia"];
    	[hello show];
    	[hello release];
    } else {
        [self.window addSubview:_mainViewController.view];
        if([[NSUserDefaults standardUserDefaults]boolForKey:@"notFirstLaunch"]) {
            [[[UIAlertView alloc]initWithTitle:@"iSounds" message:@"Thanks for using iSounds. Since this is completely adfree and free, please consider donating so I can pay my bills and make more tweaks. Thanks!" delegate:self cancelButtonTitle:@"NO!" otherButtonTitles:@"Donate", nil]show];
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"notFirstLaunch"];
        }
    }
    [self.window makeKeyAndVisible];
    
         return YES;
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex   {
    if([alertView.title isEqualToString:@"Error"]){
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"cydia://package/com.vladkorotnev.isounds"]];
    }
    if ([alertView.title isEqualToString:@"iSounds" ] && (alertView.cancelButtonIndex != buttonIndex)){
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"http://vladkorotnev.github.com/donate"]];
    }
    
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

/* - (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    NSString *text = [[url host] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"Got scheme %@",url.scheme);
    if ([[url scheme]isEqualToString:@"isrepo"]) {
        NSLog(@"iSounds Repo scheme");
    }
    if ([[url scheme]isEqualToString:@"isset"]) {
        NSLog(@"iSoundSet scheme");
        DownloadView *newDownload = [[DownloadView alloc]init];
        [newDownload setUrlToUseAfterPopup:text];
        [newDownload setThemenameforinstall:@"From website"];
        [newDownload setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
        [self presentModalViewController:newDownload animated:true];
    }
    
    return YES;
} */

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)dealloc
{
    [_window release];
    [_mainViewController release];
    [super dealloc];
}

@end
