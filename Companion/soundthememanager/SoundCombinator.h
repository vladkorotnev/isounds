//
//  SoundCombinator.h
//  soundthememanager
//
//  Created by Vladislav Korotnev on 05.12.11.
//  Copyright (c) 2011 Tigr@Soft. All rights reserved.
//
#import "TextInput.h"
#import <UIKit/UIKit.h>
#import "SoundSetChooser.h"
@protocol SoundCombinatorEvt;
@interface SoundCombinator : UIViewController <UITableViewDelegate,UITableViewDataSource,TextInputProtocol,SetSelectionDelegate,UIAlertViewDelegate>
{
    NSMutableDictionary *newSet;
    NSArray *soundList;
    IBOutlet UIView *bip;
    IBOutlet UITableView *table;
    NSString *newSetName;
    
}
- (IBAction)goaway:(id)sender;
- (void) buildCarefully;
- (IBAction)build:(id)sender;
@property (nonatomic,retain) NSMutableDictionary *newSet;
@property (nonatomic,retain) NSArray *soundList;
@property (nonatomic,retain) NSString *newSetName;
@property (nonatomic, assign) id<SoundCombinatorEvt> delegate;
@end

@protocol SoundCombinatorEvt
@required
-(void) soundCombinatorIsExiting;
@end