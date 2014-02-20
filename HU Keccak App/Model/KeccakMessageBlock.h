//
//  KeccakMessageBlock.h
//  HU Keccak App
//
//  Created by Philip J Browning II on 11/8/13.
//  Copyright (c) 2013 Philip Browning. All rights reserved.
//

#import <Foundation/Foundation.h>

/** Class representing a message block whose size is not necessarily
 * a multiple of 8 bits.
 * The block can contain any number of bits.
 */
@interface KeccakMessageBlock : NSObject

/** The current block stored as a sequence of bytes.
 * If the number of bits is not a multiple of 8, the last byte contains the
 * last few bits in its least significant bits.
 */
@property (nonatomic, readonly) NSMutableString* block; // UINT8

/** The number of bits in the block. */
@property (nonatomic) NSUInteger bitsInBlock;

/** Method to append one bit to the block.
 * @param  bitValue     The value (0 or 1) of the bit to append.
 */
- (void)appendBit:(NSString*)bitValue; // 0 or 1 in string

/** Method to append one byte to the block.
 * @param  byteValue     The value (0x00…0xFF) of the byte to append.
 */
- (void)appendByte:(NSString*)byteValue; //

/** Method to append a series of bits with value '0'.
 * @param  count     The number of zeroes to append.
 */
- (void)appendZeroes:(NSUInteger)count;

/** Method that returns the number of bits in the block.
 * @return  The number of bits in the block.
 */
- (const NSUInteger)size;

/** Method that returns a reference to the block.
 * @return  A constant reference to the block represented as a vector of bytes.
 * If the number of bits is not a multiple of 8, the last byte contains the
 * last few bits in its least significant bits.
 */
- (NSString*)get;
// const vector<UINT8>& get() const;

@end

