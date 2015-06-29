//
//  ES1Renderer.h
//  ChibiXM
//
//  Created by David Churchill on 10-08-13.
//  Copyright Incubator Games 2010. All rights reserved.
//

#import "ESRenderer.h"

#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>

#define MAX_PARTICLES 4096

#define PARTICLE_LIFE 60

#define NUM_WAVES     (64)

typedef struct {
	float x, y;
} t_vector;

typedef struct {
	float r, g, b, a;
} t_color;

typedef struct {
	t_vector vector;
	t_color  color;
} t_vertex;

typedef struct {
	bool     active;
	t_vector pos;
	t_vector vel;
	int      life;
} t_particle;


@interface ES1Renderer : NSObject <ESRenderer>
{
@private
    EAGLContext *context;

    // The pixel dimensions of the CAEAGLLayer
    GLint backingWidth;
    GLint backingHeight;

    // The OpenGL ES names for the framebuffer and renderbuffer used to render to this view
    GLuint defaultFramebuffer, colorRenderbuffer;
	
	ChibiXM*  m_player;
	float      m_channels[32];
	
	// Vertex buffer
	t_vertex   m_data[4 * (32 * 2) * 128];

	// Pointer to current position in vertex buffer
	t_vertex*  m_data_ptr;
	
	// Last known sum of the channels.. used for a fun trigger effect
	float      m_vol_sum;
	
	t_particle m_particles[MAX_PARTICLES];
	int m_num_particles;
	
	float        m_counter;
	float        m_screen_counter;
	
	float        m_wave_vel;
}

- (void)render;
- (BOOL)resizeFromLayer:(CAEAGLLayer *)layer;

@end
