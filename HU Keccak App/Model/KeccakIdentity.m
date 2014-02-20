//
//  KeccakIdentity.m
//  HU Keccak App
//
//  Created by Philip J Browning II on 11/8/13.
//  Copyright (c) 2013 Philip Browning. All rights reserved.
//

#import "KeccakIdentity.h"

@implementation KeccakIdentity

- (id)initWith:(NSUInteger)aWidth
{
    self = [super init];
    if (self) {
        self.width = aWidth;
        self.description = @"Identity";
    }
    return self;
}


@end
