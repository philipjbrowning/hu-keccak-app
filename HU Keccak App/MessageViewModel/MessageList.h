//
//  MessageList.h
//  HU Keccak App
//
//  Created by Philip J Browning II on 11/13/13.
//  Copyright (c) 2013 Philip Browning. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CypherMessage.h"
#import "Message.h"

@interface MessageList : NSObject

@property (nonatomic) NSMutableArray *messages; // Message class
@property (nonatomic) NSMutableArray *cypherMessages; // CypherMessage class

- (void)insertCypherMessage:(CypherMessage*)aMessage;
- (void)insertMessage:(Message*)aMessage;
- (CypherMessage*)getLastCypherMessage;
- (Message*)getLastMessage;
- (id)getMessageAtIndex:(NSUInteger)index;
- (NSUInteger)numberOfCypherMessages;
- (NSUInteger)numberOfMessages;
- (NSUInteger)numberOfTotalMessages;

@end
