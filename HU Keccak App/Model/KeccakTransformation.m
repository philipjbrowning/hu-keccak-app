//
//  KeccakTransformation.m
//  HU Keccak App
//
//  Created by Philip J Browning II on 11/8/13.
//  Copyright (c) 2013 Philip Browning. All rights reserved.
//

#import "KeccakTransformation.h"

@implementation KeccakTransformation

@synthesize description = _description;
@synthesize width = _width;

- (id)init
{
    self = [super init];
    if (self) {
        self.width = 0;
        self.description = @"";
    }
    return self;
}

- (void)applyTransformationTo:(NSString*)state
{
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
}

@end
