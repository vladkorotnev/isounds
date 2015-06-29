//
//  ESRenderer.h
//  ChibiXM
//
//  Created by David Churchill on 10-08-13.
//  Copyright Incubator Games 2010. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import <OpenGLES/EAGL.h>
#import <OpenGLES/EAGLDrawable.h>

#import "ChibiXM.h"

@protocol ESRenderer <NSObject>

- (void)setXMPlayer:(ChibiXM*)player;
- (void)render;
- (BOOL)resizeFromLayer:(CAEAGLLayer *)layer;

@end
