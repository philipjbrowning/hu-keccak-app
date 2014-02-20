//
//  KeccakSponge.m
//  HU Keccak App
//
//  Created by Philip J Browning II on 11/8/13.
//  Copyright (c) 2013 Philip Browning. All rights reserved.
//

#import "KeccakSponge.h"

@interface KeccakSponge()

@property (nonatomic) NSMutableArray* state; // BOOL Class
@property (nonatomic) NSString* plainText;

- (int)bitValueAsIntegerFromIndex:(NSUInteger)index;
- (void)clearState;
- (NSString*)plainTextInBinary;
- (NSString*)plainTextInHex;

@end

@implementation KeccakSponge

- (id)initWithPlainText:(NSString*)plainText
           withCapacity:(NSUInteger)capacity
               withRate:(NSUInteger)rate
       withOutputLength:(NSUInteger)outputLength
   andFixedOutputLength:(BOOL)fixedOuputLength
{
    self = [super init];
    if (self) {
        // Custom initialization
        _bitsPerByte = 8;
        _columnMax = 5;
        _laneBytes = 1;
        _rowMax = 5;
        
        if ((rate + capacity) != [self numberOfBits]) {
            // THROW ERROR
        }
        
        _rate = rate;
        _capacity = capacity;
        _description = @"A keccak sponge."; // UPDATE
        _fixedOuputLength = fixedOuputLength;
        _outputLength = outputLength;
        _plainText = plainText;
        _state = [[NSMutableArray alloc] init];
        
        [self clearState];
        // NSLog(@"Plain Text in Hex: %@", [self plainTextInHex]);
        // NSLog(@"Plain Text in Binary: %@", [self plainTextInBinary]);
        [self absorb:[self plainTextInBinary]];
        // [self NSLogState];
        
    }
    return self;
}

- (void)absorb:(NSString*)inputBits
{
    for (NSUInteger i=0; i<[inputBits length]; i++) {
        if ([[inputBits substringWithRange:NSMakeRange(i, 1)] isEqual:@"1"]) {
            [self.state insertObject:[NSNumber numberWithBool:YES] atIndex:i];
        } else { // [[inputBits substringWithRange:NSMakeRange(i, 1)] isEqual:@"0"]
            [self.state insertObject:[NSNumber numberWithBool:NO] atIndex:i];
        }
    }
}

- (NSUInteger)width
{
    return _rate + _capacity;
}

- (int)bitValueAsIntegerFromIndex:(NSUInteger)index
{
    if([[_state objectAtIndex:index] boolValue] == YES)
    {
        return 1;
    } else {
        return 0;
    }
}

- (void)clearState
{
    for (NSUInteger i=0; i<[self numberOfBits]; i++) {
        [self.state insertObject:[NSNumber numberWithBool:NO] atIndex:i];
    }
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

- (NSString*)plainTextInBinary;
{
    NSString* hexText = [self plainTextInHex];
    NSMutableString* binaryText = [[NSMutableString alloc] init];
    for(NSUInteger l=0; l<[hexText length]; l++)
    {
        [binaryText appendString:[self hexToBinary:[hexText characterAtIndex:l]]];
    }
    return binaryText;
}

- (NSString*)plainTextInHex;
{
    NSString * hexText = [NSString stringWithFormat:@"%@",
                                 [NSData dataWithBytes:[_plainText cStringUsingEncoding:NSUTF8StringEncoding]
                                                length:strlen([_plainText cStringUsingEncoding:NSUTF8StringEncoding])]];
    for(NSString * toRemove in [NSArray arrayWithObjects:@"<", @">", @" ", nil])
    {
        hexText = [hexText stringByReplacingOccurrencesOfString:toRemove withString:@""];
    }
    return hexText;
}

- (NSUInteger)numberOfBits
{
    return (_rowMax * _columnMax * _laneBytes * _bitsPerByte);
}

- (NSUInteger)numberOfSlices
{
    return (_laneBytes * _bitsPerByte);
}

- (NSUInteger)objectInRow:(NSUInteger)x inColumn:(NSUInteger)y inSlice:(NSUInteger)slice
{
    return [[_state objectAtIndex:(x+(y*self.columnMax)+(slice*self.rowMax*self.columnMax))] integerValue];
}

- (void)NSLogState
{
    NSUInteger i=0;
    for (NSUInteger k=0; k<(_laneBytes * _bitsPerByte); k++) {
        for (NSUInteger j=0; j<_rowMax; j++) {
            NSLog(@"[%d %d %d %d %d]", [self bitValueAsIntegerFromIndex:i], [self bitValueAsIntegerFromIndex:(i+1)], [self bitValueAsIntegerFromIndex:(i+2)], [self bitValueAsIntegerFromIndex:(i+3)], [self bitValueAsIntegerFromIndex:(i+4)]);
            i += _rowMax;
        }
        NSLog(@"\n");
    }
}

/*
@property (nonatomic, strong) KeccakTransformation *f;
// @property (nonatomic, strong) PaddingRule *pad;
@property (nonatomic) BOOL squeezing;

// The state of the sponge construction.
// auto_ptr<UINT8> state;
// The message blocks not yet absorbed.
// @property (nonatomic, strong) MessageQueue *absorbQueue;
// Buffer containing the partial block that is being squeezed.
// deque<UINT8> squeezeBuffer;

- (void)absorbBlock:(NSString*)inputBlock;
- (void)flushAndSwitchToSqueezingPhase;
- (void)squeezeIntoBuffer;
- (void)fromStateToSqueezeBuffer;



- (id)initWithTransformation:(KeccakTransformation*)aF withPaddingRule:(PaddingRule*)aPad andWithRate:(NSUInteger)aRate
{
    
}

- (void)absorb:(NSString*)inputBits
{
    
}

- (void)absorbBlock:(NSString*)inputBlock
{
    
}

- (void)flushAndSwitchToSqueezingPhase
{
    
}

- (void)fromStateToSqueezeBuffer
{
    
}

- (void)reset
{
    _squeezing = false;
    NSUInteger width = f->getWidth();
    for (NSUInteger i=0; i<(width+7)/8; i++)
    {
        state.get()[i] = 0;
    }
    absorbQueue.clear();
    squeezeBuffer.clear();
}

- (void)squeeze:(NSString*)outputBits withDesiredLengthInBits:(NSUInteger) desiredLengthInBits
{
    
}

- (void)squeezeIntoBuffer
{
    
}
*/

@end
