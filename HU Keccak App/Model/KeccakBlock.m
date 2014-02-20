//
//  KeccakBlock.m
//  HU Keccak App
//
//  Created by Philip J Browning II on 1/21/14.
//  Copyright (c) 2014 Philip Browning. All rights reserved.
//

#import "KeccakBlock.h"

@interface KeccakBlock ()

@property (nonatomic) NSUInteger bitsInHexChar;

- (void)clearState;
- (NSUInteger)indexOfColumn:(NSUInteger)x andRow:(NSUInteger)y;

@end

@implementation KeccakBlock

#pragma mark - Initialization

- (id)initWithCapacity:(NSUInteger)aCapacity andRate:(NSUInteger)aRate
{
    self = [super init];
    if (self) {
        // Custom initialization
        _bitsInHexChar = 16;
        _capacity = aCapacity;
        _maxColumns = 5;
        _maxRows = 5;
        _rate = aRate;
        
        if ((_capacity * _maxColumns * _maxRows) % (_capacity + _rate) == 0) {
            _maxLanes = (_capacity * _maxColumns * _maxRows) / (_capacity + _rate);
        } else {
            [NSException raise:@"Invalid maxLanes" format:@"The (capacity(%lu) * 25) / (capacity(%lu) + rate(%lu) ) must be evenly divisible.", _capacity, _capacity, _rate];
        }
        
        if ((_capacity + _rate) % (_maxColumns * _maxRows) == 0) {
            _maxWidth = (_capacity + _rate) / (_maxColumns * _maxRows);
        } else {
            [NSException raise:@"Invalid maxWidth" format:@"The capacity (%lu) + rate (%lu) must be divisible by 25 so that all lanes have the same length.", _capacity, _rate];
        }
        
        [self clearState];
    }
    return self;
}

- (void)clearState
{
    self.state = [[NSMutableArray alloc] init];
    for (NSUInteger y=0; y<_maxRows; y++) {
        for (NSUInteger x=0; x<_maxColumns; x++) {
            [self.state insertObject:[[KeccakLane alloc] initWithIntValue:0 andWidth:_maxWidth] atIndex:[self indexOfColumn:x andRow:y]];
        }
    }
}

#pragma mark - Getters and Setters

- (KeccakLane*)laneAtColumn:(NSUInteger)x andRow:(NSUInteger)y
{
    if ((y < _maxRows) || (x < _maxColumns)) {
        return [self.state objectAtIndex:[self indexOfColumn:x andRow:y]];
    } else {
        [NSException raise:@"Invalid row and or column input" format:@"Row and column values must be from 0 to 4. You entered row(y)=%lu and column(x)=%lu", y, x];
        return nil;
    }
}

- (NSUInteger)maxHexCharactersInMessage;
{
    return (self.maxRows * self.maxColumns * self.capacity) / (self.rate + self.capacity);
}

- (void)setLaneValue:(NSUInteger)newValue toColumn:(NSUInteger)x andRow:(NSUInteger)y
{
    [[self.state objectAtIndex:[self indexOfColumn:x andRow:y]] updateValue:newValue];
}

- (NSUInteger)indexOfColumn:(NSUInteger)x andRow:(NSUInteger)y
{
    return (x + (_maxColumns * y));
}

#pragma mark - NSLog

- (void)NSLogState
{
    for (NSUInteger y=0; y<_maxRows; y++) {
        NSMutableString *rowInState = [[NSMutableString alloc] initWithString:@"[ "];
        for (NSUInteger x=0; x<_maxColumns; x++) {
            [rowInState appendString:[NSString stringWithFormat:@"%@ ", [[self.state objectAtIndex:[self indexOfColumn:x andRow:y]] hexValue]]];
        }
        [rowInState appendString:@"]"];
        NSLog(@"%@", rowInState);
    }
}

@end
