//
//  DownloadView.h
//  soundthememanager
//
//  Created by Jane Doe on 21.10.11.
//  Copyright (c) 2011 Tigr@Soft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "ASIHTTPRequestDelegate.h"
@interface DownloadView : UIViewController <UIAlertViewDelegate,ASIHTTPRequestDelegate,ASIProgressDelegate> {
    NSString *urlToUseAfterPopup;
    NSString *themenameforinstall;
    ASIHTTPRequest *request;
    bool isDLing;
    IBOutlet UITextView *log;
    IBOutlet UILabel *curStat;
    IBOutlet UILabel *topText;
    IBOutlet UIButton *cancelButton;
    IBOutlet UIProgressView *progress;
}
- (void)unzipFileToFolderNamed:(NSString *)themename;
@property (nonatomic,retain)  NSString *urlToUseAfterPopup;
@property (nonatomic,retain)  NSString *themenameforinstall;
@property (nonatomic,retain) ASIHTTPRequest *DLrequest;
@end
