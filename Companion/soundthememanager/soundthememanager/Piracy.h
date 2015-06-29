//
//  Piracy.h
//  soundthememanager
//
//  Created by Jane Doe on 06.11.11.
//  Copyright (c) 2011 Tigr@Soft. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol UpdViewDelegate;
@interface Piracy : UIViewController

{
    NSString *titleFor;
    NSString *descrippy;
    id <UpdViewDelegate> delegate;
    IBOutlet UILabel *titleLabel;
    IBOutlet UITextView *descrippyView;
}
@property (nonatomic,retain) NSString *titleFor;
@property (nonatomic,retain) NSString *descrippy;
@property (nonatomic,retain) id <UpdViewDelegate> delegate;

@end

@protocol UpdViewDelegate
@required
- (void)weHaveFinished;
@end