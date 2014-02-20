//
//  DetailViewController.m
//  HU Keccak App
//
//  Created by Philip J Browning II on 11/14/13.
//  Copyright (c) 2013 Philip Browning. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _cypherTextMessage = [[CypherMessage alloc] init];
        _plainTextMessage = [[Message alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
    _cypherTextLabel.text = _cypherTextMessage.text;
    _plainTextLabel.text = _plainTextMessage.text;
    _rLabel.text = [[NSString alloc] initWithFormat:@"%lu", _r];
    _cLabel.text = [[NSString alloc] initWithFormat:@"%lu", _c];
    _bLabel.text = [[NSString alloc] initWithFormat:@"%lu", [self getB]];
    _securityLevelLabel.text = [[NSString alloc] initWithFormat:@"2^%lu", (_c / 2)];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)getB
{
    return _r + _c;
}

- (IBAction)visualDetailButtonPressed:(id)sender {
    // asdf
}
@end
