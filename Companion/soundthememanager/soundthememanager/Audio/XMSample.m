#import "XMSample.h"
#import "ChibiXM.h"

@implementation XMSample

@synthesize data=m_handle;

-(id)initWithName:(NSString*)name
{
	if((self = [super init]) != nil)
	{
		[ChibiXM bind];
		
		const char* cstr = [name cStringUsingEncoding:NSASCIIStringEncoding];
		
		if((m_handle = xm_load_wav(cstr)) == XM_INVALID_SAMPLE_ID)
		{
			[self release];
			return nil;
		}
	}
	
	return self;
}



@end
