//
//  ViewController.m
//  AddCoinView
//
//  Created by wyan assert on 9/6/16.
//  Copyright © 2016 wyan assert. All rights reserved.
//

#import "ViewController.h"
#import "PresentViewController.h"

@interface ViewController ()

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 50)];
    [button setTitle:@"Present" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor grayColor];
    [button addTarget:self action:@selector(present) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)present {
    PresentViewController *controller = [[PresentViewController alloc] init];
    [self presentViewController:controller animated:YES completion:nil];
}


@end
