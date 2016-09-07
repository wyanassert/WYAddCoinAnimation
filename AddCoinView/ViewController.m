//
//  ViewController.m
//  AddCoinView
//
//  Created by wyan assert on 9/6/16.
//  Copyright © 2016 wyan assert. All rights reserved.
//

#import "ViewController.h"
#import "CoinsFallingView.h"
#import "AppDelegate.h"
#import "CoinFallingParameter.h"

#define Actual_Born_Coin_Number_Level1  100
#define Actual_Born_Coin_Number_Level2  200
#define Actual_Born_Coin_Number_Level3  400

@interface ViewController () <CoinsFallingViewDelegate>

@property (strong, nonatomic) CoinsFallingView          *coinsFallingView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 400, 100, 50)];
    [button setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:button];
    [button setTitle:@"1" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 500, 100, 50)];
    [button1 setBackgroundColor:[UIColor greenColor]];
    [self.view addSubview:button1];
    [button1 setTitle:@"1" forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(buttonAction1:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(135, 400, 100, 50)];
    [button2 setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:button2];
    [button2 setTitle:@"4" forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(buttonAction2:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button3 = [[UIButton alloc] initWithFrame:CGRectMake(135, 500, 100, 50)];
    [button3 setBackgroundColor:[UIColor greenColor]];
    [self.view addSubview:button3];
    [button3 setTitle:@"4" forState:UIControlStateNormal];
    [button3 addTarget:self action:@selector(buttonAction3:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button4 = [[UIButton alloc] initWithFrame:CGRectMake(270, 400, 100, 50)];
    [button4 setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:button4];
    [button4 setTitle:@"100" forState:UIControlStateNormal];
    [button4 addTarget:self action:@selector(buttonAction4:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button5 = [[UIButton alloc] initWithFrame:CGRectMake(270, 500, 100, 50)];
    [button5 setBackgroundColor:[UIColor greenColor]];
    [self.view addSubview:button5];
    [button5 setTitle:@"100" forState:UIControlStateNormal];
    [button5 addTarget:self action:@selector(buttonAction5:) forControlEvents:UIControlEventTouchUpInside];
    
//    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(200, 200, 100, 100)];
//    image.animationImages = [CoinFallingParameter getAnimateImageArray];
//    image.animationRepeatCount = 0;
//    image.animationDuration = 1.0f;
//    [image startAnimating];
//    
//    [self.view addSubview:image];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private

- (void)buttonAction:(UIButton *)button {
    [self addCoins:1 showCoinsNumber:NO showCoinsPile:NO];
}

- (void)buttonAction1:(UIButton *)button {
    [self.coinsFallingView confirmCoinAdded:1];
}

- (void)buttonAction2:(UIButton *)button {
    [self addCoins:4 showCoinsNumber:NO showCoinsPile:NO];
}

- (void)buttonAction3:(UIButton *)button {
    [self.coinsFallingView confirmCoinAdded:4];
}

- (void)buttonAction4:(UIButton *)button {
    [self addCoins:100 showCoinsNumber:NO showCoinsPile:NO];
}

- (void)buttonAction5:(UIButton *)button {
    [self.coinsFallingView confirmCoinAdded:100];
}


- (void)addCoins:(NSInteger)coinNumber showCoinsNumber:(BOOL)showCoinsNumber showCoinsPile:(BOOL)showCoinsPile{
    if (coinNumber <= 0 ) {
        return;
    }
    
    NSInteger actuallyBornCoin = [self actuallyBornCoins:coinNumber];
    NSLog(@"coin number:%@, ActuallyBornCoin:%@",@(coinNumber),@(actuallyBornCoin));
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.coinsFallingView willAddCoins:actuallyBornCoin];
        
        UIWindow *window = ((AppDelegate *)[UIApplication sharedApplication].delegate).window;
        if (!self.coinsFallingView.superview) {
            // not in current window hierachy
            NSLog(@"coin_falling_view_no_superview");
            [window addSubview:self.coinsFallingView];
        }
        
//        self.coinsFallingView.shouldShowCoinsNumberLabel = showCoinsNumber;
//        self.coinsFallingView.shouldShowCoinsPile = showCoinsPile;
        [self.coinsFallingView addCoins:actuallyBornCoin];
        
        NSLog(@"CoinsFallingManager_add_coins:%@",@(actuallyBornCoin));
        
    });
}

- (NSInteger)actuallyBornCoins:(NSInteger)coinNumber{
    
    NSInteger coinNumberLevel1 = 100;
    NSInteger coinNumberLevel2 = 200;
    NSInteger coinNumberLevel3 = 400;
    
    NSInteger actualBornCoins;
    if (coinNumber <= coinNumberLevel1) {
        
        actualBornCoins = coinNumber >= Actual_Born_Coin_Number_Level1 ? Actual_Born_Coin_Number_Level1 :coinNumber;
        
    }else if(coinNumber > coinNumberLevel1 && coinNumber <= coinNumberLevel2){
        
        actualBornCoins = Actual_Born_Coin_Number_Level1 + (coinNumber - coinNumberLevel1) * (Actual_Born_Coin_Number_Level2 - Actual_Born_Coin_Number_Level1) * 1.0 / (coinNumberLevel2 - coinNumberLevel1);
        
    }else if (coinNumber > coinNumberLevel2 && coinNumber <= coinNumberLevel3){
        
        actualBornCoins = Actual_Born_Coin_Number_Level2 + (coinNumber -coinNumberLevel2) * (Actual_Born_Coin_Number_Level3 - Actual_Born_Coin_Number_Level2) * 1.0 / (coinNumberLevel3 - coinNumberLevel2);
        
    }else{
        
        actualBornCoins = Actual_Born_Coin_Number_Level3;
        
    }
    
    return actualBornCoins;
}

#pragma mark - CoinsFallingViewDelegate

- (void)fallingAnimationFinished{
    
//    [self.coinsFallingView removeFromSuperview];
    NSLog(@"CoinsFallingManager_remove_falling_view");
    
}

#pragma mark - Getter

- (CoinsFallingView *)coinsFallingView{
    if (!_coinsFallingView) {
        UIWindow *window = ((AppDelegate *)[UIApplication sharedApplication].delegate).window;
        _coinsFallingView = [[CoinsFallingView alloc] initWithFrame:window.bounds];
        _coinsFallingView.delegate = self;
    }
    return _coinsFallingView;
}

@end
