//
//  MessageViewController.h
//  HU Keccak App
//
//  Created by Philip J Browning II on 11/4/13.
//  Copyright (c) 2013 Philip Browning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <QuartzCore/QuartzCore.h>
#import "MessageList.h"

@interface MessageViewController : UIViewController

@property (weak, nonatomic) IBOutlet UICollectionView *messageCollectionView;
@property (weak, nonatomic) IBOutlet UIView *inputMessageView;
@property (weak, nonatomic) IBOutlet UITextField *userInputMessage;
@property (weak, nonatomic) IBOutlet UIButton *encryptMessageButton;
@property (strong, nonatomic) MessageList* messageList;
@property (nonatomic) NSMutableArray* messageIndexList; // NSIndex


- (IBAction)encryptButtonPressed:(id)sender;
- (IBAction)textFieldDidEndEditing:(UITextField *)sender;
// - (void)updateCell:(UICollectionViewCell*)cell usingMessage:(Message*)aMessage;

@end