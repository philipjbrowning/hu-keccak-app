//
//  KeccakMessageBlock.m
//  HU Keccak App
//
//  Created by Philip J Browning II on 11/8/13.
//  Copyright (c) 2013 Philip Browning. All rights reserved.
//

#import "KeccakMessageBlock.h"

@interface KeccakMessageBlock()



@end

@implementation KeccakMessageBlock

- (id)init
{
    self = [super init];
    if (self) {
        self.bitsInBlock = 0;
    }
    return self;
}

- (void)appendBit:(NSString*)bitValue
{
    /*
    NSUInteger bitsInByte = _bitsInBlock % 8;
    if (bitsInByte == 0) {
        [_block appendString:bitValue];
    }
    else if ([bitValue intValue] & 1) {
        block.back() |= (UINT8)(1 << bitsInByte);
    }
    _bitsInBlock++;
    */
}

- (void)appendByte:(NSString*)byteValue
{
    /*
    if ((_bitsInBlock % 8) == 0) {
        [_block appendString:byteValue];
        _bitsInBlock += 8;
    }
    else {
        for(NSUInteger i=0; i<8; i++) {
            appendBit(byteValue % 2);
            byteValue = byteValue / 2;
        }
    }
    */
}

- (void)appendZeroes:(NSUInteger)count
{
    /*
    while((count > 0) && ((bitsInBlock % 8) != 0)) {
        appendBit(0);
        count--;
    }
    while(count >= 8) {
        block.push_back(0);
        bitsInBlock += 8;
        count -= 8;
    }
    while(count > 0) {
        appendBit(0);
        count--;
    }
    */
}

- (const NSUInteger)size
{
    return self.bitsInBlock;
}

- (NSString*)get
{
    return _block;
}

@end
