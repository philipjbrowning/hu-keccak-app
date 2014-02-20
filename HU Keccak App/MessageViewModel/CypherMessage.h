//
//  CypherMessage.h
//  HU Keccak App
//
//  Created by Philip J Browning II on 1/28/14.
//  Copyright (c) 2014 Philip Browning. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KeccakDataLog.h"

@interface CypherMessage : NSObject

@property (nonatomic) NSString *text;
@property (nonatomic) NSDate *date;
@property (nonatomic, strong) KeccakDataLog *log;

- (id)init;
- (id)initWithString:(NSString*)someText;

@end
