//
//  ES1Renderer.m
//  ChibiXM
//
//  Created by David Churchill on 10-08-13.
//  Copyright Incubator Games 2010. All rights reserved.
//

#import "ES1Renderer.h"


@implementation ES1Renderer

// Create an OpenGL ES 1.1 context
- (id)init
{
    if ((self = [super init]))
    {
        context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];

        if (!context || ![EAGLContext setCurrentContext:context])
        {
            [self release];
            return nil;
        }

        // Create default framebuffer object. The backing will be allocated for the current layer in -resizeFromLayer
        glGenFramebuffersOES(1, &defaultFramebuffer);
        glGenRenderbuffersOES(1, &colorRenderbuffer);
        glBindFramebufferOES(GL_FRAMEBUFFER_OES, defaultFramebuffer);
        glBindRenderbufferOES(GL_RENDERBUFFER_OES, colorRenderbuffer);
        glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, colorRenderbuffer);
		
		glEnable (GL_BLEND); 
		glBlendFunc (GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);		
		
    }

    return self;
}



-(void)renderQuadFromRect:(CGRect)rect withColor:(t_color)clr
{
	float x0 = rect.origin.x;
	float y0 = rect.origin.y;
	float x1 = rect.origin.x + rect.size.width;
	float y1 = rect.origin.y - rect.size.height;
	float r  = clr.r;
	float g  = clr.g;
	float b  = clr.b;
	float a  = clr.a;

	t_vertex data[] = 
	{
		{ {x0, y0}, {r, g, b, a}, },
		{ {x1, y0}, {r, g, b, a}, },
		{ {x0, y1}, {r, g, b, a}, },
		
		{ {x1, y0}, {r, g, b, a}, },
		{ {x1, y1}, {r, g, b, a}, },
		{ {x0, y1}, {r, g, b, a}, },
	};
	
	memcpy(m_data_ptr, data, sizeof(t_vertex) * 6);
	m_data_ptr += 6;
}

-(void)spawnParticleAt:(t_vector)pos withVelocity:(t_vector)velocity
{
	if(m_num_particles == MAX_PARTICLES) {
		return;
	}
	
	int i = m_num_particles;
	m_particles[i].life   = PARTICLE_LIFE;
	m_particles[i].pos    = pos;
	m_particles[i].vel    = velocity;
	m_particles[i].active = YES;
	m_num_particles++;
}

-(void)freeParticleAtIndex:(int)idx
{
	m_num_particles--;
	m_particles[idx] = m_particles[m_num_particles];
}

 

-(void)createPixelExplosionAt:(t_vector)pos
{
	for(int i=0; i < 64; ++i)
	{
		float speed = (((float)(rand() % 256) / 256) * 0.05f) + 0.025f;
		speed *= 2;
		
		t_vector vel;
		vel.x = 1.0f * speed;
		vel.y = (((float)(rand() % 256) / 256) - 0.5f) * 0.01;
		
		pos.y = ((float)(rand() % 480) / 240) - 1.0f;
		
		[self spawnParticleAt:pos withVelocity:vel];
	}
}


-(void)drawBackground
{
	// Draw meter waves
	float channel_width = 2.0f / NUM_WAVES;
	float rx =  1.0f;
	float ry =  1.0f;
	for(int i=0; i < NUM_WAVES; ++i)
	{
		float vol = fabs(cos(m_counter + (float)i/2) * 2.0f);
		float clr = vol / 0.05f;
		
		t_color c;
		c.r  = 0.5f;
		c.g  = (1.0f - clr);
		c.b  = 0.0f;
		c.a  = 0.1f;
		[self renderQuadFromRect:CGRectMake(rx - vol, ry, vol, channel_width) withColor:c];
		
		ry -= channel_width;
	}
	rx =  1.0f;
	ry =  1.0f;
	for(int i=0; i < NUM_WAVES; ++i)
	{
		float vol = fabs(sin(m_counter - (float)i/2) * 2.0f);
		float clr = vol / 0.2f;
		
		t_color c;
		c.r  = 0.5f;
		c.g  = (1.0f - clr);
		c.b  = 0.0f;
		c.a  = 0.1f;
		[self renderQuadFromRect:CGRectMake(rx - vol, ry, vol, channel_width) withColor:c];
		
		ry -= channel_width;
	}
}

- (void)render
{
	// Reset vertex write pointer
	m_data_ptr = m_data;

    // This application only creates a single context which is already set current at this point.
    // This call is redundant, but needed if dealing with multiple contexts.
    [EAGLContext setCurrentContext:context];
	
    // This application only creates a single default framebuffer which is already bound at this point.
    // This call is redundant, but needed if dealing with multiple framebuffers.
    glBindFramebufferOES(GL_FRAMEBUFFER_OES, defaultFramebuffer);
    glViewport(0, 0, backingWidth, backingHeight);

	// Identity the primary matrices
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();
	
	
	glClearColor(1.0f, 1.0f, 1.0f, 1.0f);
	glClear(GL_COLOR_BUFFER_BIT);		
	
	
	if(m_player != nil && m_player.song != nil)
	{
		float rx, ry;
		int   num_channels  = (m_player.song.data->flags & 0x1F) + 1.0f;
		
		// Clear the frame buffer to background color
		float sum      = 0;
		float bg_color = 0.0f;
		for(int i=0; i < num_channels; ++i) {
			sum += m_channels[i];
		}
		if(abs(sum - m_vol_sum) > (float)(num_channels >> 8)) 
		{
			m_wave_vel = 0.1f;
		}
		if(abs(sum - m_vol_sum) > (float)(num_channels >> 4)) 
		{
			t_vector pos;
			//pos.x = ((float)(rand() % 1024) / 512) - 1.0f;
			//pos.y = ((float)(rand() % 1024) / 512) - 1.0f;
			pos.x = -1.0f;
			pos.y =  0.0f;
			[self createPixelExplosionAt:pos];
		}
		m_vol_sum = sum;
		bg_color = ((float)sum / num_channels) * 0.5f;
		bg_color = 1.0f - bg_color;
		
		glClearColor(1.0f, 1.0f, bg_color, 1.0f);
		glClear(GL_COLOR_BUFFER_BIT);
		
		// Draw meter waves
		[self drawBackground];
		
		// Populate vertex buffer with particles
		for(int i=0; i < m_num_particles; ++i)
		{
			m_particles[i].life--;
			
			m_particles[i].pos.x += m_particles[i].vel.x;
			m_particles[i].pos.y += m_particles[i].vel.y;
			m_particles[i].vel.x -= 0.005f;
			
			t_color c;
			c.r = 1.0f;
			c.g = 0.5f;
			c.b = 0.0f;
			c.a = ((float)m_particles[i].life / PARTICLE_LIFE);
			
			float w = 0.01f + ((1.0f-c.a) * 0.02f);
			
			rx = m_particles[i].pos.x - w/2;
			ry = m_particles[i].pos.y - w/2 * 0.6f;
			
			[self renderQuadFromRect:CGRectMake(rx, ry, w, w * 0.6f) withColor:c];
			if(m_particles[i].life <= 0 || m_particles[i].pos.x < -1.0f) {
				[self freeParticleAtIndex:i];
				i--;
			}
		}	
		
		
		// Populate vertex buffer with meter bars
		float channel_width = 2.0f / num_channels;
		float border  = 0.01f; //0.0075f;
		rx = -1.0f;
		ry =  1.0f;
		for(int i=0; i < (int)num_channels; ++i)
		{
			float cur_vol = (((float)[m_player getChannelVolume:i] / 255.0f) * 1.0f);
			if(cur_vol < m_channels[i]) {
				m_channels[i] = m_channels[i] * 0.9f;
				if(m_channels[i] < cur_vol) {
					m_channels[i] = cur_vol;
				}
			} else {
				m_channels[i] = cur_vol;
			}
			
			float vol = m_channels[i] * 1.9f;
			float clr = vol/1.25f;
			t_color c;
			/*c.r  = 0.5f;
			c.g  = (1.0f - clr) / 2.0f;
			c.b  = 0.0f;
			c.a  = 1.0f;*/
            c.r = 1.0f;
            c.g = 1.0f;
            c.b = 1.0f;
            c.a = 1.0f;
			[self renderQuadFromRect:CGRectMake(rx, ry, vol + border, channel_width + border) withColor:c];
            c.r  = (1.0f - clr);
            c.b  = (1.0f - clr);
			[self renderQuadFromRect:CGRectMake(rx, ry, vol         , channel_width         ) withColor:c];
			
			ry -= channel_width;
		} 
		

	}
	else {
		[self drawBackground];
	}

	// Populate vertices for screen mask
	t_color c;
	c.r = sin(m_screen_counter * 1.5f);
	c.g = sin(m_screen_counter * 1.25f);
	c.b = sin(m_screen_counter * 0.75f) * 0.5f;
	c.a = 0.1f;
	[self renderQuadFromRect:CGRectMake(-1, -1, 2, -2) withColor:c];
	
	m_screen_counter += (1.0f / 60.0f) * 0.1f;
	m_counter += (1.0f / 1024.0f) + m_wave_vel;
	m_wave_vel *= 0.9f;

	//NSLog(@"Vertices: %d",  m_data_ptr - m_data);
	
	
	// Render vertices 
	glVertexPointer(2, GL_FLOAT, sizeof(t_vertex), &m_data[0].vector);
	glColorPointer (4, GL_FLOAT, sizeof(t_vertex), &m_data[0].color);
	glEnableClientState(GL_COLOR_ARRAY);
	glEnableClientState(GL_VERTEX_ARRAY);
	glDrawArrays(GL_TRIANGLES, 0, m_data_ptr - m_data);
	
    // This application only creates a single color renderbuffer which is already bound at this point.
    // This call is redundant, but needed if dealing with multiple renderbuffers.
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, colorRenderbuffer);
    [context presentRenderbuffer:GL_RENDERBUFFER_OES];
}

- (BOOL)resizeFromLayer:(CAEAGLLayer *)layer
{	
    // Allocate color buffer backing based on the current layer size
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, colorRenderbuffer);
    [context renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable:layer];
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &backingWidth);
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &backingHeight);

    if (glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES) != GL_FRAMEBUFFER_COMPLETE_OES)
    {
        NSLog(@"Failed to make complete framebuffer object %x", glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES));
        return NO;
    }

    return YES;
}

- (void)dealloc
{
    // Tear down GL
    if (defaultFramebuffer)
    {
        glDeleteFramebuffersOES(1, &defaultFramebuffer);
        defaultFramebuffer = 0;
    }

    if (colorRenderbuffer)
    {
        glDeleteRenderbuffersOES(1, &colorRenderbuffer);
        colorRenderbuffer = 0;
    }

    // Tear down context
    if ([EAGLContext currentContext] == context)
        [EAGLContext setCurrentContext:nil];

    [context release];
    context = nil;

    [super dealloc];
}

- (void)setXMPlayer:(ChibiXM*)player
{
	m_player = player;
}


@end
