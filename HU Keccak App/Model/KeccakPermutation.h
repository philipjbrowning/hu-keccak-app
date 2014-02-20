//
//  KeccakPermutation.h
//  HU Keccak App
//
//  Created by Philip J Browning II on 11/8/13.
//  Copyright (c) 2013 Philip Browning. All rights reserved.
//

#import "KeccakTransformation.h"

@interface KeccakPermutation : KeccakTransformation

/**
 * Abstract method that applies the <em>inverse</em> of the permutation
 * onto the parameter @a state.
 *
 * @param  state   A buffer on which to apply the inverse permutation.
 *                 The state must have a size of at least
 *                 ceil(getWidth()/8.0) bytes.
 */
- (void)inverse:(NSString*)state;

@end