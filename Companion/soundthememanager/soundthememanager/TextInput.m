//
//  TextInput.m
//  soundthememanager
//
//  Created by Vladislav Korotnev on 05.12.11.
//  Copyright (c) 2011 Tigr@Soft. All rights reserved.
//

#import "TextInput.h"

@implementation TextInput
@synthesize delegate,defaultText;
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
}

- (void)viewDidUnload
{
    [field release];
    field = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void) viewDidAppear:(BOOL)animated   {
    if (defaultText != nil)
        [field setText:defaultText];
    [field becomeFirstResponder];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [field release];
    [super dealloc];
}
- (IBAction)done:(id)sender {
    [self.delegate textInputFinishedWithResult:field.text];
    [field resignFirstResponder];
    [self dismissModalViewControllerAnimated:TRUE];
}
@end
