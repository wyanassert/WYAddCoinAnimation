//
//  AddCoinAnimationManager.m
//  AddCoinView
//
//  Created by wyan assert on 9/8/16.
//  Copyright © 2016 wyan assert. All rights reserved.
//

#import "AddCoinAnimationManager.h"
#import "CoinsFallingView.h"
#import "AppDelegate.h"
#import "CoinFallingParameter.h"

@interface AddCoinAnimationManager () <CoinsFallingViewDelegate>

@property (strong, nonatomic) CoinsFallingView          *coinsFallingView;

@end

@implementation AddCoinAnimationManager

- (void)addCoins:(NSInteger)coinNumber {
    if (coinNumber <= 0 ) {
        return;
    }
    
    NSInteger actuallyBornCoin = coinNumber;
    NSLog(@"coin number:%@, ActuallyBornCoin:%@",@(coinNumber),@(actuallyBornCoin));
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.coinsFallingView willAddCoins:actuallyBornCoin];
        
        UIWindow *window = ((AppDelegate *)[UIApplication sharedApplication].delegate).window;
        if (!self.coinsFallingView.superview) {
            
            NSLog(@"coin_falling_view_no_superview");
            [window addSubview:self.coinsFallingView];
        }
        
        [self.coinsFallingView addCoins:actuallyBornCoin];
        
        NSLog(@"CoinsFallingManager_add_coins:%@",@(actuallyBornCoin));
        
    });
}

- (void)popCoins:(NSInteger)coinNumber {
    if (coinNumber <= 0 ) {
        return;
    }
    
    NSInteger actuallyBornCoin = coinNumber;
    NSLog(@"coin number:%@, ActuallyBornCoin:%@",@(coinNumber),@(actuallyBornCoin));
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.coinsFallingView willConfirmCoinAdded:actuallyBornCoin];
        
        [self.coinsFallingView confirmCoinAdded:actuallyBornCoin];
        
        NSLog(@"CoinsFallingManager_add_coins:%@",@(actuallyBornCoin));
        
    });
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
