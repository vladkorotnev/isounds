#import "AudioMaster.h"
 
@implementation SoundCtrl
 
@synthesize soundFileURLRef;
@synthesize soundFileObject;
  
- (void) vibrate {
 
    AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
}
 
 - (void) playSystemSoundAtPath: (NSString *)path {
 NSFileManager *fm=[NSFileManager defaultManager];
    if([fm fileExistsAtPath:path]){

     // Create the URL for the source audio file. The URLForResource:withExtension: method is
    //    new in iOS 4.0.
    NSURL *tapSound   = [NSURL fileURLWithPath:path];
 
    // Store the URL as a CFURLRef instance
    self.soundFileURLRef = (CFURLRef) [tapSound retain];
 
    // Create a system sound object representing the sound file.
    AudioServicesCreateSystemSoundID (
    
        soundFileURLRef,
        &soundFileObject
    );
    
    AudioServicesPlaySystemSound (soundFileObject);
    }
    [fm release];
 }
 
 
 - (void) playAlertSoundAtPath: (NSString *)path { 
  NSFileManager *fm=[NSFileManager defaultManager];
    if([fm fileExistsAtPath:path]){
     // Create the URL for the source audio file. The URLForResource:withExtension: method is
    //    new in iOS 4.0.
    NSURL *tapSound   = [NSURL fileURLWithPath:path];
 
    // Store the URL as a CFURLRef instance
    self.soundFileURLRef = (CFURLRef) [tapSound retain];
 
    // Create a system sound object representing the sound file.
    AudioServicesCreateSystemSoundID (
    
        soundFileURLRef,
        &soundFileObject
    );
    
    AudioServicesPlayAlertSound (soundFileObject);
    }
    [fm release];
 }
 
 
- (void) dealloc {
 
    AudioServicesDisposeSystemSoundID (soundFileObject);
    CFRelease (soundFileURLRef);
    [super dealloc];
}
 
@end