//
//  MainViewController.m
//  soundthememanager
//
//  Created by Vladislav on 18.07.11.
//  Copyright 2011 Tigr@Soft. All rights reserved.
//

#import "MainViewController.h"
#define CYSTORE [[CyStoreCheck alloc]init]

@implementation MainViewController
@synthesize tableVw;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"didShowAdPlease"]!=true){ 
        [[NSUserDefaults standardUserDefaults]setBool:true forKey:@"didShowAdPlease"];
        [[[UIAlertView alloc]initWithTitle:@"If you like iSounds," message:@"Please tap on ads in the installed soundset list! I appreciate it!" delegate:self cancelButtonTitle:@"Will do!" otherButtonTitles:nil]show];
    } 
//#ifdef __BETA__
//#warning BETA BUILD!!!!
    [titleVieww setTitle:@"iSounds Beta"];
// #endif 
    
    NSFileManager *fm = [NSFileManager defaultManager];
if([fm fileExistsAtPath:@"/var/mobile/Library/Preferences/isounds_haptic.flag"])
    [hapticSwitch setOn:TRUE];
    
    [super viewDidLoad];
 
}




// Rest



- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller
{
    [wereLoading setHidden:true];
    [self dismissModalViewControllerAnimated:YES];
    [tableVw reloadData];
}

- (IBAction)respring:(id)sender {
    [[[UIAlertView alloc]initWithTitle:@"Respring?" message:@"Make sure you saved your data in open apps, and all downloads are finished" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil]show];
}

- (IBAction)createNew:(id)sender {
    SoundCombinator *combi = [[SoundCombinator alloc]init];
    [combi setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [combi setDelegate:self];
    [self presentModalViewController:combi animated:TRUE];
}

- (IBAction)hapticToggle:(id)sender {
    NSFileManager *fm = [NSFileManager defaultManager];
    if([fm fileExistsAtPath:@"/var/mobile/Library/Preferences/isounds_haptic.flag"]){
        [fm removeItemAtPath:@"/var/mobile/Library/Preferences/isounds_haptic.flag" error:nil];
    } else 
        [@"Why are you reading this?" writeToFile:@"/var/mobile/Library/Preferences/isounds_haptic.flag" atomically:TRUE encoding:NSUTF8StringEncoding error:nil];
        
}

- (IBAction)hapticPress:(id)sender {
    if (hapticPanel.hidden) {
        [hapticPanel setHidden:FALSE];
        void (^animations)(void) = nil;
        animations = ^{
            [hapticPanel setAlpha:1.0f];
            [hapticLabel setAlpha:1.0f];
            [hapticSwitch setAlpha:1.0f];
        };
        [UIView animateWithDuration:2 animations:animations]; 
    } else {
        [hapticPanel setHidden:TRUE];
        void (^animations)(void) = nil;
        animations = ^{
            [hapticPanel setAlpha:0.0f];
            [hapticLabel setAlpha:0.0f];
            [hapticSwitch setAlpha:0.0f];
        };
        [UIView animateWithDuration:2 animations:animations];
    }

}

-(void) soundCombinatorIsExiting {
    [tableVw reloadData];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([[alertView title]isEqualToString:@"Respring?"] && buttonIndex != alertView.cancelButtonIndex) {
        system("killall SpringBoard");
    }
}

- (IBAction)showInfo:(id)sender
{    
    if (sender == storeButton) {
        [wereLoading setHidden:false];
        [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(showInfo:) userInfo:self repeats:false];
        return;
    }
    FlipsideViewController *controller = [[FlipsideViewController alloc] initWithNibName:@"FlipsideView" bundle:nil];
    controller.delegate = self;
    
    controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController:controller animated:YES];
    
    [controller release];
}

- (IBAction)editTable:(id)sender {

    AboutVC *abt = [[AboutVC alloc]init];
    [abt setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [self presentModalViewController:abt animated:true];
}

- (IBAction)disable:(id)sender {
    system("rm -rf /var/mobile/Library/iSounds/.InUse/*");
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Disabled" message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [alert release];
    
}

- (IBAction)themeTest:(id)sender {
    Previewer *test = [[Previewer alloc]init];
    [test setUseAltTheme:NO];
    [test setPreviewedThemePath:@"/var/mobile/Library/iSounds/.InUse"];
    [test setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self presentModalViewController:test animated:true];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

-(void)viewDidAppear:(BOOL)animated {
    if (![[[UIDevice currentDevice]model]isEqualToString:@"iPhone"]) {
        [hapticSwitch setEnabled:NO];
        [hapticLabel setText:@"Sorry, you need an iPhone to use this"];
    } else
        NSLog(@"Haptic supported, it's an iPhone");
    
    /* NSDate *today = [NSDate date];
    NSDate *lastDay = [[NSUserDefaults standardUserDefaults]objectForKey:@"LastCheck"];
    
    unsigned int flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:flags fromDate:today];
    NSDate* todayDateOnly = [calendar dateFromComponents:components];
    
    components = [calendar components:flags fromDate:lastDay];
    NSDate* lastDateOnly = [calendar dateFromComponents:components];
    
    if (!didLic && ![todayDateOnly isEqualToDate:lastDateOnly]) {
        [self presentModalViewController:CYSTORE animated:true];
        didLic = YES;
        [[NSUserDefaults standardUserDefaults]setObject:todayDateOnly forKey:@"LastCheck"];
    } */
}
- (IBAction)updateForce:(id)sender {
    NSDate *today = [NSDate date];
    
    unsigned int flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:flags fromDate:today];
    NSDate* todayDateOnly = [calendar dateFromComponents:components];

    [self presentModalViewController:CYSTORE animated:true];
    didLic = YES;
    [[NSUserDefaults standardUserDefaults]setObject:todayDateOnly forKey:@"LastCheck"]; 
}



- (void)viewDidUnload
{
    [navbar release];
    navbar = nil;
    [wereLoading release];
    wereLoading = nil;
    [storeButton release];
    storeButton = nil;
    [titleVieww release];
    titleVieww = nil;
    [canUpdateBadge release];
    canUpdateBadge = nil;
    [hapticButton release];
    hapticButton = nil;
    [hapticPanel release];
    hapticPanel = nil;
    [hapticSwitch release];
    hapticSwitch = nil;
    [hapticLabel release];
    hapticLabel = nil;
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc
{
    [navbar release];
    [wereLoading release];
    [storeButton release];
    [titleVieww release];
    [canUpdateBadge release];
    [hapticButton release];
    [hapticPanel release];
    [hapticSwitch release];
    [hapticLabel release];
    [super dealloc];
}


//---------------------------------
// Table
//---------------------------------

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *sets = [fm contentsOfDirectoryAtPath:@"/var/mobile/Library/iSounds" error:nil];
    // Return the number of rows in the section.
    return ([sets count]);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *sets = [fm contentsOfDirectoryAtPath:@"/var/mobile/Library/iSounds" error:nil];
    if (indexPath.row == 0) {
        [cell.textLabel setText:@"Disable"];
    } else {
        [cell.textLabel setText:[sets objectAtIndex:(indexPath.row)]];
    }
  
    
    return cell;
}


 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
     if ([[[[tableView cellForRowAtIndexPath:indexPath]textLabel]text]isEqualToString:@"Disable"] || [[[[tableView cellForRowAtIndexPath:indexPath]textLabel]text]isEqualToString:@"Preview current theme"] ) 
         return NO;
     
     return YES;
 }
 


 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
     //[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
     NSString *themeNameEscaped = [[tableView cellForRowAtIndexPath:indexPath].textLabel.text stringByReplacingOccurrencesOfString:@" " withString:@"\\ "];
     NSString *command = [NSString stringWithFormat:@"rm -rf /var/mobile/Library/iSounds/%@",themeNameEscaped];
     NSLog(@"Will do this: %@",command);
     system([command UTF8String]);
     
     [[[UIAlertView alloc]initWithTitle:@"Deleted" message:@"If this theme was selected, it will still work until you select a new one" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil]show];
     [tableView reloadData];
 }     
 }
 

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        [tableView deselectRowAtIndexPath:indexPath animated:true];
    NSLog(@"%d",indexPath.row);
    if ([[[[tableVw cellForRowAtIndexPath:indexPath]textLabel]text]isEqualToString:@"Disable"]) {
        [self disable:self];
        return;
    } else {
        NSString *escapedShit = [[tableVw cellForRowAtIndexPath:indexPath].textLabel.text stringByReplacingOccurrencesOfString:@" " withString:@"\\ "];
        NSString *command = [NSString stringWithFormat:@"cp -R /var/mobile/Library/iSounds/%@/* /var/mobile/Library/iSounds/.InUse",escapedShit];
        system("rm -rf /var/mobile/Library/iSounds/.InUse");
        system("mkdir  /var/mobile/Library/iSounds/.InUse");
        system([command UTF8String]);
        NSFileManager *fm = [NSFileManager defaultManager];
        NSString *whatsinside = @"";
        if ([fm fileExistsAtPath:@"/var/mobile/Library/iSounds/.InUse/message.txt"]) {
            whatsinside = @"Author's message: \n";  
            whatsinside = [whatsinside stringByAppendingString:[NSString stringWithContentsOfFile:@"/var/mobile/Library/iSounds/.InUse/message.txt" encoding:NSUTF8StringEncoding error:nil]];
            whatsinside = [whatsinside stringByAppendingString:@"\n\n"];
        } 
        whatsinside = [whatsinside stringByAppendingString:@"Respring to apply!"];
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"Installed soundset %@",[tableVw cellForRowAtIndexPath:indexPath].textLabel.text] message:whatsinside delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        
    }

}


@end
