//
//  MessageListTests.m
//  HU Keccak App
//
//  Created by Philip J Browning II on 1/28/14.
//  Copyright (c) 2014 Philip Browning. All rights reserved.
//

#import "MessageListTests.h"

@implementation MessageListTests

- (void)setUp
{
    _messageList = [[MessageList alloc] init];
}

- (void)tearDown
{
    
}

- (void)testInitialization
{
    NSUInteger zero = 0;
    XCTAssertEqual(zero, [self.messageList numberOfMessages], @"Should equal zero.");
}

- (void)testInsertAndGetLastCypherMessage
{
    CypherMessage *cypherText = [[CypherMessage alloc] initWithString:@"b6c369d2"];
    [_messageList insertCypherMessage:cypherText];
    XCTAssertEqualObjects(cypherText, [_messageList getLastCypherMessage], @"Last");
}

- (void)testInsertAndGetLastMessage
{
    Message *text = [[Message alloc] initWithString:@"plain text"];
    [_messageList insertMessage:text];
    XCTAssertEqualObjects(text, [_messageList getLastMessage], @"Last");
}

- (void)testNumberOfCypherMessages
{
    for (NSUInteger i=1; i<5; i++) {
        [_messageList insertMessage:[[Message alloc] initWithString:@"plain text"]];
        XCTAssertEqual(i, [_messageList numberOfMessages], @"asdf");
    }
}

@end
