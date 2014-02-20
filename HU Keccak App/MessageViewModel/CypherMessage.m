//
//  CypherMessage.m
//  HU Keccak App
//
//  Created by Philip J Browning II on 1/28/14.
//  Copyright (c) 2014 Philip Browning. All rights reserved.
//

#import "CypherMessage.h"

@implementation CypherMessage

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        _date = [NSDate date];
        _log = [[KeccakDataLog alloc] init];
        _text = [[NSString alloc] init];
    }
    return self;
}

- (id)initWithString:(NSString*)someText{
    self = [super init];
    if (self) {
        // Custom initialization
        _date = [NSDate date];
        _log = [[KeccakDataLog alloc] init];
        _text = someText;
    }
    return self;
}

@end
