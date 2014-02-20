//
//  KeccakSponge.h
//  HU Keccak App
//
//  Created by Philip J Browning II on 11/8/13.
//  Copyright (c) 2013 Philip Browning. All rights reserved.
//

#import <Foundation/Foundation.h>
// #import "KeccakTransformation.h"

@interface KeccakSponge : NSObject

@property (nonatomic, readonly) NSUInteger bitsPerByte;
@property (nonatomic, readonly) NSUInteger capacity;
@property (nonatomic, readonly) NSUInteger columnMax;
@property (nonatomic, readonly) NSString* description;
@property (nonatomic, readonly) NSUInteger laneBytes;
@property (nonatomic, readonly) NSUInteger rate;
@property (nonatomic, readonly) NSUInteger rowMax;
@property (nonatomic, readonly) NSUInteger outputLength;
@property (nonatomic, readonly) BOOL fixedOuputLength;


- (id)initWithPlainText:(NSString*)plainText
           withCapacity:(NSUInteger)capacity
               withRate:(NSUInteger)rate
       withOutputLength:(NSUInteger)outputLength
   andFixedOutputLength:(BOOL)fixedOuputLength;
- (void)absorb:(NSString*)inputBits;
- (NSUInteger)numberOfBits;
- (NSUInteger)numberOfSlices;
- (NSUInteger)objectInRow:(NSUInteger)x inColumn:(NSUInteger)y inSlice:(NSUInteger)slice;
- (NSUInteger)width;
- (void)NSLogState;

/*
// - (id)initWithTransformation:(KeccakTransformation*)aF withPaddingRule:(PaddingRule*)aPad andWithRate:(NSUInteger)aRate;
- (void)reset;
;
- (void)squeeze:(NSString*)outputBits withDesiredLengthInBits:(NSUInteger) desiredLengthInBits;
*/

@end
