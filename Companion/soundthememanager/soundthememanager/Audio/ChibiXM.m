#import "ChibiXM.h"
#include <float.h>

#define kOutputBus 0
#define kInputBus  1 
#define SAMPLE_RATE 22050

// Memory manager function bindings used by chibi to allocate/free memory
static XM_MemoryManager s_memory_manager;

// File I/O function bindings used by chibi to do file i/o operations
static XM_FileIO        s_file_io;

///////////////////////////////////////////////////////////////////////////////
// Memory Manager Interface
///////////////////////////////////////////////////////////////////////////////
static void* alloc_mem(xm_u32 p_size, XM_MemoryAllocType p_alloc_type) {
	return malloc(p_size);
}

static void free_mem(void *p_mem, XM_MemoryAllocType p_alloc_type) {
	free(p_mem);
}

static void zero_mem(void* p_mem, xm_u32 sz) {
	memset(p_mem, '\0', sz);
}


///////////////////////////////////////////////////////////////////////////////
// File System Interface
///////////////////////////////////////////////////////////////////////////////
FILE*   m_fp;
xm_bool f_be;

static xm_bool fileio_in_use() {
	return m_fp ? xm_true : xm_false;		
}

static XM_FileIOError fileio_open(const char *p_file, xm_bool p_big_endian_mode) 
{
	NSString* path = [NSString stringWithFormat:@"%@/%s", 
					  [[NSBundle mainBundle] resourcePath], p_file];
	
	if(m_fp) {
		return XM_FILE_ERROR_IN_USE;
	}
	
	m_fp=fopen([path cStringUsingEncoding:NSASCIIStringEncoding],"rb");
	if (!m_fp) {
		return XM_FILE_ERROR_CANT_OPEN;
	}
	
	f_be = p_big_endian_mode;
	
	return XM_FILE_OK;
}

static xm_u8 fileio_get_u8() 
{
	xm_u8 b;
	
	if (!m_fp) {
		return 0;	
	}
	
	fread(&b,1,1,m_fp);
	
	return b;
}

static xm_u16 fileio_get_u16() 
{
	xm_u8 a,b;
	xm_u16 c;
	
	if (!m_fp) {
		return 0;	
	}
	
	if (!f_be) {
		a=fileio_get_u8();
		b=fileio_get_u8();
	} else {
		
		b=fileio_get_u8();
		a=fileio_get_u8();		
	}
	
	c=((xm_u16)b << 8 ) | a;
	
	return c;
}

static xm_u32 fileio_get_u32() 
{
	xm_u16 a,b;
	xm_u32 c;
	
	if (!m_fp) {
		return 0;	
	}
	
	if (!f_be) {
		a=fileio_get_u16();
		b=fileio_get_u16();
	} else {
		
		b=fileio_get_u16();
		a=fileio_get_u16();		
	}
	
	c=((xm_u32)b << 16 ) | a;	
	
	return c;
}

static void fileio_get_byte_array(xm_u8 *p_dst,xm_u32 p_count) 
{
	if (!m_fp) {
		return;	
	}
	
	fread(p_dst,p_count,1,m_fp);
}

static void fileio_seek_pos(xm_u32 p_offset) 
{
	if (!m_fp) {
		return;	
	}
	
	fseek(m_fp,p_offset,SEEK_SET);
}

static xm_u32 fileio_get_pos() 
{
	if (!m_fp) {
		return 0;	
	}
	
	return ftell(m_fp);
}

static xm_bool fileio_eof_reached() 
{
	if (!m_fp) {
		return xm_true;	
	}
	
	return feof(m_fp)?xm_true:xm_false;
}

static void fileio_close() 
{
	if(m_fp) {
		fclose(m_fp);
	}
	m_fp=NULL;
}

///////////////////////////////////////////////////////////////////////////////
// Software Mixer Interrupt
///////////////////////////////////////////////////////////////////////////////
#define INTERNAL_BUFFER_SIZE 16384
static xm_s32 mix_buff[INTERNAL_BUFFER_SIZE];

static OSStatus playbackCallback(void *inRefCon, 
								 AudioUnitRenderActionFlags* ioActionFlags, 
								 const AudioTimeStamp*       inTimeStamp, 
								 UInt32                      inBusNumber, 
								 UInt32                      inNumberFrames, 
								 AudioBufferList*            ioData) 
{
	int           i;
	float         volume   = *((float*)inRefCon);
	int           todo     = ioData->mBuffers[0].mDataByteSize >> 2;
	xm_s32*       src_buff = mix_buff;
	signed short* dst_buff = (signed short*)ioData->mBuffers[0].mData;
	
	while(todo) 
	{
		int to_mix = todo;
		if (to_mix > INTERNAL_BUFFER_SIZE) {
			to_mix = INTERNAL_BUFFER_SIZE;
		}
		todo -= to_mix;
		
		// Ask software mixer to mix some frames to our mixing buffer
		memset(src_buff, 0, to_mix << 3);
		xm_software_mix_to_buffer(src_buff,to_mix);
		
		// Write our mixing buffer to apple's internal buffer
		// In the process convert mixing buffer to 16 bits and applying mixer 
		// volume
		for (i=0;i<to_mix*2;i++) {
			dst_buff[i] = (src_buff[i] >> 16) * volume; 
		}
	}
	
	return noErr;
}







///////////////////////////////////////////////////////////////////////////////
// Class Interface
///////////////////////////////////////////////////////////////////////////////
@implementation ChibiXM

@synthesize volume  = m_volume;

@synthesize song    = m_xm_file;

@synthesize playing = m_playing;

static ChibiXM* xm_player_instance = nil;

+(void)initialize
{
	[ChibiXM sharedInstance];
}

+(ChibiXM*)sharedInstance
{
	@synchronized(self)
	{
		if(xm_player_instance == nil) {
			xm_player_instance = [[ChibiXM alloc] init];
		}
	}
	
	return xm_player_instance;
}

+(void) bind
{
	// Link up ChibiXM Memory Management
	memset(&s_memory_manager, 0, sizeof(XM_MemoryManager));
	s_memory_manager.alloc = alloc_mem;
	s_memory_manager.free  = free_mem;
	xm_set_memory_manager(&s_memory_manager);
	
	// Link up ChibiXM File I/O
	memset(&s_file_io, 0, sizeof(XM_FileIO));
	s_file_io.in_use         = fileio_in_use;
	s_file_io.open           = fileio_open;
	s_file_io.get_u8         = fileio_get_u8;
	s_file_io.get_u16        = fileio_get_u16;
	s_file_io.get_u32        = fileio_get_u32;
	s_file_io.get_byte_array = fileio_get_byte_array;
	s_file_io.seek_pos       = fileio_seek_pos;
	s_file_io.get_pos        = fileio_get_pos;
	s_file_io.eof_reached    = fileio_eof_reached;
	s_file_io.close          = fileio_close;
	xm_loader_set_fileio(&s_file_io);
}


-(id)init
{
	if((self = [super init]) != nil)
	{
		m_volume = 1.0f;

		// Bind chibi to system calls for memory and file i/o
		[ChibiXM bind];
		
		// ChibiXM Mixer 
		// We'll use Chibi's software mixer
		xm_create_software_mixer(SAMPLE_RATE, 32);	
		
		// ChibiXM Mixer
		m_mixer = xm_get_mixer();

		OSStatus status;
		
		// Describe audio component
		AudioComponentDescription desc;
		memset(&desc, 0, sizeof(AudioComponentDescription));
		desc.componentType         = kAudioUnitType_Output;
		desc.componentSubType      = kAudioUnitSubType_RemoteIO;
		desc.componentFlags        = 0;
		desc.componentFlagsMask    = 0;
		desc.componentManufacturer = kAudioUnitManufacturer_Apple;
		
		// Get component
		AudioComponent inputComponent = AudioComponentFindNext(NULL, &desc);
		
		// Get audio units
		status = AudioComponentInstanceNew(inputComponent, &m_audio_unit);
		if(status != noErr) {
			NSLog(@"Failed to get audio component instance: %d", status);
		}
		
		// Enable IO for playback
		UInt32 flag = 1;
		status = AudioUnitSetProperty(m_audio_unit, 
									  kAudioOutputUnitProperty_EnableIO, 
									  kAudioUnitScope_Output, 
									  kOutputBus,
									  &flag, 
									  sizeof(flag));
		if(status != noErr) {
			NSLog(@"Failed to enable audio i/o for playback: %d", status);
		}
		
		// Describe format
		AudioStreamBasicDescription audioFormat;
		memset(&audioFormat, 0, sizeof(AudioStreamBasicDescription));
		audioFormat.mSampleRate       = SAMPLE_RATE;
		audioFormat.mFormatID	      = kAudioFormatLinearPCM;
		audioFormat.mFormatFlags      = kAudioFormatFlagIsSignedInteger 
		                              | kAudioFormatFlagIsPacked 
		                              | kAudioFormatFlagsNativeEndian;
		audioFormat.mFramesPerPacket  = 1;		
		audioFormat.mChannelsPerFrame = 2;
		audioFormat.mBitsPerChannel   = 16;
		audioFormat.mBytesPerPacket   = 4;
		audioFormat.mBytesPerFrame    = 4;		
		
		// Apply format
		status = AudioUnitSetProperty(m_audio_unit, 
									  kAudioUnitProperty_StreamFormat, 
									  kAudioUnitScope_Input, 
									  kOutputBus, 
									  &audioFormat, 
									  sizeof(audioFormat));
		if(status != noErr) {
			NSLog(@"Failed to set format descriptor: %d", status);
		}
		
		// Set output callback
		AURenderCallbackStruct callbackStruct;
		memset(&callbackStruct, 0, sizeof(AURenderCallbackStruct));
		callbackStruct.inputProc       = playbackCallback;
		callbackStruct.inputProcRefCon = &m_volume;
		status = AudioUnitSetProperty(m_audio_unit, 
									  kAudioUnitProperty_SetRenderCallback, 
									  kAudioUnitScope_Global, 
									  kOutputBus,
									  &callbackStruct, 
									  sizeof(callbackStruct));
		if(status != noErr) {
			NSLog(@"Failed to set output callback: %d", status);
		}
		
		// Initialize
		status = AudioUnitInitialize(m_audio_unit);
		if(status != noErr) {
			NSLog(@"Failed to initialise audio unit: %d", status);
		}
	}
	
	return self;
}

-(void)dealloc
{
	// Disable mixer interrupt
	AudioOutputUnitStop(m_audio_unit);
	
	// Deactivate ChibiXM
	[self stop];
	xm_player_stop();
	
	// Free memory manager
	xm_set_memory_manager(NULL);
	
	// Free file system interface
	xm_loader_set_fileio(NULL);
	
	[super dealloc];
}

-(void)play:(XMFile*)song
{
	self.song = song;
	[self play];
}

-(void)play
{
	if(m_playing == NO) 
	{
		xm_player_play();
		AudioOutputUnitStart(m_audio_unit);
		m_playing = YES;
	}
}

-(void)stop
{
	if(m_playing == YES) 
	{
		xm_player_stop();
		m_playing = NO;
	}
}

-(void)pause
{
	if(m_playing == YES) 
	{
		AudioOutputUnitStop(m_audio_unit);
		m_playing = NO;
	}
}

-(void)setVolume:(float)vol
{
	m_volume = vol;
}

-(void)setSong:(XMFile *)song
{
	// Stop the player if we're playing
	[self stop];

	// Assign and retain new xm file
	[m_xm_file release];
	m_xm_file = song;
	[m_xm_file retain];

	// Initialise chibi
	xm_player_stop();
	xm_player_set_song(m_xm_file.data);
	xm_player_play();
}

float clamp(float val, float min, float max)
{
	if(val < min) { return min; }
	if(val > max) { return max; }
	return val;
}


-(void)playSample:(XMSample*)sample onChannel:(int)channel withVolume:(float)vol 
	   andPanning:(float)pan andPitch:(float)pitch
{
	vol   = clamp(  vol,  0.0f, 1.0f);
	pan   = clamp(  pan, -1.0f, 1.0f);
	pitch = clamp(pitch,  0.0f, FLT_MAX);
	
	int _volume  = (int)(vol * 255.0f);
	int _panning = (int)((pan + 1.0f) * 127.5f);
	int _pitch   = (int)(pitch * 11025.0f);
	
	xm_sfx_start_voice(sample.data, channel);
	xm_sfx_set_pitch  (channel, _pitch);
	xm_sfx_set_pan    (channel, _panning);
	xm_sfx_set_vol    (channel, _volume);
}


-(int)getChannelVolume:(int)channel
{
	return m_mixer->voice_get_volume(channel);
}

@end
