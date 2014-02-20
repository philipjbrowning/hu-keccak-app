//
//  KeccakDataLog.h
//  HU Keccak App
//
//  Created by Philip J Browning II on 1/28/14.
//  Copyright (c) 2014 Philip Browning. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KeccakAbsorbingPhaseLog.h"
#import "KeccakInitializationPhaseLog.h"
#import "KeccakSqueezingPhaseLog.h"

@interface KeccakDataLog : NSObject

@property (nonatomic) BOOL fixedOutputLength;
@property (nonatomic) BOOL saveChiState;
@property (nonatomic) BOOL saveIotaState;
@property (nonatomic) BOOL saveRhoAndPiState;
@property (nonatomic) BOOL saveRoundState;
@property (nonatomic) BOOL saveThetaState;

@property (nonatomic) NSUInteger capacity;
@property (nonatomic) NSUInteger rate;
@property (nonatomic) NSUInteger outputLength;
@property (nonatomic) NSUInteger width;

@property (nonatomic) NSString *securityLevel;

@property (nonatomic, weak) KeccakAbsorbingPhaseLog *absorbingPhase;
@property (nonatomic, weak) KeccakInitializationPhaseLog *initializationPhase;
@property (nonatomic, weak) KeccakSqueezingPhaseLog* squeezingPhase;

@end
