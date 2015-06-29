//
//  SoundCombinator.m
//  soundthememanager
//
//  Created by Vladislav Korotnev on 05.12.11.
//  Copyright (c) 2011 Tigr@Soft. All rights reserved.
//

#import "SoundCombinator.h"
#import "SoundSetChooser.h"
@implementation SoundCombinator
@synthesize newSet, soundList, newSetName,delegate;
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

    soundList = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"SoundList" ofType:@"plist"]];
    [soundList retain];
    newSet = [[NSMutableDictionary alloc]init];
    
    
    for (NSDictionary *name in soundList) {
        [newSet setObject:@"None" forKey:[name objectForKey:@"Name"]];
    }
    
    [newSet retain];
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [table release];
    table = nil;
    [bip release];
    bip = nil;
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [newSet count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    NSDictionary *curName = [soundList objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [newSet objectForKey:[curName objectForKey:@"Name"]];
    cell.textLabel.text = [curName objectForKey:@"Name"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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
    if ([[[soundList objectAtIndex:indexPath.row]objectForKey:@"File"]isEqualToString:@"message.txt"]) {
        NSLog(@"Edit author message");
        TextInput *msg = [[TextInput alloc]init];
        if (![[tableView cellForRowAtIndexPath:indexPath].textLabel.text isEqualToString:@"None"]) {
            [msg setDefaultText:[tableView cellForRowAtIndexPath:indexPath].detailTextLabel.text];
        }
        [msg setDelegate:self];
        [msg setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
        [self presentModalViewController:msg animated:true];
        
    } else {
        SoundSetChooser *choice = [[SoundSetChooser alloc]init];
        [choice setDelegate:self];
        [choice setUseFilter:true];
        [choice setFileExistsFilter:[[soundList objectAtIndex:indexPath.row]objectForKey:@"File"]];
        [choice setTitle:[[soundList objectAtIndex:indexPath.row]objectForKey:@"Name"]];
        [self presentModalViewController:choice animated:true];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}

- (IBAction)goaway:(id)sender {
        [self.delegate soundCombinatorIsExiting];
    [self dismissModalViewControllerAnimated:TRUE];
}

- (void)textInputFinishedWithResult:(NSString *)result {
    [newSet setObject:result forKey:@"Message"];
    [table reloadData];
}

- (void)SetChooserControllerDidFinish:(SoundSetChooser *)controller withSoundSet:(NSString *)name {
    [newSet setObject:name forKey:[controller title]];
    [table reloadData];
}
- (void)SetChooserControllerDidCancel: (SoundSetChooser *)who{
    [newSet setObject:@"None" forKey:[who title]];
    [table reloadData];
}

- (IBAction)build:(id)sender {
    UIAlertView *already = [[UIAlertView alloc]initWithTitle:@"Name this soundset" message:@"Enter a name to use:" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    [already addTextFieldWithValue:@"" label:@"Name"];
    [already show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([alertView.title isEqualToString:@"Name this soundset"]) {
        if (buttonIndex != alertView.cancelButtonIndex) {
            // install
            UITextField *textField = [alertView textFieldAtIndex:0];
            NSFileManager *fm = [NSFileManager defaultManager];
            if ([fm fileExistsAtPath:[NSString stringWithFormat:@"/var/mobile/Library/iSounds/%@",textField.text]]) {
                [[[UIAlertView alloc]initWithTitle:@"Error." message:@"A soundset with that name already exists." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Rename", nil]show];
                return;
            }
            
            [bip setHidden:false];
            newSetName = textField.text;
            [newSetName retain];
            [self performSelector:@selector(buildCarefully) withObject:nil afterDelay:2];
            
        } else {
            // don't
            [bip setHidden:true];
            return;
        }
    }
    
    if ([alertView.title isEqualToString:@"Error."] && (buttonIndex != alertView.cancelButtonIndex)) {
        [self build:self];
    } else if ([alertView.title isEqualToString:@"Error."] && (buttonIndex == alertView.cancelButtonIndex))  {
        [bip setHidden:true];
    }
    
    [alertView release];
}

- (void) buildCarefully {
    NSString *escThemename = [newSetName stringByReplacingOccurrencesOfString:@" " withString:@"\\ "];
    escThemename = [escThemename stringByReplacingOccurrencesOfString:@"." withString:@""];
    escThemename = [escThemename stringByReplacingOccurrencesOfString:@":" withString:@""];
    escThemename = [escThemename stringByReplacingOccurrencesOfString:@"/" withString:@""];
    escThemename = [escThemename stringByReplacingOccurrencesOfString:@"!" withString:@""];
    NSString *fullNewPath = [NSString stringWithFormat:@"/var/mobile/Library/iSounds/%@",escThemename];
    NSString *mkcmd = [NSString stringWithFormat:@"mkdir %@",fullNewPath];
    system([mkcmd UTF8String]);
    for (NSDictionary *currentItem in soundList){
        NSLog(@"Parsing object %@ of value %@",[currentItem objectForKey:@"Name"],[newSet objectForKey:[currentItem objectForKey:@"Name"]]);
        NSString *currentItemName = [currentItem objectForKey:@"Name"];
        NSLog(@"currentItemName = %@",currentItemName);
        NSString *currentItemValue = [newSet objectForKey:currentItemName];
        NSLog(@"currentItemValue = %@",currentItemValue);
        NSLog(@"Not escaped file is %@",[currentItem objectForKey:@"File"]);
        NSString *currentItemFile = [currentItem objectForKey:@"File"];
        NSLog(@"Escaped file is %@",currentItemFile);
        if([currentItemValue isEqualToString:@"None"]) {
            NSLog(@"Object %@ is with value %@ - skipping",currentItemName,currentItemValue);
        }else if ([[currentItem objectForKey:@"File"]isEqualToString:@"message.txt"]) {
            NSLog(@"Packing message...");
            [currentItemValue writeToFile:[NSString stringWithFormat:@"%@/%@",[NSString stringWithFormat:@"/var/mobile/Library/iSounds/%@",newSetName],[currentItem objectForKey:@"File"]] atomically:FALSE encoding:NSUTF8StringEncoding error:nil];
        } else {
            
            NSLog(@"Packaging %@...",[currentItem objectForKey:@"File"]);
            
            NSFileManager *fm = [NSFileManager defaultManager];
            [fm copyItemAtPath:[NSString stringWithFormat:@"/var/mobile/Library/iSounds/%@/%@",[newSet objectForKey:currentItemName],[currentItem objectForKey:@"File"]] toPath:[NSString stringWithFormat:@"%@/%@",[NSString stringWithFormat:@"/var/mobile/Library/iSounds/%@",newSetName],[currentItem objectForKey:@"File"]] error:nil];
        }
        
    }
    [bip setHidden:true];
    [self dismissModalViewControllerAnimated:true];
    [self.delegate soundCombinatorIsExiting];
}

- (void)dealloc {
    [table release];
    [bip release];
    [super dealloc];
}
@end
