//
//  KeccakLane.h
//  HU Keccak App
//
//  Created by Philip J Browning II on 1/17/14.
//  Copyright (c) 2014 Philip Browning. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeccakLane : NSObject

@property (nonatomic, readonly) NSUInteger maxWidth;
@property (nonatomic, readonly) NSUInteger maxValue;
@property (nonatomic) NSUInteger value;

- (id)initWithIntValue:(NSUInteger)newValue andWidth:(NSUInteger)widthInNumberOfBits;
- (NSString*)hexValue;
- (unsigned)unsignedValue;
- (void)updateValue:(NSUInteger)newValue;

@end
