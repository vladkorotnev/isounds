//
//  DownloadView.m
//  soundthememanager
//
//  Created by Jane Doe on 21.10.11.
//  Copyright (c) 2011 Tigr@Soft. All rights reserved.
//

#import "DownloadView.h"

@implementation DownloadView
@synthesize urlToUseAfterPopup;
@synthesize DLrequest;
@synthesize themenameforinstall;
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
- (IBAction)close:(id)sender {
    if (isDLing) {
        [request cancel];
    }
    [self dismissModalViewControllerAnimated:true];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [log release];
    log = nil;
    [curStat release];
    curStat = nil;
    [cancelButton release];
    cancelButton = nil;
    [topText release];
    topText = nil;
    [progress release];
    progress = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
 
-(void)viewDidAppear:(BOOL)animated {
    NSLog(@"Will DL from %@ ",urlToUseAfterPopup);
    request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlToUseAfterPopup]];
    [request setDownloadDestinationPath:@"/var/mobile/Library/iSounds/.temp.zip"];
    [request setDelegate:self];
    [request setDownloadProgressDelegate:progress];
    isDLing = true;
    [topText setText:@"Installing"];
    [curStat setText:@"Downloading file..."];
    [request startAsynchronous];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)requestFinished:(ASIHTTPRequest *)request {
    isDLing = false;
    [log setText:[[log text]stringByAppendingString:@"\nDownload finished"]];
    [topText setText:@"Installing"];
    [curStat setText:@"Unpacking..."];
    [cancelButton setEnabled:false];
    [progress setProgress:0];
    [progress setProgress:1];
    [self unzipFileToFolderNamed:themenameforinstall];
    [log setText:[[log text]stringByAppendingString:@"\nDone"]];
    [topText setText:@"Installed"];
    [curStat setText:@"Done."];
}

- (void)unzipFileToFolderNamed:(NSString *)themename {
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:[NSString stringWithFormat:@"/var/mobile/Library/iSounds/%@",themename]] || [themename isEqualToString:@"From website"]) {
        [log setText:[[log text]stringByAppendingString:@"\nYou already have this soundset!"]];
        UIAlertView *already = [[UIAlertView alloc]initWithTitle:@"You already have this soundset" message:@"Enter a new name to install it:" delegate:self cancelButtonTitle:@"Don't install" otherButtonTitles:@"OK", nil];
        [already addTextFieldWithValue:@"" label:[NSString stringWithFormat:@"New name for %@",themename]];
        [already show];
        return;
    }
    NSString *escThemename = [themename stringByReplacingOccurrencesOfString:@" " withString:@"\\ "];
    escThemename = [escThemename stringByReplacingOccurrencesOfString:@"." withString:@""];
    escThemename = [escThemename stringByReplacingOccurrencesOfString:@":" withString:@""];
    escThemename = [escThemename stringByReplacingOccurrencesOfString:@"/" withString:@""];
    escThemename = [escThemename stringByReplacingOccurrencesOfString:@"!" withString:@""];
    NSString *cmd = [NSString stringWithFormat:@"unzip /var/mobile/Library/iSounds/.temp.zip -d /var/mobile/Library/iSounds/%@",escThemename];
    [log setText:[[log text]stringByAppendingString:@"\nUnpacking..."]];
    system([cmd UTF8String]);
    [log setText:[[log text]stringByAppendingString:@"\nMoving and cleaning..."]];
    system("rm /var/mobile/Library/iSounds/.temp.zip");
    [NSThread sleepForTimeInterval:1];
    [cancelButton setEnabled:true];
    [cancelButton setTitle:@"Close" forState:UIControlStateNormal];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([alertView.title isEqualToString:@"You already have this soundset"]) {
        if (buttonIndex != alertView.cancelButtonIndex) {
            // install
            UITextField *textField = [alertView textFieldAtIndex:0];
            [self unzipFileToFolderNamed:[textField text]];
        } else {
            // don't
            system("rm /var/mobile/Library/iSounds/.temp.zip");
            [NSThread sleepForTimeInterval:1];
            [self dismissModalViewControllerAnimated:TRUE];
        }
    }
    [alertView release];
}

- (void) requestFailed:(ASIHTTPRequest *)request {
    isDLing = false;
    [log setText:[[log text]stringByAppendingString:@"\nDownload FAILED"]];
    [topText setText:@"Failed!"];
    [topText setTextColor:[UIColor redColor]];
    [progress setProgress:0];
    [curStat setText:@"Error"];
    [cancelButton setEnabled:true];
    [cancelButton setTitle:@"Close" forState:UIControlStateNormal];
}

- (void)dealloc {
    [log release];
    [curStat release];
    [cancelButton release];
    [topText release];
    [progress release];
    [super dealloc];
}
@end
