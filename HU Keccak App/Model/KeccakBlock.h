//
//  KeccakBlock.h
//  HU Keccak App
//
//  Created by Philip J Browning II on 1/21/14.
//  Copyright (c) 2014 Philip Browning. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KeccakLane.h"

@interface KeccakBlock : NSObject

@property (nonatomic) NSUInteger capacity;
@property (nonatomic) NSUInteger maxColumns;
@property (nonatomic) NSUInteger maxLanes;
@property (nonatomic) NSUInteger maxRows;
@property (nonatomic) NSUInteger maxWidth;
@property (nonatomic) NSUInteger rate;
@property (nonatomic) NSMutableArray *state; // KeccakLane class

- (id)initWithCapacity:(NSUInteger)aCapacity andRate:(NSUInteger)aRate;
- (KeccakLane*)laneAtColumn:(NSUInteger)x andRow:(NSUInteger)y;
- (NSUInteger)maxLanes;
- (void)setLaneValue:(NSUInteger)newValue toColumn:(NSUInteger)x andRow:(NSUInteger)y;
- (void)NSLogState; // Remove when neccessary

@end
