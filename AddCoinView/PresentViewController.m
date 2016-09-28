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
@property (nonatomic, strong) NSArray *numberArray;

@end

@implementation PresentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 300, 100, 50)];
    [button setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:button];
    [button setTitle:[NSString stringWithFormat:@"%@", self.numberArray[0]] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 400, 100, 50)];
    [button1 setBackgroundColor:[UIColor greenColor]];
//    [self.view addSubview:button1];
    [button1 setTitle:[NSString stringWithFormat:@"%@", self.numberArray[0]] forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(buttonAction1:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(110, 300, 100, 50)];
    [button2 setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:button2];
    [button2 setTitle:[NSString stringWithFormat:@"%@", self.numberArray[1]] forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(buttonAction2:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button3 = [[UIButton alloc] initWithFrame:CGRectMake(110, 400, 100, 50)];
    [button3 setBackgroundColor:[UIColor greenColor]];
//    [self.view addSubview:button3];
    [button3 setTitle:[NSString stringWithFormat:@"%@", self.numberArray[1]] forState:UIControlStateNormal];
    [button3 addTarget:self action:@selector(buttonAction3:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button4 = [[UIButton alloc] initWithFrame:CGRectMake(220, 300, 100, 50)];
    [button4 setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:button4];
    [button4 setTitle:[NSString stringWithFormat:@"%@", self.numberArray[2]] forState:UIControlStateNormal];
    [button4 addTarget:self action:@selector(buttonAction4:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button5 = [[UIButton alloc] initWithFrame:CGRectMake(220, 400, 100, 50)];
    [button5 setBackgroundColor:[UIColor greenColor]];
//    [self.view addSubview:button5];
    [button5 setTitle:[NSString stringWithFormat:@"%@", self.numberArray[2]] forState:UIControlStateNormal];
    [button5 addTarget:self action:@selector(buttonAction5:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *dismissButton = [[UIButton alloc] initWithFrame:CGRectMake(110, 420, 100, 50)];
    [dismissButton setBackgroundColor:[UIColor blackColor]];
    [dismissButton setTitle:@"dismiss" forState:UIControlStateNormal];
    [self.view addSubview:dismissButton];
    [dismissButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *hideButton = [[UIButton alloc] initWithFrame:CGRectMake(220, 420, 100, 50)];
    [hideButton setBackgroundColor:[UIColor blackColor]];
    [hideButton setTitle:@"hide" forState:UIControlStateNormal];
    [self.view addSubview:hideButton];
    [hideButton addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *tmp = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    tmp.backgroundColor = [UIColor greenColor];
//    [self.view addSubview:tmp];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private

- (void)buttonAction:(UIButton *)button {
    [self.addCoinAnimationManager addCoins:[self.numberArray[0] intValue]];
    [self addPopTask:[self.numberArray[0] intValue]];
}

- (void)buttonAction1:(UIButton *)button {
    [self.addCoinAnimationManager popCoins:[self.numberArray[0] intValue]];
}

- (void)buttonAction2:(UIButton *)button {
    [self.addCoinAnimationManager addCoins:[self.numberArray[1] intValue]];
    [self addPopTask:[self.numberArray[1] intValue]];
}

- (void)buttonAction3:(UIButton *)button {
    [self.addCoinAnimationManager popCoins:[self.numberArray[1] intValue]];
}

- (void)buttonAction4:(UIButton *)button {
    [self.addCoinAnimationManager addCoins:[self.numberArray[2] intValue]];
    [self addPopTask:[self.numberArray[2] intValue]];
}

- (void)buttonAction5:(UIButton *)button {
    [self.addCoinAnimationManager popCoins:[self.numberArray[2] intValue]];
}

- (void)dismiss {
//    [self.addCoinAnimationManager stop];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)hide {
    static BOOL isHide = YES;
    
    [self.addCoinAnimationManager setCoinsHide:isHide];
    isHide = !isHide;
}

#pragma mark Private
- (void)addPopTask:(NSInteger)coins {
    static NSInteger i = 0;
    i++;
    NSInteger tmp = i;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if(tmp%2) {
            [self.addCoinAnimationManager removeCoins:coins];
        } else {
            [self.addCoinAnimationManager popCoins:coins];
        }
    });
}

#pragma mark AddCoinAnimationManagerDelegate
- (void)AddCoinPopAnimationDidFinished:(NSInteger)coinNumber {
//    NSLog(@"%d", coinNumber);
}

#pragma mark AddCoinAnimationManager
- (AddCoinAnimationManager *)addCoinAnimationManager {
    if(!_addCoinAnimationManager) {
        _addCoinAnimationManager = [[AddCoinAnimationManager alloc] init];
        _addCoinAnimationManager.snapRect = CGRectMake(300, 0, 20, 20);
        _addCoinAnimationManager.displayRect = CGRectMake(0, 0, 300, 300);
        _addCoinAnimationManager.maxDisplayAmount = 20;
        _addCoinAnimationManager.delegate = self;
        _addCoinAnimationManager.associatedView = self.view;
    }
    return _addCoinAnimationManager;
}

#pragma mark - Getter 
- (NSArray *)numberArray {
    return @[@4, @20, @80];
}

@end
