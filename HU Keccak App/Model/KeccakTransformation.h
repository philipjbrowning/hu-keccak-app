//
//  KeccakTransformation.h
//  HU Keccak App
//
//  Created by Philip J Browning II on 11/8/13.
//  Copyright (c) 2013 Philip Browning. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Abstract class that represents a transformation from n bits to n bits.
 */
@interface KeccakTransformation : NSObject

/**
 * Abstract method that returns the number of bits of its domain and range.
 */
@property (nonatomic) NSUInteger width;
/**
 * Abstract method that returns a string with a description of itself.
 */
@property (nonatomic) NSString* description;

/**
 * Abstract method that applies the transformation onto the parameter
 * @a state.
 *
 * @param  state   A buffer on which to apply the transformation.
 *                 The state must have a size of at least
 *                 ceil(getWidth()/8.0) bytes.
 */
- (void)applyTransformationTo:(NSString*)state;
// virtual void operator()(UINT8 * state) const = 0;

@end

