//
//  MessageList.m
//  HU Keccak App
//
//  Created by Philip J Browning II on 11/13/13.
//  Copyright (c) 2013 Philip Browning. All rights reserved.
//

#import "MessageList.h"

@implementation MessageList

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        _cypherMessages = [[NSMutableArray alloc] init];
        _messages = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)insertCypherMessage:(CypherMessage*)aMessage
{
    [self.cypherMessages addObject:aMessage];
}

- (void)insertMessage:(Message *)aMessage
{
    [self.messages addObject:aMessage];
}


- (CypherMessage*)getLastCypherMessage
{
    return [self.cypherMessages lastObject];
}

- (Message*)getLastMessage
{
    return [self.messages lastObject];
}

- (id)getMessageAtIndex:(NSUInteger)index
{
    if (index%2==0) {
        // Return message
        return [self.messages objectAtIndex:(index/2)];
    }
    // Return cypherMessage
    return [self.cypherMessages objectAtIndex:(index/2)];
}


- (NSUInteger)numberOfCypherMessages
{
    return [self.cypherMessages count];
}

- (NSUInteger)numberOfMessages
{
    return [self.messages count];
}

- (NSUInteger)numberOfTotalMessages
{
    return [self.messages count] + [self.cypherMessages count];
}




- (NSUInteger)numberOfMessagesOfType:(enum MessageType)aType
{
    if (aType == CYPHER_TEXT) {
        return [self.cypherMessages count];
    }
    if (aType == PLAIN_TEXT) {
        return [self.messages count];
    }
    return -1; // ERROR
}

@end
