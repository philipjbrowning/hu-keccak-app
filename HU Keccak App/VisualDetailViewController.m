//
//  VisualDetailViewController.m
//  HU Keccak App
//
//  Created by Philip J Browning II on 2/20/14.
//  Copyright (c) 2014 Philip Browning. All rights reserved.
//

#import "VisualDetailViewController.h"

@interface VisualDetailViewController ()

@end

@implementation VisualDetailViewController

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
    
    _glView = [[VisualDetail alloc] initWithFrame:CGRectMake(0, 0, 320, 534)];
    [self.view addSubview:_glView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
