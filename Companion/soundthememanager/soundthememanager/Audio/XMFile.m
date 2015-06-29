#import "XMFile.h"
#import "ChibiXM.h"


@implementation XMFile

@synthesize data = m_song;

+(id)songWithName:(NSString*)name
{
	XMFile* obj = [[XMFile alloc] initWithName:name];
	[obj autorelease];
	return obj;
}


-(id)initWithName:(NSString*)name
{	
	if((self = [super init]) != nil)
	{
		[ChibiXM bind];
		
		m_song = xm_song_alloc();
		
		const char* cstr = [name cStringUsingEncoding:NSASCIIStringEncoding];
		if (xm_loader_open_song(cstr, m_song) != XM_LOADER_OK) {
			[self release];
			return nil;
		}
	}
	
	return self;
}

-(void)dealloc
{
	if(m_song != NULL) {
		xm_song_free(m_song);
		m_song = NULL;
	}
	
	[super dealloc];
}


@end
