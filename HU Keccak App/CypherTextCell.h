//
//  CypherTextCell.h
//  HU Keccak App
//
//  Created by Philip J Browning II on 11/14/13.
//  Copyright (c) 2013 Philip Browning. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CypherTextCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *messageTextLabel;
@property (weak, nonatomic) IBOutlet UIView *messageView;
@property (weak, nonatomic) IBOutlet UIButton *detailViewButton;

- (IBAction)viewKeccakDetails:(id)sender;

@end
