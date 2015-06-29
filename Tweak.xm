#import <AVFoundation/AVFoundation.h>
#import <objc/runtime.h>
#import <UIKit/UIKit.h>
#import "SndDelegate.h"
#import "AudioMaster.h"
#import "EncryptionModule.h"
#define FM [NSFileManager defaultManager]
#define CURVER @"lxxt>33mw4yrhw2xo3etthexe3gyvziv2tpmwx"
#define CRYPTR [EncryptionModule new]
#define snd [SoundCtrl alloc]

%hook SpringBoard
- (void)applicationDidFinishLaunching:(id)x {
    %orig;
        
        [snd playSystemSoundAtPath:@"/var/mobile/Library/iSounds/.InUse/startup.wav"];
}
%end

%hook SBApplicationIcon

-(void)launch {
[snd haptic];
%orig;  
        [snd playSystemSoundAtPath:@"/var/mobile/Library/iSounds/.InUse/applaunch.wav"];

}

%end

%hook SBFolderIcon
-(void)launch {
%orig;
        [snd haptic];
        [snd playSystemSoundAtPath:@"/var/mobile/Library/iSounds/.InUse/folder.wav"];
}
%end

%hook SBIconController


-(void)closeFolderAnimated:(BOOL)animated {
%orig;
	if(animated==TRUE) {
        [snd haptic];
        [snd playSystemSoundAtPath:@"/var/mobile/Library/iSounds/.InUse/folder_close.wav"];
	}
}

-(void)closeFolderAnimated:(BOOL)animated toSwitcher:(BOOL)switcher {
%orig;
if(animated==TRUE && switcher == TRUE) {
        [snd haptic];
        [snd playSystemSoundAtPath:@"/var/mobile/Library/iSounds/.InUse/folder_close.wav"];
}
}

-(void)uninstallIcon:(id)icon {
%orig;
       
        [snd playSystemSoundAtPath:@"/var/mobile/Library/iSounds/.InUse/app_delete.wav"];

}
-(void)uninstallIcon:(id)icon animate:(BOOL)animate {
if(animate) {
%orig;
        [snd haptic];
        [snd playSystemSoundAtPath:@"/var/mobile/Library/iSounds/.InUse/app_delete.wav"];
}
}

%end

%hook SBAwayLockBar
- (void)_cameraButtonHit:(id)arg1 {
%orig;
        [snd haptic];
        [snd playSystemSoundAtPath:@"/var/mobile/Library/iSounds/.InUse/applaunch.wav"];
}
%end

%hook SBAwayView

-(void)showMediaControls {
	%orig;
        [snd haptic];
        [snd playSystemSoundAtPath:@"/var/mobile/Library/iSounds/.InUse/showlsipod.wav"];
}

-(void)hideMediaControls {
//plays on lock
	%orig;
        [snd haptic];
        [snd playSystemSoundAtPath:@"/var/mobile/Library/iSounds/.InUse/hidelsipod.wav"];

}

%end


%hook SBPowerDownView
-(void)animateIn {
	%orig;
        [snd haptic];
        [snd playSystemSoundAtPath:@"/var/mobile/Library/iSounds/.InUse/powerdownview.wav"];

}

-(void)animateOut {
	%orig;
        [snd haptic];
        [snd playSystemSoundAtPath:@"/var/mobile/Library/iSounds/.InUse/powerdownviewout.wav"];

}

%end

%hook SBTelephonyManager

-(void)airplaneModeChanged {
		%orig;
[snd haptic];
        [snd playSystemSoundAtPath:@"/var/mobile/Library/iSounds/.InUse/airplane.wav"];
    	
}

%end

%hook SBVolumeHUDView

-(void)setProgress:(float)progress { 
    %orig;
[snd haptic];
        [snd playSystemSoundAtPath:@"/var/mobile/Library/iSounds/.InUse/vol.wav"];
    	
}

%end

%hook UIAlertView

-(void)show {
[snd haptic];
        [snd playSystemSoundAtPath:@"/var/mobile/Library/iSounds/.InUse/alert.wav"];
    	%orig;
}

- (void)popupAlertAnimated:(BOOL)arg1 {
[snd haptic];
        [snd playSystemSoundAtPath:@"/var/mobile/Library/iSounds/.InUse/alert.wav"];
    	%orig;
}

- (void)showWithAnimationType:(int)arg1 {
[snd haptic];
        [snd playSystemSoundAtPath:@"/var/mobile/Library/iSounds/.InUse/alert.wav"];
    	%orig;
}
-(void)dismiss {
[snd haptic];
        [snd playSystemSoundAtPath:@"/var/mobile/Library/iSounds/.InUse/alert_close.wav"];
    	%orig;
}

- (void)_buttonClicked:(id)arg1 {
[snd haptic];
        [snd playSystemSoundAtPath:@"/var/mobile/Library/iSounds/.InUse/alert_close.wav"];
    	%orig;
}

%end

%hook UIActionSheet
- (void)showInView:(id)arg1 {
		[snd haptic];
        [snd playSystemSoundAtPath:@"/var/mobile/Library/iSounds/.InUse/actionsheet.wav"];
   %orig;
}

- (void)showFromBarButtonItem:(id)arg1 {
		[snd haptic];
		
        [snd playSystemSoundAtPath:@"/var/mobile/Library/iSounds/.InUse/actionsheet.wav"];
 		%orig;
}
/*
- (void)showFromRect:(id)arg1 inView:(id)arg2 animated:(BOOL)arg3{
		[snd haptic];
        [snd playSystemSoundAtPath:@"/var/mobile/Library/iSounds/.InUse/actionsheet.wav"];
 %orig;
}
*/

- (void)showFromBarButtonItem:(id)arg1 animated:(BOOL)arg2 {
		[snd haptic];
        [snd playSystemSoundAtPath:@"/var/mobile/Library/iSounds/.InUse/actionsheet.wav"];
 %orig;
}

- (void)showFromTabBar:(id)arg1 {
		[snd haptic];
        [snd playSystemSoundAtPath:@"/var/mobile/Library/iSounds/.InUse/actionsheet.wav"];
 %orig;
}

- (void)showFromToolbar:(id)arg1 {
		[snd haptic];
        [snd playSystemSoundAtPath:@"/var/mobile/Library/iSounds/.InUse/actionsheet.wav"];
 %orig;
}
//this works:
- (void)_buttonClicked:(id)arg1 {
		[snd haptic];
        [snd playSystemSoundAtPath:@"/var/mobile/Library/iSounds/.InUse/actionsheet.wav"];
 %orig;
 }
%end

%hook UIProgressView
-(void)setProgress:(float)progress {
		    
		[snd haptic];
        [snd playSystemSoundAtPath:@"/var/mobile/Library/iSounds/.InUse/progress.wav"];
 %orig;
}
-(void)setProgress:(float)progress animated:(bool)arg {
		    
		[snd haptic];
        [snd playSystemSoundAtPath:@"/var/mobile/Library/iSounds/.InUse/progress.wav"];
 %orig;
}

%end

%hook UITextField

-(void) _clearButtonClicked:(id)arg1 {

		[snd haptic];
        [snd playSystemSoundAtPath:@"/var/mobile/Library/iSounds/.InUse/textclear.wav"];
    %orig;
}

%end


%hook UINavigationController

- (void)navigationTransitionView:(id)arg1 didStartTransition:(int)arg2 {
		%orig;
		[snd haptic];
        [snd playSystemSoundAtPath:@"/var/mobile/Library/iSounds/.InUse/navigation_vcpush.wav"];
}
%end



%hook UISlider

- (void)_controlTouchMoved:(id)arg1 withEvent:(id)arg2 {
		[snd haptic];
        [snd playSystemSoundAtPath:@"/var/mobile/Library/iSounds/.InUse/slider.wav"];
		  %orig;
}
%end

%hook UISwitch

- (void)_animateToOn:(BOOL)arg1 withDuration:(float)arg2 sendAction:(BOOL)arg3 {
	if(arg1==YES) {
		[snd haptic];
        [snd playSystemSoundAtPath:@"/var/mobile/Library/iSounds/.InUse/switch_on.wav"];
	} else {
		[snd haptic];
        [snd playSystemSoundAtPath:@"/var/mobile/Library/iSounds/.InUse/switch_off.wav"];
    }
    %orig;
}
%end

%hook UIViewController
- (void)presentModalViewController:(id)arg1 animated:(BOOL)arg2 {
			[snd haptic];
        [snd playSystemSoundAtPath:@"/var/mobile/Library/iSounds/.InUse/modalviewpresent.wav"];
		  %orig;
}

- (void)dismissModalViewControllerAnimated:(BOOL)arg1 {
			[snd haptic];
        [snd playSystemSoundAtPath:@"/var/mobile/Library/iSounds/.InUse/modalviewdismiss.wav"];
		  %orig;
}

%end

%hook SBAppSwitcherController
-(void)_beginEditing {
			[snd haptic];
        [snd playSystemSoundAtPath:@"/var/mobile/Library/iSounds/.InUse/switcher_edit.wav"];
		  %orig;
}

-(void)iconTapped:(id)tapped {
        [snd haptic];
        [snd playSystemSoundAtPath:@"/var/mobile/Library/iSounds/.InUse/applaunch.wav"];
		%orig;
}
%end


%hook SBAwayController
- (void)playLockSound {
	if([FM fileExistsAtPath:@"/var/mobile/Library/iSounds/.InUse/lock.wav"]) {
		[snd haptic];
        [snd playSystemSoundAtPath:@"/var/mobile/Library/iSounds/.InUse/lock.wav"];
	} else {
		[snd haptic];
		%orig;
	}
}
- (void)_unlockWithSound:(BOOL)arg1 isAutoUnlock:(BOOL)arg2 unlockSource:(int)arg3 {
	if(arg1 && [FM fileExistsAtPath:@"/var/mobile/Library/iSounds/.InUse/unlock.wav"]) {
		[snd haptic];
        [snd playSystemSoundAtPath:@"/var/mobile/Library/iSounds/.InUse/unlock.wav"];
		%orig(false,arg2,arg3);
	} else {
		[snd haptic];
		%orig;
	}
}
- (void)_unlockWithSound:(BOOL)arg1 isAutoUnlock:(BOOL)arg2 {
	if(arg1 && [FM fileExistsAtPath:@"/var/mobile/Library/iSounds/.InUse/unlock.wav"]) {
		[snd haptic];
        [snd playSystemSoundAtPath:@"/var/mobile/Library/iSounds/.InUse/unlock.wav"];
		%orig(false,arg2);
	} else {
	[snd haptic];
		%orig;
	}
}
- (void)unlockWithSound:(BOOL)arg1 lockOwner:(id)arg2 isAutoUnlock:(BOOL)arg3 unlockSource:(int)arg4 {
	if(arg1 && [FM fileExistsAtPath:@"/var/mobile/Library/iSounds/.InUse/unlock.wav"]) {
		[snd haptic];
        [snd playSystemSoundAtPath:@"/var/mobile/Library/iSounds/.InUse/unlock.wav"];
		%orig(false,arg2,arg3,arg4);
	} else {
	[snd haptic];
		%orig;
	}
}
- (void)unlockWithSound:(BOOL)arg1 lockViewOwner:(id)arg2 {
	if(arg1 && [FM fileExistsAtPath:@"/var/mobile/Library/iSounds/.InUse/unlock.wav"]) {
		[snd haptic];
        [snd playSystemSoundAtPath:@"/var/mobile/Library/iSounds/.InUse/unlock.wav"];
		%orig(false,arg2);
	} else {
	[snd haptic];
		%orig;
	}
}
- (void)unlockWithSound:(BOOL)arg1 isAutoUnlock:(BOOL)arg2 unlockSource:(int)arg3 {
	if(arg1 && [FM fileExistsAtPath:@"/var/mobile/Library/iSounds/.InUse/unlock.wav"]) {
		[snd haptic];
        [snd playSystemSoundAtPath:@"/var/mobile/Library/iSounds/.InUse/unlock.wav"];
		%orig(false,arg2,arg3);
	} else {
	[snd haptic];
		%orig;
	}
}
- (void)unlockFromSource:(int)arg1 playSound:(BOOL)arg2 lockViewOwner:(id)arg3 {
	if(arg2 && [FM fileExistsAtPath:@"/var/mobile/Library/iSounds/.InUse/unlock.wav"]) {
		[snd haptic];
        [snd playSystemSoundAtPath:@"/var/mobile/Library/iSounds/.InUse/unlock.wav"];
		%orig(arg1,false,arg3);
	} else {
	[snd haptic];
		%orig;
	}
}
- (void)unlockFromSource:(int)arg1 playSound:(BOOL)arg2 isAutoUnlock:(BOOL)arg3 {
	if(arg2 && [FM fileExistsAtPath:@"/var/mobile/Library/iSounds/.InUse/unlock.wav"]) {
		[snd haptic];
        [snd playSystemSoundAtPath:@"/var/mobile/Library/iSounds/.InUse/unlock.wav"];
		%orig(arg1,false,arg3);
	} else {
	[snd haptic];
		%orig;
	}
}
- (void)unlockFromSource:(int)arg1 playSound:(BOOL)arg2 {
	if(arg2 && [FM fileExistsAtPath:@"/var/mobile/Library/iSounds/.InUse/unlock.wav"]) {
		[snd haptic];
        [snd playSystemSoundAtPath:@"/var/mobile/Library/iSounds/.InUse/unlock.wav"];
		%orig(arg1,false);
	} else {
	[snd haptic];
		%orig;
	}
}
- (void)unlockWithSound:(BOOL)arg1 {
	if(arg1 && [FM fileExistsAtPath:@"/var/mobile/Library/iSounds/.InUse/unlock.wav"]) {
		[snd haptic];
        [snd playSystemSoundAtPath:@"/var/mobile/Library/iSounds/.InUse/unlock.wav"];
		%orig(false);
	} else {
	[snd haptic];
		%orig;
	}
}
%end

%hook TPPhonePad
- (void)_playSoundForKey:(int)arg1 {
	if([FM fileExistsAtPath:@"/var/mobile/Library/iSounds/.InUse/phonepad.wav"]) {
		[snd haptic];
        [snd playSystemSoundAtPath:@"/var/mobile/Library/iSounds/.InUse/phonepad.wav"];
	} else {
	[snd haptic];
		%orig;
	}
}
%end

%hook UIKeyboard
- (id)hitTest:(CGPoint)test withEvent:(id)event
{
	[snd haptic];
    return %orig;
}
%end



%hook MailboxContentViewController

-(void)_reallyDeleteMessages:(id)messages{
%orig;
        [snd playSystemSoundAtPath:@"/var/mobile/Library/iSounds/.InUse/app_delete.wav"];
}

%end

%hook NotesDisplayController

-(void)actionSheet:(id)sheet clickedButtonAtIndex:(int)index{
%orig;
        [snd playSystemSoundAtPath:@"/var/mobile/Library/iSounds/.InUse/app_delete.wav"];
}	

%end