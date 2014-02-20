//
//  KeccakLane.m
//  HU Keccak App
//
//  Created by Philip J Browning II on 1/17/14.
//  Copyright (c) 2014 Philip Browning. All rights reserved.
//

#import "KeccakLane.h"

@interface KeccakLane ()

- (BOOL)validNewValue:(NSUInteger)newValue;
- (void)invalidNewValueException:(NSUInteger)newValue;

@end

@implementation KeccakLane

#pragma mark - Initialization

- (id)initWithIntValue:(NSUInteger)newValue andWidth:(NSUInteger)widthInNumberOfBits
{
    self = [super init];
    if (self) {
        _maxWidth = widthInNumberOfBits;
        _maxValue = (int)(powf(2.0, _maxWidth) - 1.0);
        [self updateValue:newValue];
    }
    return self;
}

# pragma mark - Getters and Setters

- (NSString*)hexValue
{
    return [NSString stringWithFormat:@"%02lx", (unsigned long)_value];
}

- (unsigned)unsignedValue
{
    return (unsigned)_value;
}

- (void)updateValue:(NSUInteger)newValue
{
    if ([self validNewValue:newValue]) {
        _value = newValue;
    }
}

#pragma mark - Input Validation

- (void)invalidNewValueException:(NSUInteger)newValue
{
    [NSException raise:@"Value exceeds lane size" format:@"The input size of %lu bits exceeds the capacity of %lu bits (size=%lu).", newValue, _maxWidth, _maxValue];
}

- (BOOL)validNewValue:(NSUInteger)newValue
{
    if (newValue > _maxValue) {
        [self invalidNewValueException:newValue];
        return NO;
    } else {
        return YES;
    }
}

@end
