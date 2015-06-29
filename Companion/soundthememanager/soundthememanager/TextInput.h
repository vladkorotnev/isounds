//
//  TextInput.h
//  soundthememanager
//
//  Created by Vladislav Korotnev on 05.12.11.
//  Copyright (c) 2011 Tigr@Soft. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TextInputProtocol;
@interface TextInput : UIViewController {
    NSString *defaultText;
    IBOutlet UITextView *field;
}
- (IBAction)done:(id)sender;
@property (nonatomic,assign) id<TextInputProtocol> delegate;
@property (nonatomic,retain) NSString *defaultText;
@end

@protocol TextInputProtocol
@optional
- (void)textInputFinishedWithResult:(NSString *)result;
@end