//
//  EditSettingsViewController.m
//  HU Keccak App
//
//  Created by Philip J Browning II on 11/21/13.
//  Copyright (c) 2013 Philip Browning. All rights reserved.
//

#import "EditSettingsViewController.h"
#import "MessageViewController.h"

@interface EditSettingsViewController () {
    double charBitLengthInBinary;
}

@property (nonatomic) NSUInteger widthMax;

- (void)updateRateAndCapacityLabels;

@end

@implementation EditSettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{

    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.widthMax = 200;
    
    // UIStepper
    charBitLengthInBinary = 8.0;
    [self.capacityStepper setMaximumValue:self.widthMax];
    [self.capacityStepper setStepValue:charBitLengthInBinary];
    [self.rateStepper setMaximumValue:self.widthMax];
    [self.rateStepper setStepValue:charBitLengthInBinary];
    [self.outputLengthStepper setStepValue:charBitLengthInBinary];
    [self.outputLengthStepper setMinimumValue:0];
    [self.outputLengthStepper setMaximumValue:1600];
    
    [self resetState];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)changeCapacity:(id)sender {
    self.capacity = self.capacityStepper.value;
    self.rate = self.widthMax - self.capacity;
    [self updateRateAndCapacityLabels];
    [self saveRateAndCapacity];
}

- (IBAction)changeRate:(id)sender {
    self.rate = self.rateStepper.value;
    self.capacity = self.widthMax - self.rate;
    [self updateRateAndCapacityLabels];
    [self saveRateAndCapacity];
}

- (IBAction)changeOutputLength:(id)sender {
    self.outputLength = self.outputLengthStepper.value;
    self.outputLengthLabel.text = [[NSString alloc] initWithFormat:@"%lu", self.outputLength];
    [self saveUserDefaultWithKey:@"keccakOutputLength" andObject:self.outputLengthLabel.text];
}

- (IBAction)changeSavingOfRoundState:(id)sender {
    if ([self.saveRoundSwitch isOn]) {
        self.saveRoundState = YES;
        [self saveUserDefaultWithKey:@"saveRoundState" andObject:@"YES"];
    } else {
        self.saveRoundState = NO;
        [self saveUserDefaultWithKey:@"saveRoundState" andObject:@"NO"];
    }
}

- (void)resetState
{
    // Set Capacity and Rate
    self.capacityStepper.value = self.capacity;
    self.rateStepper.value = self.rate;
    [self updateRateAndCapacityLabels];
    
    // Set Output Length
    self.outputLengthStepper.value = self.outputLength;
    self.outputLengthLabel.text = [[NSString alloc] initWithFormat:@"%lu", self.outputLength];
    
    // Set Width
    self.widthLabel.text = [[NSString alloc] initWithFormat:@"%lu", self.widthMax];
    
    // Save Round States or Not
    [self.saveRoundSwitch setOn:self.saveRoundState];
}

- (IBAction)changeFixedOutputLength:(id)sender {
}

- (IBAction)changeSavingThetaState:(id)sender {
}

- (IBAction)changeSavingRhoAndPiState:(id)sender {
}

- (IBAction)changeSavingChiStep:(id)sender {
}

- (IBAction)changeSavingIotaStep:(id)sender {
}

- (void)updateRateAndCapacityLabels
{
    self.capacityLabel.text = [[NSString alloc] initWithFormat:@"%lu", self.capacity];
    self.rateLabel.text = [[NSString alloc] initWithFormat:@"%lu", self.rate];
}

#pragma mark - NSUserDefaults

- (void)saveRateAndCapacity
{
    [self saveUserDefaultWithKey:@"keccakCapacity" andObject:[NSString stringWithFormat:@"%lu", self.capacity]];
    [self saveUserDefaultWithKey:@"keccakRate" andObject:[NSString stringWithFormat:@"%lu", self.rate]];
}

- (void)saveUserDefaultWithKey:(NSString*)key andObject:(NSString*)object
{
    NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
    [standardDefaults setObject:object forKey:key];
    [standardDefaults synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HUKeccakUpdatedUserDefaults" object:[NSDictionary dictionaryWithObject:object forKey:key]];
}

@end
