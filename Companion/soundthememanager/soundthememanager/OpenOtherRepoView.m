//
//  OpenOtherRepoView.m
//  soundthememanager
//
//  Created by Jane Doe on 20.10.11.
//  Copyright (c) 2011 Tigr@Soft. All rights reserved.
//

#import "OpenOtherRepoView.h"

@implementation OpenOtherRepoView
@synthesize editbtn;
@synthesize add;
@synthesize repo;
@synthesize delegate;
@synthesize storeRepo;
@synthesize commuRepo;
@synthesize userRepos;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super init];
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
    storeRepo = [NSDictionary dictionaryWithContentsOfURL:[NSURL URLWithString:repo]];
    commuRepo = [NSDictionary dictionaryWithContentsOfURL:[NSURL URLWithString:@"http://isounds.tk/appdata/community.plist"]];
    
    if ([[NSFileManager defaultManager]fileExistsAtPath:@"/var/mobile/Library/Preferences/com.isounds.repos.plist"]) {
        userRepos = [NSMutableArray arrayWithContentsOfFile:@"/var/mobile/Library/Preferences/com.isounds.repos.plist"];
    } else {
        userRepos = [[NSMutableArray alloc]init];
    }
    [userRepos retain];
    [storeRepo retain];
    [commuRepo retain];
}

- (void)viewDidUnload
{
    [table release];
    table = nil;
    [wereLoading release];
    wereLoading = nil;
    [self setAdd:nil];
    [self setEditbtn:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            //Friends
            NSLog(@"Cell should draw:%@",[NSString stringWithFormat:@"%i",1]);

            NSArray *dic = [storeRepo objectForKey:@"FriendsRepos"];
            return [dic count];
            break;
            
        case 1:
            //Official
            NSLog(@"Cell should draw:%@",[NSString stringWithFormat:@"%i",1]);
            NSArray *comdic = [commuRepo objectForKey:@"Repos"];
            return [comdic count];
            break;
        case 2:
            //User
            return [userRepos count];
            break;
        default:
            break;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSLog(@"Section %i wants a title",section);
    switch (section) {
        case 0:
            //Friends
            return @"This repo's friends";
            break;
            
        case 1:
            //Official
            return @"Official iSounds community repos";
            break;
        case 2:
            //User
            return @"User-defined repos";
            break;
            
        default:
            return @"Lolwut?";
            break;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    UILabel *lbl = [[UILabel alloc]init];
    [lbl setHidden:true];
    [lbl setTag:1337];
    // Configure the cell...
    switch (indexPath.section) {
        case 0:
            //friends
            NSLog(@"Cell should draw:%@",[NSString stringWithFormat:@"%i",indexPath.row+1]);
            NSArray *dic = [storeRepo objectForKey:@"FriendsRepos"];
            NSDictionary *dics = [dic objectAtIndex:indexPath.row];
            [cell.textLabel setText:[dics objectForKey:@"Name"]];
            [lbl setText:[dics objectForKey:@"URL"]];
            break;
        case 1:
            //Official
            NSLog(@"Cell should draw:%@",[NSString stringWithFormat:@"%i",indexPath.row+1]);
            NSArray *comdic = [commuRepo objectForKey:@"Repos"];
            NSDictionary *comdics = [comdic objectAtIndex:indexPath.row];
            [cell.textLabel setText:[comdics objectForKey:@"Name"]];
            [lbl setText:[comdics objectForKey:@"URL"]];
            
            break;
        case 2:
            //user
            NSLog(@"Cell should draw:%@",[NSString stringWithFormat:@"%i",indexPath.row+1]);
            NSDictionary *repot = [userRepos objectAtIndex:0];
            
            [cell.textLabel setText:[repot objectForKey:@"Name"]];
            [lbl setText:[repot objectForKey:@"URL"]];
            break;
            
        default:
            break;
    }
    if ([lbl.text isEqualToString:@"%INFO%"]) {
        [cell setUserInteractionEnabled:false];
        [cell.textLabel setTextColor:[UIColor grayColor]];
    }
    [cell addSubview:lbl];
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return (indexPath.section == 2);
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        //[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        [userRepos removeObjectAtIndex:indexPath.row];
        [userRepos writeToFile:@"/var/mobile/Library/Preferences/com.isounds.repos.plist" atomically:true];
        [userRepos retain];
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
    NSLog(@"Selected!");

    UILabel *urllab = (UILabel *)[[table cellForRowAtIndexPath:indexPath]viewWithTag:1337];
    [self.delegate RepoChooserControllerDidFinish:self withRepo:urllab.text];
    [self dismissModalViewControllerAnimated:YES];

}


- (IBAction)Cancel:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}
- (void)dealloc {
    [table release];
    [wereLoading release];
    [add release];
    [editbtn release];
    [super dealloc];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([alertView.title isEqualToString:@"Add new repo"] && buttonIndex != alertView.cancelButtonIndex) {
        UITextField *textField = [alertView textFieldAtIndex:0];
        NSDictionary *repoTemp = [NSDictionary dictionaryWithContentsOfURL:[NSURL URLWithString:textField.text]];
        if ([[repoTemp objectForKey:@"Name"]isEqualToString:@""]) {
            [[[UIAlertView alloc]initWithTitle:@"Error" message:@"Not a valid repo" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil]show];
            return;
        }
        NSLog(@"Repo ok");
        NSDictionary *temp = [NSDictionary dictionaryWithContentsOfURL:[NSURL URLWithString:textField.text]];
        NSDictionary *newOne = [[NSDictionary alloc]initWithObjects:[NSArray arrayWithObjects:textField.text,[temp objectForKey:@"Name"],nil] forKeys:[NSArray arrayWithObjects:@"URL",@"Name",nil]];
        [userRepos addObject:newOne];
        [userRepos writeToFile:@"/var/mobile/Library/Preferences/com.isounds.repos.plist" atomically:true];
         [userRepos retain];
        [table reloadData];
    }
}

- (IBAction)add:(id)sender {
    
    UIAlertView *already = [[UIAlertView alloc]initWithTitle:@"Add new repo" message:@"Enter a URL to the repo's plist:" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    [already addTextFieldWithValue:@"http://" label:@"http://isounds.repo.com/mySounds.plist"];
    [already show];
}
- (IBAction)editTable:(UIButton *)sender {
    if([table isEditing]) {
        NSLog(@"Will start edit");
        [editbtn setTitle:@"Done"];
        [editbtn setStyle:UIBarButtonItemStyleDone];
        [table setEditing:true animated:true];
    } else {
        NSLog(@"Will end edit");
        [editbtn setTitle:@"Edit"];
        [editbtn setStyle:UIBarButtonItemStyleBordered];
        [table setEditing:false animated:true];
    }
}
@end
