//
//  KeccakMessageTests.m
//  HU Keccak App
//
//  Created by Philip J Browning II on 1/21/14.
//  Copyright (c) 2014 Philip Browning. All rights reserved.
//

#import "KeccakMessageTests.h"

@implementation KeccakMessageTests
/*
- (void)testNumberOfRoundsIsTwenty
{
    KeccakMessage *newMessage = [[KeccakMessage alloc] initWithPlainText:@"" withCapacity:320 withRate:80 withOutputLength:400 andFixedOutputLength:YES];
    NSUInteger twenty = 20;
    XCTAssertEqual(twenty, [newMessage numberOfRounds], @"Based on the width of 400 (capacity=320 + rate=80), the number of rounds is %lu, but should be 20", [newMessage numberOfRounds]);
}

- (void)testNumberOfBlocksRequired
{
    // All blocks are filled to capacity divides
    KeccakMessage *newMessageOne = [[KeccakMessage alloc] initWithPlainText:@"We" withCapacity:16 withRate:184 withOutputLength:16 andFixedOutputLength:YES];
    KeccakMessage *newMessageTwo = [[KeccakMessage alloc] initWithPlainText:@"Wed" withCapacity:16 withRate:184 withOutputLength:16 andFixedOutputLength:YES];
    NSUInteger one = 1;
    NSUInteger two = 2;
    XCTAssertEqual(one, [newMessageOne numberOfBlocksRequired], @"Strings are 2 hex characters per letter, 8 bits, 'We' having a total of 2 letters, 16 bits, should be within the capacity of 1 block, however it shows it needs %lu block(s).", [newMessageOne numberOfBlocksRequired]);
    XCTAssertEqual(two, [newMessageTwo numberOfBlocksRequired], @"Strings are 2 hex characters per letter, 8 bits, 'Wed' having a total of 3 letters, 24 bits, should be within the capacity of 2 blocks, however it shows it needs %lu block(s).", [newMessageTwo numberOfBlocksRequired]);
}

- (void)testB
{
    KeccakMessage *newMessage = [[KeccakMessage alloc] initWithPlainText:@"" withCapacity:320 withRate:80 withOutputLength:400 andFixedOutputLength:YES];
    NSUInteger fourHundred = 400;
    XCTAssertEqual(fourHundred, newMessage.b, @"The width (b) is %lu, but should be %lu", newMessage.b, fourHundred);
}

- (void)testConvertPlainTextToHex
{
    KeccakMessage *newMessage = [[KeccakMessage alloc] initWithPlainText:@"" withCapacity:320 withRate:80 withOutputLength:400 andFixedOutputLength:YES];
    newMessage.plainText = @"Zion";
    NSString *zionInHex = @"5a696f6e";
    XCTAssertEqualObjects(zionInHex, newMessage.plainHexText, @"The message Zion in hex is %@, but the conversion shows %@.", zionInHex, newMessage.plainHexText);
}

// - (void)testKeccakTheta
// - (void)testKeccakRho
// - (void)testKeccakPi
// - (void)testKeccakChi
// - (void)testKeccakIota
// - (void)testKeccakAddRoundConstants
*/
@end
