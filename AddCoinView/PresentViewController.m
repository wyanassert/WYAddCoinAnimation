//
//  PrensentViewController.m
//  AddCoinView
//
//  Created by wyan assert on 9/8/16.
//  Copyright © 2016 wyan assert. All rights reserved.
//

#import "PresentViewController.h"
#import "AddCoinAnimationManager.h"

@interface PresentViewController () <AddCoinAnimationManagerDelegate>

@property (nonatomic, strong) AddCoinAnimationManager *addCoinAnimationManager;

@end

@implementation PresentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 400, 100, 50)];
    [button setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:button];
    [button setTitle:@"1" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 500, 100, 50)];
    [button1 setBackgroundColor:[UIColor greenColor]];
//    [self.view addSubview:button1];
    [button1 setTitle:@"1" forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(buttonAction1:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(135, 400, 100, 50)];
    [button2 setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:button2];
    [button2 setTitle:@"4" forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(buttonAction2:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button3 = [[UIButton alloc] initWithFrame:CGRectMake(135, 500, 100, 50)];
    [button3 setBackgroundColor:[UIColor greenColor]];
//    [self.view addSubview:button3];
    [button3 setTitle:@"4" forState:UIControlStateNormal];
    [button3 addTarget:self action:@selector(buttonAction3:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button4 = [[UIButton alloc] initWithFrame:CGRectMake(270, 400, 100, 50)];
    [button4 setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:button4];
    [button4 setTitle:@"36" forState:UIControlStateNormal];
    [button4 addTarget:self action:@selector(buttonAction4:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button5 = [[UIButton alloc] initWithFrame:CGRectMake(270, 500, 100, 50)];
    [button5 setBackgroundColor:[UIColor greenColor]];
//    [self.view addSubview:button5];
    [button5 setTitle:@"36" forState:UIControlStateNormal];
    [button5 addTarget:self action:@selector(buttonAction5:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *dismissButton = [[UIButton alloc] initWithFrame:CGRectMake(135, 600, 100, 50)];
    [dismissButton setBackgroundColor:[UIColor blackColor]];
    [dismissButton setTitle:@"dismiss" forState:UIControlStateNormal];
    [self.view addSubview:dismissButton];
    [dismissButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private

- (void)buttonAction:(UIButton *)button {
    [self.addCoinAnimationManager addCoins:1];
    [self addPopTask:1];
}

- (void)buttonAction1:(UIButton *)button {
    [self.addCoinAnimationManager popCoins:1];
}

- (void)buttonAction2:(UIButton *)button {
    [self.addCoinAnimationManager addCoins:4];
    [self addPopTask:4];
}

- (void)buttonAction3:(UIButton *)button {
    [self.addCoinAnimationManager popCoins:4];
}

- (void)buttonAction4:(UIButton *)button {
    [self.addCoinAnimationManager addCoins:36];
    [self addPopTask:36];
}

- (void)buttonAction5:(UIButton *)button {
    [self.addCoinAnimationManager popCoins:36];
}

- (void)dismiss {
//    [self.addCoinAnimationManager stop];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Private
- (void)addPopTask:(NSInteger)coins {
    static NSInteger i = 0;
    i++;
    NSInteger tmp = i;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if(0 == tmp % 2) {
            [self.addCoinAnimationManager removeCoins:coins];
        } else {
            [self.addCoinAnimationManager popCoins:coins];
        }
    });
}

#pragma mark AddCoinAnimationManagerDelegate
- (void)AddCoinPopAnimationDidFinished:(NSInteger)coinNumber {
    NSLog(@"%d", coinNumber);
}

#pragma mark AddCoinAnimationManager
- (AddCoinAnimationManager *)addCoinAnimationManager {
    if(!_addCoinAnimationManager) {
        _addCoinAnimationManager = [[AddCoinAnimationManager alloc] init];
        _addCoinAnimationManager.snapRect = CGRectMake(300, 0, 20, 20);
        _addCoinAnimationManager.displayRect = CGRectMake(250, 300, 100, 100);
//        _addCoinAnimationManager.maxDisplayAmount = 4;
        _addCoinAnimationManager.delegate = self;
        _addCoinAnimationManager.associatedView = self.view;
    }
    return _addCoinAnimationManager;
}

@end
