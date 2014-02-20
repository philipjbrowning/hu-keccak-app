//
//  Message.h
//  HU Keccak App
//
//  Created by Philip J Browning II on 11/13/13.
//  Copyright (c) 2013 Philip Browning. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageType.h"

@interface Message : NSObject

@property (nonatomic) NSString *text;
@property (nonatomic) NSDate *date;

- (id)init;
- (id)initWithString:(NSString*)someText;

@end
