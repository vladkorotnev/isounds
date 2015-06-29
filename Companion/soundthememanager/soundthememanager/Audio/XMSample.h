#include "xmplay.h"

/**
 * Wrapper class for ChibiXM's XM_SampleID struct
 * Loads a sample 'WAV' from disk which can be be mixed into the software
 * mixer via the ChibiXM interface.
 **/
@interface XMSample : NSObject 
{
	XM_SampleID m_handle;
}

/**
 * Return the XM_SampleID handle structure we're encapsulating.
 * This is used by the ChibiXM class and shouldn't be needed by the client.
 **/
@property (readonly) XM_SampleID data;

/**
 * Construct an XMSample from the given WAV file name.
 **/
-(id)initWithName:(NSString*)name;

@end
