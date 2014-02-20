//
//  DetailViewController.h
//  HU Keccak App
//
//  Created by Philip J Browning II on 11/14/13.
//  Copyright (c) 2013 Philip Browning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CypherMessage.h"
#import "Message.h"
#import "MessageViewController.h"

@interface DetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *plainTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *cypherTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *rLabel;
@property (weak, nonatomic) IBOutlet UILabel *cLabel;
@property (weak, nonatomic) IBOutlet UILabel *bLabel;
@property (weak, nonatomic) IBOutlet UILabel *securityLevelLabel;

// IN THE FUTURE, send the Keccak Object itself
@property (nonatomic) NSInteger itemIndex;
@property (nonatomic) NSInteger r;
@property (nonatomic) NSInteger c;
@property (nonatomic, strong) CypherMessage *cypherTextMessage;
@property (nonatomic, strong) Message *plainTextMessage;

- (NSInteger)getB;
- (IBAction)visualDetailButtonPressed:(id)sender;

@end
