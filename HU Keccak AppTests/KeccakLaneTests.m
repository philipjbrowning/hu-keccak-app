//
//  KeccakLaneTests.m
//  HU Keccak App
//
//  Created by Philip J Browning II on 1/17/14.
//  Copyright (c) 2014 Philip Browning. All rights reserved.
//

#import "KeccakLaneTests.h"

@implementation KeccakLaneTests

- (void)testInitialIntValue
{
    KeccakLane *lane = [[KeccakLane alloc] initWithIntValue:255 andWidth:8];
    NSUInteger twoHundredFiftyFive = 255;
    XCTAssertEqual(twoHundredFiftyFive, [lane value], @"Lane value %lu should equal 255", [lane value]);
}

- (void)testLaneSizeTooLarge
{
    XCTAssertThrows([[KeccakLane alloc] initWithIntValue:256 andWidth:8], @"The lane size is larger than the maximum number of bits=8 (size=%f).", powf(2.0, 8.0));
    KeccakLane *lane = [[KeccakLane alloc] initWithIntValue:255 andWidth:8];
    XCTAssertThrows([lane updateValue:256], @"The lane size is larger than the maximum number of bits=8 (size=%lu).", [lane maxValue]);
}

- (void)testHexValue
{
    KeccakLane *lane = [[KeccakLane alloc] initWithIntValue:255 andWidth:8];
    XCTAssertEqualObjects(@"ff", [lane hexValue], @"Lane value %@ should equal ff", [lane hexValue]);
}

- (void)testUnsignedValue
{
    KeccakLane *lane = [[KeccakLane alloc] initWithIntValue:255 andWidth:8];
    unsigned twoHundredFiftyFive = 255;
    XCTAssertEqual(twoHundredFiftyFive, [lane unsignedValue], @"Lane value %u should equal 255", [lane unsignedValue]);
}

- (void)testUpdateValue
{
    KeccakLane *lane = [[KeccakLane alloc] initWithIntValue:255 andWidth:8];
    NSUInteger seventySeven = 77;
    [lane updateValue:seventySeven];
    XCTAssertEqual(seventySeven, [lane value], @"Lane value %lu should equal 77", [lane value]);
}

@end