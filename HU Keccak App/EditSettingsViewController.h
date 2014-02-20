//
//  EditSettingsViewController.h
//  HU Keccak App
//
//  Created by Philip J Browning II on 11/21/13.
//  Copyright (c) 2013 Philip Browning. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditSettingsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *capacityLabel;
@property (weak, nonatomic) IBOutlet UILabel *outputLengthLabel;
@property (weak, nonatomic) IBOutlet UILabel *rateLabel;
@property (weak, nonatomic) IBOutlet UILabel *widthLabel;

@property (weak, nonatomic) IBOutlet UIStepper *capacityStepper;
@property (weak, nonatomic) IBOutlet UIStepper *rateStepper;
@property (weak, nonatomic) IBOutlet UIStepper *outputLengthStepper;

@property (weak, nonatomic) IBOutlet UISwitch *saveChiSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *fixedOutputLengthSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *saveIotaSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *saveRhoAndPiSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *saveRoundSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *saveThetaSwitch;

@property (nonatomic) NSInteger capacity;
@property (nonatomic) BOOL fixedOutputLength;
@property (nonatomic) NSInteger outputLength;
@property (nonatomic) NSInteger rate;
@property (nonatomic) BOOL saveRoundState;


- (IBAction)changeCapacity:(id)sender;
- (IBAction)changeFixedOutputLength:(id)sender;
- (IBAction)changeOutputLength:(id)sender;
- (IBAction)changeRate:(id)sender;
- (IBAction)changeSavingChiStep:(id)sender;
- (IBAction)changeSavingIotaStep:(id)sender;
- (IBAction)changeSavingOfRoundState:(id)sender;
- (IBAction)changeSavingRhoAndPiState:(id)sender;
- (IBAction)changeSavingThetaState:(id)sender;
- (void)resetState;



@end
