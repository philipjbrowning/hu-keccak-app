//
//  KeccakMessage.m
//  HU Keccak App
//
//  Created by Philip J Browning II on 11/8/13.
//  Copyright (c) 2013 Philip Browning. All rights reserved.
//

#import "KeccakMessage.h"

@interface KeccakMessage ()

@property (nonatomic) NSUInteger bitsPerASCIIChar;
@property (nonatomic) NSUInteger round;
@property (nonatomic) NSUInteger totalBlocks;
@property (nonatomic) BOOL squeezing;

- (KeccakBlock*)keccakChiWithBlock:(KeccakBlock*)A andB:(NSMutableDictionary*)B;
- (KeccakBlock*)keccakFwithBlock:(KeccakBlock*)S;
- (KeccakBlock*)keccakIotaWithBlock:(KeccakBlock*)A;
- (KeccakBlock*)keccakRoundWithBlock:(KeccakBlock*)A;
- (NSMutableDictionary*)keccakRhoAndPiWithBlock:(KeccakBlock*)A;
- (KeccakBlock*)keccakThetaWithBlock:(KeccakBlock*)A;
- (unsigned)rotationOffsetAtX:(NSUInteger)x andY:(NSUInteger)y;
- (unsigned)ROTfromW:(unsigned)w byR:(unsigned)r;

@end

@implementation KeccakMessage

#pragma mark - Initialization

- (id)initWithPlainText:(NSString*)somePlainText
           withCapacity:(NSUInteger)aCapacity
               withRate:(NSUInteger)aRate
       withOutputLength:(NSUInteger)anOutputLength
   andFixedOutputLength:(BOOL)aFixedOuputLength
{
    self = [super init];
    if (self) {
        // Custom initialization
        _bitsPerASCIIChar = 8;
        _capacity = aCapacity;
        _rate = aRate;
        _width = _capacity + _rate;
        _maxLaneBits = _width / 25;
        _maxLaneValue = powf(2.0, _maxLaneBits) - 1;
        _outputLength = anOutputLength;
        _cypherHexText = @"";
        _cypherText = [[NSMutableString alloc] initWithString:@""];
        [self setPlainText:somePlainText];
        // _runningDateTime = [NSDate date];
        _totalBlocks = [self numberOfBlocksRequired];
        // NSLog(@"Total Blocks Required = %lu", _totalBlocks);
    }
    return self;
}

#pragma mark - Getters and Setters

- (void)setPlainText:(NSString*)newPlainText
{
    _plainText = newPlainText;
    // Override setting of plain text to automatically set the corresponding hex text.
    [self convertPlainTextToHex];
}

- (void)convertPlainTextToHex;
{
    _plainHexText = [NSString stringWithFormat:@"%@",
                     [NSData dataWithBytes:[_plainText cStringUsingEncoding:NSUTF8StringEncoding]
                                    length:strlen([_plainText cStringUsingEncoding:NSUTF8StringEncoding])]];    for(NSString * toRemove in [NSArray arrayWithObjects:@"<", @">", @" ", nil])
    {
        _plainHexText = [_plainHexText stringByReplacingOccurrencesOfString:toRemove withString:@""];
    }
}

#pragma mark - Keccak Encryption

- (NSString*)encryptMessage
{
    /* ---------------------------------------------------------------------- *
     * Initialization and Padding
     * ---------------------------------------------------------------------- */
    
    // S[x,y] = 0,                                  forall (x,y) in (0...4,0..4)
    //
    //                  x-->
    //     S[x,y] =   +-----------+
    //              y | 0 0 0 0 0 |
    //              | | 0 0 0 0 0 |
    //              V | 0 0 0 0 0 |
    //                | 0 0 0 0 0 |
    //                | 0 0 0 0 0 |
    //                +-----------+
    //     x = column index (0..4)
    //     y = row index (0...4)
    //
    
    KeccakBlock *S = [[KeccakBlock alloc] initWithCapacity:_capacity andRate:_rate];
    
    // P = M || 0x01 || 0x00 || 0x00 || ... || 0x00
    //
    //     P = the padded message, organized as an array of blocks Pi
    //     M = the plaintext message from the user
    
    NSMutableArray *P = [[NSMutableArray alloc] init];
    NSString *M = _plainText;
    
    // Add the required padding at the beginning of the padded message (P)
    for (NSUInteger i=0; i<25-([M length]%25); i++) {
        [P insertObject:[NSNumber numberWithInt:0] atIndex:i];
        // NSLog(@"P[%lu] = 0 (ASCII:%@)", i, [P objectAtIndex:i]);
    }
    
    // Add the plain text messsage (M) to the padded message (P)
    for (NSUInteger i=0; i<[M length]; i++) {
        [P insertObject:[NSNumber numberWithInt:[M characterAtIndex:i]] atIndex:i];
        // NSLog(@"P[%lu] = %@ (ASCII:%@)", i, [M substringWithRange:NSMakeRange(i, 1)], [P objectAtIndex:i]);
    }
    
    // P = P xor (0x00 || ... || 0x00 || 0x80)
    //
    //     P = the padded message, organized as an array of blocks Pi
    
    // NO PADDING USED
    
    
    /* ---------------------------------------------------------------------- *
     * Absorbing Phase                                                        *
     * ---------------------------------------------------------------------- */
    
    // forall block Pi in P
    //
    //     P = the padded message, organized as an array of blocks Pi
    //     Pi = blocks of the padded message organized as arrays of lanes
    
    NSLog(@"S[x,y]");
    NSLog(@"----------");
    [S NSLogState];
    
    /*
    for (NSUInteger block=0; block<_totalBlocks; block++) {
        while (<#condition#>) {
            <#statements#>
        }
    }
    
    for (NSUInteger i=0; i<(_rate/_maxLaneBits); i++) {
        NSLog(@"Insert lane #%lu", i);
    }
    */
    
    NSUInteger blockIndex = 0;
    for (NSUInteger block=0; block<_totalBlocks; block++) {
        
        // S[x,y] = S[x,y] xor Pi[x+5*y],     forall (x,y) such that x+5*y < r/w
        //
        //     r = rate
        //     w = lane size
        //     x = column index (0..4)
        //     y = row index (0...4)
        //     Pi = blocks of the padded message organized as arrays of lanes
        
        for (NSUInteger y=0; y<[S maxRows]; y++) {
            for (NSUInteger x=0; x<[S maxColumns]; x++) {
                if ((blockIndex < [P count]) && ((x+(5*y)) < [S maxLanes])) {
                    NSUInteger old_sXY = [[S laneAtColumn:x andRow:y] value];
                    NSUInteger pXplus5timesY = [[P objectAtIndex:blockIndex] integerValue];
                    NSUInteger new_sXY = old_sXY^pXplus5timesY;
                    [S setLaneValue:new_sXY toColumn:x andRow:y];
                    // NSLog(@"S[%lu,%lu] = %lu^%lu = %lu, blockIndex = %lu", x, y, old_sXY, pXplus5timesY, new_sXY, blockIndex);
                    blockIndex++;
                }
            }
        }
        NSLog(@"S[x,y]");
        NSLog(@"----------");
        [S NSLogState];
        
        S = [self keccakFwithBlock:S];
        
    }
    
    NSLog(@"S[x,y]");
    NSLog(@"----------");
    [S NSLogState];
    
    
    /* ---------------------------------------------------------------------- *
     * Squeezing Phase                                                        *
     * ---------------------------------------------------------------------- */
    
    // Z = empty string
    //
    //     Z is the output string (in Hexadecimal representation)
    
    NSMutableString *Z = [[NSMutableString alloc] initWithString:@""];
    
    // while output is requested
    
    BOOL moreOutputRequested = YES;
    while (moreOutputRequested) {
        
        // Z = Z || S[x,y],                   forall (x,y) such that x+5*y < r/w
        
        blockIndex = 0;
        for (NSUInteger y=0; y<[S maxRows]; y++) {
            for (NSUInteger x=0; x<[S maxColumns]; x++) {
                if ((blockIndex < (_outputLength / _maxLaneBits)) && ((x+(5*y)) < [S maxLanes])) {
                    // NSLog(@"S[%lu,%lu] = %@", x, y, [[S laneAtColumn:x andRow:y] hexValue]);
                    [Z appendString:[[S laneAtColumn:x andRow:y] hexValue]];
                    // NSLog(@"Z = %@", Z);
                    blockIndex++;
                }
            }
        }
        if (blockIndex < (_outputLength / _maxLaneBits)) {
            moreOutputRequested = NO;
        }
        
        // S = Keccak-f[r+c](S)
    }
    
    _cypherHexText = Z;
    NSLog(@"_cypherHexText = %@", _cypherHexText);
    
    /*
    // Convert _cypherHexText to _cypherText
    i = 0;
    while (i < [_cypherHexText length])
    {
        NSString * hexChar = [_cypherHexText substringWithRange: NSMakeRange(i, 2)];
        int value = 0;
        sscanf([hexChar cStringUsingEncoding:NSASCIIStringEncoding], "%x", &value);
        [_cypherText appendFormat:@"%c", (char)value];
        // NSLog(@"_cypherText = %@", _cypherText);
        i+=2;
    }
    
    return _cypherText;
     */
    
    return _cypherHexText;
}

- (NSUInteger)numberOfBlocksRequired
{
    if (([_plainText length] * _bitsPerASCIIChar) % _capacity == 0) {
        return ([_plainText length] * _bitsPerASCIIChar) / _capacity;
    } else {
        return (([_plainText length] * _bitsPerASCIIChar) / _capacity) + 1;
    }
}

#pragma mark - Keccak-f[b](A): Keccak Rounds

- (KeccakBlock*)keccakFwithBlock:(KeccakBlock*)A
{
    for (self.round=0; self.round<[self numberOfRounds]; self.round++) {
        // NSLog(@"Round = %lu of %lu", (self.round+1), [self numberOfRounds]);
        A = [self keccakRoundWithBlock:A];
        // [A NSLogState];
        // Save Keccak States
        // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveState) name:@"Save Keccak State" object:nil];
    }
    return A;
}

- (NSUInteger)numberOfRounds
{
    switch(_width) {
        case 25:   return 12; break;
        case 50:   return 14; break;
        case 100:  return 16; break;
        case 200:  return 18; break; // 18
        case 400:  return 20; break;
        case 800:  return 22; break;
        case 1600: return 24; break;
    }
    return 0;
}

#pragma mark - Round[b](A,RC): Individual Round

- (KeccakBlock*)keccakRoundWithBlock:(KeccakBlock*)A
{
    A = [self keccakThetaWithBlock:A];
    // [A NSLogState];
    NSMutableDictionary *B = [self keccakRhoAndPiWithBlock:A];
    A = [self keccakChiWithBlock:A andB:B];
    // [A NSLogState];
    A = [self keccakIotaWithBlock:A];
    return A;
}

// Step 1
- (KeccakBlock*)keccakThetaWithBlock:(KeccakBlock*)A
{
    // C[x] = A[x,0] xor A[x,1] xor A[x,2] xor A[x,3] xor A[x,4],   forall x in 0...4
    // This functions xor's all the values in each column.
    // NSLog(@"Theta");
    NSMutableArray* C = [[NSMutableArray alloc] init];
    for (NSUInteger x=0; x<A.maxColumns; x++) {
        unsigned temp = 0;
        for (NSUInteger y=0; y<A.maxRows; y++) {
            temp = temp^[[A laneAtColumn:x andRow:y] unsignedValue];
        }
        [C insertObject:[NSNumber numberWithUnsignedInt:temp] atIndex:x];
        // NSLog(@"C[%lu] = %u", x, temp);
    }
    
    // D[x] = C[x-1] xor rot(C[x+1],1),                        forall x in 0...4
    NSMutableArray* D = [[NSMutableArray alloc] init];
    for (NSUInteger x=0; x<A.maxColumns; x++) {
        unsigned cOfXminusOne = [[C objectAtIndex:((x-1+A.maxColumns)%A.maxColumns)] unsignedIntValue];
        // NSLog(@"C[%lu-1] = %u", x, cOfXminusOne);
        unsigned cofXplusOne = [[C objectAtIndex:((x+1+A.maxColumns)%A.maxColumns)] unsignedIntValue];
        // NSLog(@"C[%lu+1] = %u", x, cofXplusOne);
        unsigned tempRotWr = [self ROTfromW:cofXplusOne byR:1];
        // NSLog(@"rot(C[%lu+1]) = %u", x, tempRotWr);
        [D insertObject:[NSNumber numberWithUnsignedInt:(cOfXminusOne^tempRotWr)] atIndex:x];
        // NSLog(@"D[%lu] = %@", x, [NSNumber numberWithUnsignedInt:(cOfXminusOne^tempRotWr)]);
    }
    
    // A[x,y] = A[x,y] xor D[x],    forall (x,y) in (0...4,0..4)
    // NSMutableArray *newState = [[NSMutableArray alloc] init]; // KeccakLane class
    for (NSUInteger x=0; x<A.maxRows; x++) {
        for (NSUInteger y=0; y<A.maxColumns; y++) {
            unsigned aXY = [[A laneAtColumn:x andRow:y] unsignedValue];
            // NSLog(@"A[%lu,%lu] = %u", x, y, aXY);
            unsigned dX = [[D objectAtIndex:x] unsignedIntValue];
            // NSLog(@"D[%lu] = %u", x, dX);
            aXY ^= dX;
            // NSLog(@"New A[%lu,%lu] = %u", x, y, aXY);
            [A setLaneValue:(aXY) toColumn:x andRow:y];
            // KeccakLane *newLane = [[KeccakLane alloc] initWithIntValue:aXY];
            // [newState insertObject:newLane atIndex:index];
        }
    }
    return A;
}

// Step 2
- (NSMutableDictionary*)keccakRhoAndPiWithBlock:(KeccakBlock*)A
{
    // NSLog(@"Rho and Pi");
    // B[y,2*x+3*y] = rot(A[x,y], r[x,y]),         forall (x,y) in (0...4,0...4)
    NSMutableDictionary* B = [[NSMutableDictionary alloc] init];
    for (NSUInteger x=0; x<A.maxColumns; x++) {
        for (NSUInteger y=0; y<A.maxRows; y++) {
            unsigned aXY = [[A laneAtColumn:x andRow:y] unsignedValue];
            // NSLog(@"A[%lu,%lu] = %u", x, y, aXY);
            unsigned rXY = [self rotationOffsetAtX:x andY:y];
            // NSLog(@"r[%lu,%lu] = %u", x, y, rXY);
            NSUInteger bX = y;
            NSUInteger bY = ((2*x)+(3*y))%5;
            // NSLog(@"B[%lu,%lu] = rot(A[%lu,%lu], r[%lu,%lu]) = %u", bX, bY, x, y, x, y, [self ROTfromW:aXY byR:rXY]);
            NSUInteger index = (bX + (bY * A.maxRows));
            // NSLog(@"index = %lu", index);
            [B setValue:[NSNumber numberWithUnsignedInt:[self ROTfromW:aXY byR:rXY]] forKey:[NSString stringWithFormat:@"%lu", index]];
        }
    }
    
    NSUInteger index = 0;
    for (NSUInteger row=0; row<5; row++) {
        NSMutableString *rowInState = [[NSMutableString alloc] initWithString:@"[ "];
        for (NSUInteger column=0; column<5; column++) {
            [rowInState appendString:[NSString stringWithFormat:@"%@ ", [B valueForKey:[NSString stringWithFormat:@"%lu", index]]]];
            index++;
        }
        [rowInState appendString:@"]"];
        // NSLog(@"%@", rowInState);
    }
    
    return B;
}

// Step 3
- (KeccakBlock*)keccakChiWithBlock:(KeccakBlock*)A andB:(NSMutableDictionary*)B
{
    // NSLog(@"Chi");
    // A[x,y] = B[x,y] xor ((not B[x+1,y]) and B[x+2,y]),   forall (x,y) in (0...4,0...4)
    for (NSUInteger x=0; x<A.maxRows; x++) {
        for (NSUInteger y=0; y<A.maxColumns; y++) {
            unsigned bXY = [[B valueForKey:[NSString stringWithFormat:@"%lu", (x + (y * A.maxRows))]] unsignedIntValue];
            // NSLog(@"B[%lu,%lu] = %u", x, y, bXY);
            
            unsigned bXplus1Y = [[B valueForKey:[NSString stringWithFormat:@"%lu", (((x+1)%A.maxColumns) + (y * A.maxRows))]] unsignedIntValue];
            // NSLog(@"~B[%lu,%lu] = ~%u", ((x+1)%[A maxColumns]), y, bXplus1Y);
            
            unsigned bXplus2Y  = [[B valueForKey:[NSString stringWithFormat:@"%lu", (((x+2)%A.maxColumns) + (y * A.maxRows))]] unsignedIntValue];
            // NSLog(@"B[%lu,%lu] = %u", ((x+2)%[A maxColumns]), y, bXplus2Y);
            
            [A setLaneValue:(bXY^((~bXplus1Y)&bXplus2Y)) toColumn:x andRow:y];
            // NSLog(@"A[%lu,%lu] = B[%lu,%lu] xor ((not B[%lu,%lu]) and B[%lu,%lu]) = %u", x, y, x, y, ((x+1)%[A maxColumns]), y, ((x+2)%[A maxColumns]), y, (bXY^((~bXplus1Y)&bXplus2Y)));
        }
    }
    return A;
}

// Step 4
- (KeccakBlock*)keccakIotaWithBlock:(KeccakBlock*)A
{
    // ONLY FOR W=400!!!
    // A[0,0] = A[0,0] xor RC
    // NSLog(@"Iota");
    NSString *RC = [[NSString alloc] init];
    switch (self.round) {
        case 0:  RC = @"0000000000000001"; break;
        case 1:  RC = @"0000000000008082"; break;
        case 2:  RC = @"800000000000808A"; break;
        case 3:  RC = @"8000000080008000"; break;
        case 4:  RC = @"000000000000808B"; break;
        case 5:  RC = @"0000000080000001"; break;
        case 6:  RC = @"8000000080008081"; break;
        case 7:  RC = @"8000000000008009"; break;
        case 8:  RC = @"000000000000008A"; break;
        case 9:  RC = @"0000000000000088"; break;
        case 10: RC = @"0000000080008009"; break;
        case 11: RC = @"000000008000000A"; break;
        case 12: RC = @"000000008000808B"; break;
        case 13: RC = @"800000000000008B"; break;
        case 14: RC = @"8000000000008089"; break;
        case 15: RC = @"8000000000008003"; break;
        case 16: RC = @"8000000000008002"; break;
        case 17: RC = @"8000000000000080"; break;
        case 18: RC = @"000000000000800A"; break;
        case 19: RC = @"800000008000000A"; break;
        case 20: RC = @"8000000080008081"; break;
        case 21: RC = @"8000000000008080"; break;
        case 22: RC = @"0000000080000001"; break;
        case 23: RC = @"8000000080008008"; break;
            
        default: // THROW ERROR
            break;
    }
    
    NSUInteger lenOfTruncatedRC;
    BOOL modulusRC = NO;
    switch (_width) {
        case 1600: lenOfTruncatedRC = _maxLaneBits / 4; break;
        case  800: lenOfTruncatedRC = _maxLaneBits / 4; break;
        case  400: lenOfTruncatedRC = _maxLaneBits / 4; break;
        case  200: lenOfTruncatedRC = _maxLaneBits / 4; break;
        case  100: lenOfTruncatedRC = _maxLaneBits / 4; break;
        case   50: lenOfTruncatedRC = 1; modulusRC = YES; break;
        case   25: lenOfTruncatedRC = 1; modulusRC = YES; break;
        default: lenOfTruncatedRC = 0; break;
    }
    // NSLog(@"len = %lu", lenOfTruncatedRC);
    NSUInteger locOfTruncatedRC = [RC length] - lenOfTruncatedRC;
    // NSLog(@"loc = %lu", locOfTruncatedRC);
    RC = [RC substringWithRange:NSMakeRange(locOfTruncatedRC, lenOfTruncatedRC)];
    // NSLog(@"RC = %@", RC);
    // NSLog(@"Before A[0,0] = %lu", [[A laneAtColumn:0 andRow:0] value]);
    
    // Convert hex string to integer equivalent
    NSScanner *scanner = [NSScanner scannerWithString:RC];
    unsigned intRC = 0;
    [scanner scanHexInt:&intRC];
    if (modulusRC) {
        intRC %= (_maxLaneValue + 1);
    }
    // NSLog(@"intRC = %u", intRC);
    [A setLaneValue:[[A laneAtColumn:0 andRow:0] unsignedValue]^intRC toColumn:0 andRow:0];
    // NSLog(@"After A[0,0] = %lu", [[A laneAtColumn:0 andRow:0] value]);
    
    return A;
}

- (unsigned)ROTfromW:(unsigned)w byR:(unsigned)r
{
    // rot(W,r) is the usual bitwise cyclic shift operation, moving bit at
    // position i into position i+r (modulo the lane size).
    
    r = r % _maxLaneBits; // 2^8=256
    w = w << r; // Bit shift to left
    unsigned v = w >> _maxLaneBits; // Bits 2^4=16+
    while (w >= (_maxLaneValue + 1)) { // 256 = maxValue
        w -= (_maxLaneValue + 1);
    }
    return w + v;
}

- (unsigned)rotationOffsetAtX:(NSUInteger)x andY:(NSUInteger)y
{
    unsigned rotationOffset = 0;
    
    // All operations on the indices are done module 5, which is the number of items in C.
    x %= 5;
    y %= 5;
    
    //         THE ROTATION OFFSETS
    //         --------------------
    //
    //      | x=0 | x=1 | x=2 | x=3 | x=4 |
    //  ----+-----+-----+-----+-----+-----+
    //  y=0 |  0  |  1  | 62  | 28  | 27  |
    //  ----+-----+-----+-----+-----+-----+
    //  y=1 | 36  | 44  |  6  | 55  | 20  |
    //  ----+-----+-----+-----+-----+-----+
    //  y=2 |  3  | 10  | 43  | 25  | 39  |
    //  ----+-----+-----+-----+-----+-----+
    //  y=3 | 41  | 45  | 15  | 21  |  8  |
    //  ----+-----+-----+-----+-----+-----+
    //  y=4 | 18  |  2  | 61  | 56  | 14  |
    //  ----+-----+-----+-----+-----+-----+
    
    
    switch (x) {
        case 0:
            switch (y) {
                case 0: rotationOffset = 0; break;
                case 1: rotationOffset = 36; break;
                case 2: rotationOffset = 3; break;
                case 3: rotationOffset = 41; break;
                case 4: rotationOffset = 18; break;
                default: // Throw Error
                    break;
            }
            break;
        case 1:
            switch (y) {
                case 0: rotationOffset = 1; break;
                case 1: rotationOffset = 44; break;
                case 2: rotationOffset = 10; break;
                case 3: rotationOffset = 45; break;
                case 4: rotationOffset = 2; break;
                default: // Throw Error
                    break;
            }
            break;
        case 2:
            switch (y) {
                case 0: rotationOffset = 62; break;
                case 1: rotationOffset = 6; break;
                case 2: rotationOffset = 43; break;
                case 3: rotationOffset = 15; break;
                case 4: rotationOffset = 61; break;
                default: // Throw Error
                    break;
            }
            break;
        case 3:
            switch (y) {
                case 0: rotationOffset = 28; break;
                case 1: rotationOffset = 55; break;
                case 2: rotationOffset = 25; break;
                case 3: rotationOffset = 21; break;
                case 4: rotationOffset = 56; break;
                default: // Throw Error
                    break;
            }
            break;
        case 4:
            switch (y) {
                case 0: rotationOffset = 27; break;
                case 1: rotationOffset = 20; break;
                case 2: rotationOffset = 39; break;
                case 3: rotationOffset = 8; break;
                case 4: rotationOffset = 14; break;
                default: // Throw Error
                    break;
            }
            break;
            
        default: // Throw Error
            break;
    }
    return rotationOffset % _maxLaneValue; // Modulus the size of the lane
}

@end

/*
 - (void)setHexMessage:(NSString*)aHexMessage;
 {
 if ([aHexMessage length] > [self maxHexCharactersInMessage]) {
 [NSException raise:@"Message exceeds sponge capacity." format:@"Length of %lu (%lu bits) exceeds the capacity of %lu bits.", [aHexMessage length], ([aHexMessage length]*self.bitsInHexChar), self.capacity];
 }
 _hexMessage = aHexMessage;
 NSUInteger hexCount = 0;
 for (NSUInteger row=0; row<self.maxRows; row++) {
 for (NSUInteger column=0; column<self.maxColumns; column++) {
 KeccakLane *newLane;
 if (hexCount < [aHexMessage length]) {
 // newLane = [[KeccakLane alloc] initWithHexValue:[aHexMessage substringWithRange:NSMakeRange(hexCount, 1)]];
 } else {
 // newLane = [[KeccakLane alloc] initWithHexValue:@"0"];
 }
 [self.state insertObject:newLane atIndex:hexCount];
 hexCount++;
 }
 }
 }
 */


/*
 =================================================================
 =================================================================
 
 #import "NSString+Base64.h"

const unsigned int BITS_PER_BYTE = 8;
const unsigned int ROW_MAX = 5;
const unsigned int COLUMN_MAX = 5;
const unsigned int LANE_BYTES = 1;

@interface KeccakMessage ()
{
    bool state[ROW_MAX][COLUMN_MAX][BITS_PER_BYTE*LANE_BYTES];
}

@property (nonatomic, strong) NSString *stateArray;
@property (nonatomic) BOOL squeezing;

- (void)absorbBlock:(NSString *)block;
- (void)absorbMessage;
- (void)clearState;
- (NSString*)convertPlainTextToHex:(NSString*)plainText;
- (int)getLaneAtRow:(NSInteger)aRow andColumn:(NSInteger)aColumn;
- (NSString *) hexToBinary:(unichar)myChar;
- (void)keccakF;
- (void)keccakRound;
- (int[])rot:(int[])C times:(int)i;
- (void)squeezeMesageWithOutputLength:(NSUInteger)outputLength;
- (NSString*)suffix;

@end

@implementation KeccakMessage

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        _r = 40;
        _c = 160;
        _plainBinaryText = [[NSMutableString alloc] initWithString:@""];
        _plainHexText = @"";
        _plainText = @"";
        _cypherText = @"";
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveState) name:@"Save Keccak State" object:nil];
    }
    return self;
}


- (NSUInteger)b
{
    return _r + _c;
}


- (void)clearState
{
    for (unsigned int i=0; i<ROW_MAX; i++) {
        for (unsigned int j=0; j<COLUMN_MAX; j++) {
            for (unsigned int k=0; k<(LANE_BYTES*BITS_PER_BYTE); k++) {
                state[i][j][k] = false;
            }
        }
    }
    _squeezing = NO;
    [self NSLogState];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Save Keccak State" object:nil];
}


- (NSString*)encryptMessage:(NSString*)plainText
               withCapacity:(NSUInteger)capacity
                   withRate:(NSUInteger)rate
           withOutputLength:(NSUInteger)outputLength
       andFixedOutputLength:(BOOL)fixedOuputLength
{
    NSLog(@"encryptMessage: %@", plainText);
    _plainText = plainText;
    
    [self clearState];
    [self absorbMessage];
    // [self squeezeMesageWithOutputLength:outputLength];
    
    _cypherText = @"cypher text";
    
    return _cypherText;
}

- (void)absorbBlock:(NSString *)block
{
    NSUInteger i=0, j=0, k=0;
    for (NSUInteger l=0; l<[block length]; l++)
    {
        if ([[block substringWithRange:NSMakeRange(l, 1)] isEqualToString:@"1"]) {
            state[i][j][k] = true;
        } else {
            state[i][j][k] = false;
        }
        j++;
        if (j == COLUMN_MAX) {
            j=0;
            i++;
        }
        if (i == ROW_MAX) {
            i=0;
            k++;
        }
        if (k == LANE_BYTES*BITS_PER_BYTE) {
            break;
        }
    }
    [self NSLogState];
}


- (void)absorbMessage
{
    _plainHexText = [self convertPlainTextToHex:self.plainText];
    NSLog(@"plainHexText: %@", self.plainHexText);
    _plainBinaryText = [[NSMutableString alloc] init];
    for(NSUInteger l=0; l<[self.plainHexText length]; l++)
    {
        [_plainBinaryText appendString:[self hexToBinary:[self.plainHexText characterAtIndex:l]]];
    }
    NSLog(@"plainBinaryText: %@", self.plainBinaryText);
    if ([self.plainBinaryText length] == 0) {
        return;
    }
    if (_r + _c == 0)
    {
        return;
    }
    if (_squeezing) {
        NSLog(@"[SpongeException] - The absorbing phase is over.");
    } else {
        NSLog(@"[absorbMessage] - The absorbing phase is NOT over yet.");
    }
    NSString *absorbQueue = [[NSMutableString alloc] initWithString:self.plainBinaryText];
    NSLog(@"absorbQueue: %@", absorbQueue);
    while ([absorbQueue length] > 0) {
        [self absorbBlock:absorbQueue];
        [self keccakF];
        
        // Removes
        if ([absorbQueue length] > (ROW_MAX*COLUMN_MAX*BITS_PER_BYTE*LANE_BYTES)) {
            absorbQueue = [absorbQueue substringFromIndex:(ROW_MAX*COLUMN_MAX*BITS_PER_BYTE*LANE_BYTES)];
        } else {
            absorbQueue = @"";
        }
        NSLog(@"absorbQueue: %@", absorbQueue);
    }
}


- (NSString*)convertPlainTextToHex:(NSString*)plainText
{
    NSString * plainTextInHex = [NSString stringWithFormat:@"%@",
                                 [NSData dataWithBytes:[plainText cStringUsingEncoding:NSUTF8StringEncoding]
                                                length:strlen([plainText cStringUsingEncoding:NSUTF8StringEncoding])]];
    for(NSString * toRemove in [NSArray arrayWithObjects:@"<", @">", @" ", nil])
    {
        plainTextInHex = [plainTextInHex stringByReplacingOccurrencesOfString:toRemove withString:@""];
    }
    return plainTextInHex;
}

- (int)getLaneAtRow:(NSInteger)aRow andColumn:(NSInteger)aColumn
{
    NSMutableString* theLaneAsString = [[NSMutableString alloc] init];
    for (NSUInteger k=0; k<(BITS_PER_BYTE*LANE_BYTES); k++) {
        if (state[aRow][aColumn][k] == true) {
            [theLaneAsString appendString:@"1"];
        } else {
            [theLaneAsString appendString:@"0"];
        }
    }
    NSLog(@"[getLaneAsRow]: %@", theLaneAsString);
    return [theLaneAsString intValue];
}

- (NSString *) hexToBinary:(unichar)myChar
{
    switch(myChar)
    {
        case '0': return @"0000";
        case '1': return @"0001";
        case '2': return @"0010";
        case '3': return @"0011";
        case '4': return @"0100";
        case '5': return @"0101";
        case '6': return @"0110";
        case '7': return @"0111";
        case '8': return @"1000";
        case '9': return @"1001";
        case 'a':
        case 'A': return @"1010";
        case 'b':
        case 'B': return @"1011";
        case 'c':
        case 'C': return @"1100";
        case 'd':
        case 'D': return @"1101";
        case 'e':
        case 'E': return @"1110";
        case 'f':
        case 'F': return @"1111";
    }
    return @"-1"; //means something went wrong, shouldn't reach here!
}

- (void)keccakF
{
    for (NSUInteger i=0; i<[self numberOfRounds]; i++) {
        [self keccakRound];
    }
}

- (void)keccakRound
{
    NSLog(@"round");
    
    /----------*
     *  θ step  *
     *----------/
    int C[ROW_MAX];
    for (int x=0; x<ROW_MAX; x++) {
        C[x] = [self getLaneAtRow:x andColumn:0] ^
               [self getLaneAtRow:x andColumn:1] ^
               [self getLaneAtRow:x andColumn:2] ^
               [self getLaneAtRow:x andColumn:3] ^
               [self getLaneAtRow:x andColumn:4];
    }
    
    int D[ROW_MAX];
    for (int x=0; x<ROW_MAX; x++) {
        // D[x] = C[x-1] ^ [self rot:C[x+1] times:1]
    }
    /
    // for all x in 0…4
    D[x] = C[x-1] xor rot(C[x+1],1),                             forall x in 0…4
    A[x,y] = A[x,y] xor D[x],                          forall (x,y) in (0…4,0…4)
    
    // ρ and π steps
    B[y,2*x+3*y] = rot(A[x,y], r[x,y]),                forall (x,y) in (0…4,0…4)
    
    // χ step
    A[x,y] = B[x,y] xor ((not B[x+1,y]) and B[x+2,y]), forall (x,y) in (0…4,0…4)
    
    // ι step
    A[0,0] = A[0,0] xor RC
    
    [self NSLogState];
     /
}

- (void)NSLogState
{
    for (unsigned int k=0; k<(LANE_BYTES*BITS_PER_BYTE); k++) {
        for (unsigned int i=0; i<ROW_MAX; i++) {
            NSLog(@"[%d %d %d %d %d]", state[i][0][k], state[i][1][k], state[i][2][k], state[i][3][k], state[i][4][k]);
        }
        NSLog(@"\n");
    }
}



// - (int[])rot:(int[])C times:(int)i
// {
//     return C;
// }

- (void)saveState
{
    NSLog(@"Save Keccak State");
}


- (void)squeezeMesageWithOutputLength:(NSUInteger)outputLength
{
    NSLog(@"squeezeMesageWithOutputLength: %lu", (unsigned long)outputLength);
    if (!_squeezing)
    {
        // flushAndSwitchToSqueezingPhase();
    }
}


- (NSString*)suffix
{
    return [NSString stringWithFormat: @"%lu", (unsigned long)_c];
}

@end

*/
