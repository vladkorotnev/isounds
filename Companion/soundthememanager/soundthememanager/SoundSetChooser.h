//
//  SoundSetChooser.h
//  soundthememanager
//
//  Created by Vladislav Korotnev on 05.12.11.
//  Copyright (c) 2011 Tigr@Soft. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SetSelectionDelegate;

@interface SoundSetChooser : UIViewController <UITableViewDelegate,UITableViewDataSource>
{
    NSString *fileExistsFilter;
    bool useFilter;
    NSString *sndName;
    IBOutlet UINavigationItem *titleBar;
    NSMutableArray *goodSets;
}
- (IBAction)cancel:(id)sender;
@property (nonatomic,retain) NSString *fileExistsFilter;
@property (nonatomic) bool useFilter;
@property (nonatomic,retain) NSMutableArray *goodSets;
@property (nonatomic,retain) NSString *sndName;
@property (nonatomic, assign) id <SetSelectionDelegate> delegate;
@end

@protocol SetSelectionDelegate
@required
- (void)SetChooserControllerDidFinish:(SoundSetChooser *)controller withSoundSet:(NSString *)name;
- (void)SetChooserControllerDidCancel: (SoundSetChooser *)who;
@end
