//
//  KeccakMessage.h
//  HU Keccak App
//
//  Created by Philip J Browning II on 11/8/13.
//  Copyright (c) 2013 Philip Browning. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KeccakBlock.h"

@interface KeccakMessage : NSObject

@property (nonatomic, readonly) NSTimeInterval *runningTimeLength;
@property (nonatomic, readonly) NSDate *runningDateTime;
@property (nonatomic, readonly) NSUInteger capacity;                        // c
@property (nonatomic, readonly) NSString *cypherHexText;
@property (nonatomic, readonly) NSMutableString *cypherText;
@property (nonatomic, readonly) NSInteger maxLaneBits;
@property (nonatomic, readonly) NSInteger maxLaneValue;
@property (nonatomic, readonly) NSString *plainHexText;
@property (nonatomic) NSString *plainText;
@property (nonatomic, readonly) NSUInteger outputLength;
@property (nonatomic, readonly) NSUInteger rate;                            // r
@property (nonatomic, readonly) NSUInteger width;                           // b

- (id)initWithPlainText:(NSString*)somePlainText
           withCapacity:(NSUInteger)aCapacity
               withRate:(NSUInteger)aRate
       withOutputLength:(NSUInteger)anOutputLength
   andFixedOutputLength:(BOOL)aFixedOuputLength;

- (void)convertPlainTextToHex;
- (NSUInteger)numberOfBlocksRequired;
- (NSUInteger)numberOfRounds;
- (void)setPlainText:(NSString*)newPlainText;

// Where does the fixedOutputLength come into play?
- (NSString*)encryptMessage;

@end
