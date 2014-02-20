//
//  KeccakBlockTests.m
//  HU Keccak App
//
//  Created by Philip J Browning II on 1/21/14.
//  Copyright (c) 2014 Philip Browning. All rights reserved.
//

#import "KeccakBlockTests.h"

@implementation KeccakBlockTests

- (void)testTwentyFiveLanesCreated
{
    KeccakBlock *sponge = [[KeccakBlock alloc] initWithCapacity:320 andRate:80];
    NSUInteger numExpectedLanes = 25;
    XCTAssertEqual(numExpectedLanes, [[sponge state] count], @"The number of lanes should be 25, not %lu.", [[sponge state] count]);
}

- (void)testInvalidCapacityAndRateCreated
{
    XCTAssertThrows([[KeccakBlock alloc] initWithCapacity:321 andRate:80], @"The capacity + rate must be divisible by 25 so that all lanes have the same length.");
    XCTAssertThrows([[KeccakBlock alloc] initWithCapacity:325 andRate:80], @"Description");
}

- (void)testInitialStateLaneValues
{
    KeccakBlock *sponge = [[KeccakBlock alloc] initWithCapacity:320 andRate:80];
    XCTAssertEqual([[[KeccakLane alloc] initWithIntValue:0 andWidth:8] value], [[sponge laneAtColumn:0 andRow:0] value], @"The value at sponge[0,0] should equal 0.");
    XCTAssertEqual([[[KeccakLane alloc] initWithIntValue:0 andWidth:8] value], [[sponge laneAtColumn:4 andRow:4] value], @"The value at sponge[4,4] should equal 0.");
}

- (void)testInvalidLaneRowOrColumn
{
    KeccakBlock *sponge = [[KeccakBlock alloc] initWithCapacity:320 andRate:80];
    XCTAssertThrows([sponge laneAtColumn:5 andRow:4], @"Invalid row");
    XCTAssertThrows([sponge laneAtColumn:4 andRow:5], @"Invalid column");
}

- (void)testMaxLanes
{
    KeccakBlock *sponge = [[KeccakBlock alloc] initWithCapacity:320 andRate:80];
    NSUInteger twenty = 20;
    XCTAssertEqual(twenty, [sponge maxLanes], @"Should be 20");
}

- (void)testUpdateLaneValue
{
    KeccakBlock *sponge = [[KeccakBlock alloc] initWithCapacity:320 andRate:80];
    NSUInteger twenty = 20;
    [sponge setLaneValue:twenty toColumn:0 andRow:0];
    XCTAssertEqual(twenty, [[sponge laneAtColumn:0 andRow:0 ] value], @"The value of sponge[0,0] should be 20, however, the value is %lu", [[sponge laneAtColumn:0 andRow:0] value]);
}

@end
