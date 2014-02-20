//
//  Message.m
//  HU Keccak App
//
//  Created by Philip J Browning II on 11/13/13.
//  Copyright (c) 2013 Philip Browning. All rights reserved.
//

#import "Message.h"

@implementation Message

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        _date = [NSDate date];
        _text = [[NSString alloc] init];
    }
    return self;
}

- (id)initWithString:(NSString*)someText{
    self = [super init];
    if (self) {
        // Custom initialization
        _date = [NSDate date];
        _text = someText;
    }
    return self;
}

@end
