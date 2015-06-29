//
//  Piracy.m
//  soundthememanager
//
//  Created by Jane Doe on 06.11.11.
//  Copyright (c) 2011 Tigr@Soft. All rights reserved.
//

#import "Piracy.h"

@implementation Piracy
@synthesize titleFor;
@synthesize descrippy;
@synthesize delegate;

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
    // Do any additional setup after loading the view from its nib.
    [descrippyView setText:descrippy];
    [descrippyView setEditable:NO];
    [titleLabel setText:titleFor];

}

- (void)viewDidUnload
{
    [titleLabel release];
    titleLabel = nil;
    [descrippyView release];
    descrippyView = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (IBAction)uhNo:(id)sender {
    void (^done)(void) = nil;
    done = ^{
         [self.delegate weHaveFinished];
    };
    [self dismissViewControllerAnimated:TRUE completion:done];
}
- (IBAction)installUpdate:(id)sender {
    if ([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"cydia://package/com.vladkorotnev.isounds"]]) {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"cydia://package/com.vladkorotnev.isounds"]];
    } else {
        [[[UIAlertView alloc]initWithTitle:@"What?" message:@"Can't open cydia:// url" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil]show];
    }
}

- (void)viewDidAppear:(BOOL)animated {
}

- (void)viewDidDisappear:(BOOL)animated {
   
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [titleLabel release];
    [descrippyView release];
    [super dealloc];
}
@end
