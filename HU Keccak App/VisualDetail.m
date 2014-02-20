//
//  VisualDetail.m
//  HU Keccak App
//
//  Created by Philip J Browning II on 2/20/14.
//  Copyright (c) 2014 Philip Browning. All rights reserved.
//

#import "VisualDetail.h"

@implementation VisualDetail

+ (Class)layerClass
{
    return [CAEAGLLayer class];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        CAEAGLLayer *EAGLLayer = (CAEAGLLayer*) super.layer;
        EAGLLayer.opaque = YES;
        
        context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
        
        if (!context || ![EAGLContext setCurrentContext:context]) {
            return nil;
        }
        
        GLuint frameBuffer, renderBuffer;
        glGenBuffers(1, &frameBuffer);
        glGenBuffers(1, &renderBuffer);
        
        glBindFramebuffer(GL_FRAMEBUFFER, frameBuffer);
        glBindRenderbuffer(GL_RENDERBUFFER, renderBuffer);
        
        [context renderbufferStorage:GL_RENDERBUFFER fromDrawable:EAGLLayer];
        
        glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, renderBuffer);
        
        glViewport(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame));
        
        [self render];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)render
{
    glClearColor(50.0/255.0, 205.0/255.0, 50.0/255.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
    
    [context presentRenderbuffer:GL_RENDERBUFFER];
}

@end
