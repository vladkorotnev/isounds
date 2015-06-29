#include "xmplay.h"

/**
 * Wrapper class for a ChibiXM XM_Song structure.
 * This allows xm files to allocated, initialised, and managed according to
 * objective c paradigms.
 **/
@interface XMFile : NSObject
{
	XM_Song* m_song;
}

/**
 * Exposes the underlying XM_Song data structure we're wrapping.
 * A client shouldn't require this. It is used by ChibiXM singleton.
 **/
@property (readonly) XM_Song* data;

/**
 * Construct the XMFile object with the given file name.
 * Autoreleased.
 **/
+(id)songWithName:(NSString*)name;

/**
 * Construct the XMFile object with the given file name.
 **/
-(id)initWithName:(NSString*)name;

@end
