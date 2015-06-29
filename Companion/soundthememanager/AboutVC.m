//
//  AboutVC.m
//  soundthememanager
//
//  Created by Jane Doe on 22.10.11.
//  Copyright (c) 2011 Tigr@Soft. All rights reserved.
//

#import "AboutVC.h"
#import "EAGLView.h"
@implementation AboutVC
@synthesize glView, musics;
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

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex   {
   /* if ([[alertView title]isEqualToString:@"This will appear only once"]) {
        [self myMovieFinishedCallback];
        [[[UIAlertView alloc]initWithTitle:@":( :( :(" message:@"Please watch it! I've put so much hard work into it! :P" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil]show];
    } */
}

- (void)viewDidLoad
{
    [super viewDidLoad];
      
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [animationSpot release];
    animationSpot = nil;
    [text release];
    text = nil;
    [nowPl release];
    nowPl = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (void) viewWillDisappear:(BOOL)animated {
     [[UIApplication sharedApplication]setIdleTimerDisabled:false];
    [[ChibiXM sharedInstance]stop];
}
- (void) viewWillAppear:(BOOL)animated {
    AVAudioSession *session = [AVAudioSession sharedInstance];
	
	NSError *err = nil;
	[session setActive: YES error: &err];	
	[session setCategory:AVAudioSessionCategoryPlayback error:&err];
	[session setPreferredHardwareSampleRate:44100.00 error:&err];
    musics = [[NSMutableArray alloc]init];
    NSMutableDictionary *track = [[NSMutableDictionary alloc]init];
    /*
    [track setObject:[XMFile songWithName:@"Music1.xm"] forKey:@"Player"];
    [track setObject:@"fluke01" forKey:@"Name"];
    [musics addObject:track];
    
    
    track = nil;
    track = [[NSMutableDictionary alloc]init];
    [track setObject:[XMFile songWithName:@"Music2.xm"] forKey:@"Player"];
    [track setObject:@"The Rock" forKey:@"Name"];
    [musics addObject:track];
    
    track = nil;
    track = [[NSMutableDictionary alloc]init];
    [track setObject:[XMFile songWithName:@"Music3.xm"] forKey:@"Player"];
    [track setObject:@"Unknown track from the Overscan demo" forKey:@"Name"];
    [musics addObject:track];
    */
    track = nil;
    track = [[NSMutableDictionary alloc]init];
    [track setObject:[XMFile songWithName:@"Music4.xm"] forKey:@"Player"];
    [track setObject:@"Stop the watch!" forKey:@"Name"];
    [musics addObject:track];
    
    track = nil;
    track = [[NSMutableDictionary alloc]init];
    [track setObject:[XMFile songWithName:@"Music5.xm"] forKey:@"Player"];
    [track setObject:@"Lambada! by SofT MANiAC" forKey:@"Name"];
    [musics addObject:track];
    
    /*
    track = nil;
    track = [[NSMutableDictionary alloc]init];
    [track setObject:[XMFile songWithName:@"Music6.xm"] forKey:@"Player"];
    [track setObject:@"Unknown by Grand Lord team" forKey:@"Name"];
    [musics addObject:track];
    */
    track = nil;
    track = [[NSMutableDictionary alloc]init];
    [track setObject:[XMFile songWithName:@"Music7.xm"] forKey:@"Player"];
    [track setObject:@".forgotten city." forKey:@"Name"];
    [musics addObject:track];
    
    track = nil;
    track = [[NSMutableDictionary alloc]init];
    [track setObject:[XMFile songWithName:@"Music8.xm"] forKey:@"Player"];
    [track setObject:@"tPORt - Afterburner." forKey:@"Name"];
    [musics addObject:track];
    [musics retain];
    NSUInteger randomIndex = 2;
    NSDictionary *randomSong = [musics objectAtIndex:randomIndex];
    
    [nowPl setTitle:[randomSong objectForKey:@"Name"]];
    
	[[ChibiXM sharedInstance] play:[randomSong objectForKey:@"Player"]];
	glView = [[EAGLView alloc]init];
	glView.player = [ChibiXM sharedInstance];
	glView.delegate = self;
    [glView startAnimation];
    [glView setFrame:animationSpot.frame];
    [animationSpot addSubview:glView];
    [[UIApplication sharedApplication]setIdleTimerDisabled:true];
}


- (IBAction)myMovieFinishedCallback:(id)sender {
    [[UIApplication sharedApplication]setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    [self dismissModalViewControllerAnimated:TRUE];
}

- (IBAction)otherSong:(id)sender {
    [[ChibiXM sharedInstance]stop];
    NSUInteger randomIndex = arc4random() % [musics count];
    NSDictionary *randomSong = [musics objectAtIndex:randomIndex];
    
    [nowPl setTitle:[randomSong objectForKey:@"Name"]];
    
	[[ChibiXM sharedInstance] play:[randomSong objectForKey:@"Player"]];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [animationSpot release];
    [text release];
    [nowPl release];
    [super dealloc];
}
- (IBAction)donate:(id)sender {
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"http://vladkorotnev.github.com/donate"]];
}
@end
