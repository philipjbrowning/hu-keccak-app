//
//  KeccakIdentity.h
//  HU Keccak App
//
//  Created by Philip J Browning II on 11/8/13.
//  Copyright (c) 2013 Philip Browning. All rights reserved.
//

#import "KeccakPermutation.h"

/**
 * Class that implements the simplest possible permutation: the identity.
 */
@interface KeccakIdentity : KeccakPermutation

- (id)initWith:(NSUInteger)aWidth;


@end

// Identity(unsigned int aWidth) : Permutation(), width(aWidth) {};
// virtual void operator()(UINT8 * state) const {}
// virtual void inverse(UINT8 * state) const {}
