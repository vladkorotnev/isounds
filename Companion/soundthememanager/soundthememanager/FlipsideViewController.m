//
//  FlipsideViewController.m
//  soundthememanager
//
//  Created by Vladislav on 18.07.11.
//  Copyright 2011 Tigr@Soft. All rights reserved.
//

#import "FlipsideViewController.h"


@implementation FlipsideViewController


@synthesize delegate=_delegate;
@synthesize currentStoreItems;
@synthesize repo;
@synthesize storeRepo;
@synthesize storeFooterImg;
@synthesize storeHeadImg;
- (void)dealloc
{
    [_alert release];
    [navitem release];
    [table release];
    [AdSpot release];
    [wereLoading release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor viewFlipsideBackgroundColor];  
    repo = @"http://ig33kstas.com/isounds/home/appdata/soundrepo.plist";
    storeRepo = [NSDictionary dictionaryWithContentsOfURL:[NSURL URLWithString:repo]];
    
    if (storeRepo == nil || [[storeRepo objectForKey:@"Name"]isEqualToString:@""]) {
        [[[UIAlertView alloc]initWithTitle:@"Ouch!" message:@"iSoundStore not available" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil]show];
        
        return;
    }
    NSLog(@"Didload");
    [navitem setTitle:[storeRepo objectForKey:@"Name"]];
  
       // Specify the ad's "unit identifier." This is your AdMob Publisher ID.

    
    storeHeadImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[storeRepo objectForKey:@"TitleImg"]]]];
      storeFooterImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[storeRepo objectForKey:@"FooterImg"]]]];
    [storeHeadImg retain];
    [storeFooterImg retain];

    [storeRepo retain];
    [wereLoading setHidden:true];
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    [self done:self];
}

- (IBAction)openOtherRepo:(id)sender {
    OpenOtherRepoView *repoopen = [[OpenOtherRepoView alloc]init];
    [repoopen setRepo:repo];
    [repoopen setDelegate:self];
    [self presentModalViewController:repoopen animated:true];
    
}

- (void)viewDidUnload
{

    [navitem release];
    navitem = nil;
    [table release];
    table = nil;
    [AdSpot release];
    AdSpot = nil;
    [wereLoading release];
    wereLoading = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"Tablecount");
    NSArray *dic = [storeRepo objectForKey:@"AvailSounds"];
    return [dic count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Cell should draw:%@",[NSString stringWithFormat:@"%i",indexPath.row+1]);
    NSArray *dic = [storeRepo objectForKey:@"AvailSounds"];
    NSDictionary *dics = [dic objectAtIndex:indexPath.row];
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    NSLog(@"Cell drawing");
    // Configure the cell...
        [cell.textLabel setText:[dics objectForKey:@"Name"]];
    return cell;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSLog(@"Header");
    UIImageView *img = [[UIImageView alloc]initWithImage:storeHeadImg];
    return img;
} 

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [storeHeadImg size].height;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    NSLog(@"Footer");
    UIImageView *img = [[UIImageView alloc]initWithImage:storeFooterImg];
    return img;
} 

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
 
    return [storeFooterImg size].height;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSArray *dic = [storeRepo objectForKey:@"AvailSounds"];
    NSDictionary *dics = [dic objectAtIndex:indexPath.row];
    NSString *urllab = [dics objectForKey:@"URL"];
    NSLog(@"urllab txt is %@",urllab);
    DownloadView *newDownload = [[DownloadView alloc]init];
    [newDownload setUrlToUseAfterPopup:urllab];
    [newDownload setThemenameforinstall:[table cellForRowAtIndexPath:indexPath].textLabel.text];
    [newDownload setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    [self presentModalViewController:newDownload animated:true];
  
}

#pragma mark - Actions

- (IBAction)done:(id)sender
{
    [self.delegate flipsideViewControllerDidFinish:self];
}

- (void)RepoChooserControllerDidFinish:(OpenOtherRepoView *)controller withRepo:(NSString *)url {
    NSLog(@"something was selected");
    [repo release];
    repo = nil;
    repo = url;
    [storeRepo release];
    storeRepo = nil;
    storeRepo = [NSDictionary dictionaryWithContentsOfURL:[NSURL URLWithString:repo]];
    NSLog(@"load repo %@",url);
    [navitem setTitle:[storeRepo objectForKey:@"Name"]];

    [storeHeadImg release];
    storeHeadImg = nil;
    [storeFooterImg release];
    storeFooterImg = nil;
    storeHeadImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[storeRepo objectForKey:@"TitleImg"]]]];
    storeFooterImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[storeRepo objectForKey:@"FooterImg"]]]];
    [storeHeadImg retain];
    [storeFooterImg retain];

    
    [storeRepo retain];
    [table reloadData];
}
@end
