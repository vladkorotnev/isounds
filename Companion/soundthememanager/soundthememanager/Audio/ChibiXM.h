#include <AudioUnit/AudioUnit.h>
#include "xmplay.h"
#include "XMFile.h"
#include "XMSample.h"

/**
 *
 **/
@interface ChibiXM : NSObject 
{
	// Handle to audio component instance (for mixer callback)
	AudioComponentInstance m_audio_unit;
	
	// XM currently playing
	XMFile*   m_xm_file;
	
	// ChibiXM mixer struct reference
	XM_Mixer* m_mixer;
	
	// Volume
	float     m_volume;
	
	// Are we currently playing?
	bool      m_playing;
}

// Set the global volume of the mixer [0 .. 1]
@property (nonatomic, assign) float volume;

// Set the song we're playing
@property (nonatomic, retain) XMFile* song;

// Are we playing currently? 
@property (readonly) bool playing;


/**
 * Singleton access
 **/
+(ChibiXM*)sharedInstance;

/**
 * Bind ChibiXM to iOS memory and file i/o routines
 **/
+(void)bind;

/**
 * Start playing the given song from the start.
 * This is equivelant to stopping, setting a new song, and calling play
 **/
-(void)play:(XMFile*)song;

/**
 * Start playing audio.
 * This will 'resume' playback if the player was paused.
 **/
-(void)play;

/**
 * Pause the playback.
 * Playback can be resumed with 'play', 'stop' will rewind.
 **/
-(void)pause;

/**
 * Stop playback.
 * A subsequent call to play will start the song from the beginning.
 **/
-(void)stop;

/**
 * Plays a sample on the given channel, at the given volume, panning, and pitch.
 * Volume  is ( 0.0 .. 1.0) where 1.0 is maximum volume.
 * Panning is (-1.0 .. 1.0) where -1.0 is hard panned left, 1.0 is hard right.
 * Pith    is shifted linearally where 1.0 is no pitch shift.
 **/
-(void)playSample:(XMSample*)sample onChannel:(int)channel withVolume:(float)vol 
	   andPanning:(float)pan andPitch:(float)pitch;


-(int)getChannelVolume:(int)channel;


@end
