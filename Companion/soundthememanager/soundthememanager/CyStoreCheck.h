//
//  CyStoreCheck.h
//  soundthememanager
//
//  Created by Jane Doe on 06.11.11.
//  Copyright (c) 2011 Tigr@Soft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Piracy.h"
@interface CyStoreCheck : UIViewController <UpdViewDelegate> {
    
    IBOutlet UILabel *text;
    IBOutlet UIActivityIndicatorView *spin;
}
- (void)hideSuccess;
- (void)hidePirat;
- (void)updCheck;
@end
