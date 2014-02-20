//
//  PlainTextCell.h
//  HU Keccak App
//
//  Created by Philip J Browning II on 11/12/13.
//  Copyright (c) 2013 Philip Browning. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlainTextCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *messageTextLabel;
@property (weak, nonatomic) IBOutlet UIView *messageView;

@end
