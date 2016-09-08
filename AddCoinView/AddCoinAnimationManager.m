//
//  AddCoinAnimationManager.m
//  AddCoinView
//
//  AddCoinView
//  Created by wyan assert on 9/8/16.
//  Copyright © 2016 wyan assert. All rights reserved.
//

#import "AddCoinAnimationManager.h"
#import "AddCoinAnimationView.h"
#import "AppDelegate.h"

@interface AddCoinAnimationManager () <AddCoinAnimationViewDelegate>

@property (strong, nonatomic) AddCoinAnimationView  *addCoinAnimationView;

@end

@implementation AddCoinAnimationManager

- (void)addCoins:(NSInteger)coinNumber {
    if (coinNumber <= 0 ) {
        return;
    }
    
    NSInteger actuallyBornCoin = coinNumber;
    NSLog(@"coin number:%@, ActuallyBornCoin:%@",@(coinNumber),@(actuallyBornCoin));
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.addCoinAnimationView willAddCoins:actuallyBornCoin];
        
        UIWindow *window = ((AppDelegate *)[UIApplication sharedApplication].delegate).window;
        if (!self.addCoinAnimationView.superview) {
            
            NSLog(@"coin_falling_view_no_superview");
            [window addSubview:self.addCoinAnimationView];
        }
        
        [self.addCoinAnimationView addCoins:actuallyBornCoin];
        
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
        
        [self.addCoinAnimationView willConfirmCoinAdded:actuallyBornCoin];
        
        [self.addCoinAnimationView confirmCoinAdded:actuallyBornCoin];
        
        NSLog(@"CoinsFallingManager_add_coins:%@",@(actuallyBornCoin));
        
    });
}


#pragma mark - CoinsFallingViewDelegate

- (void)fallingAnimationFinished{
    
    //    [self.coinsFallingView removeFromSuperview];
    NSLog(@"CoinsFallingManager_remove_falling_view");
    
}

#pragma mark - Getter

- (AddCoinAnimationView *)addCoinAnimationView {
    if (!_addCoinAnimationView) {
        UIWindow *window = ((AppDelegate *)[UIApplication sharedApplication].delegate).window;
        _addCoinAnimationView = [[AddCoinAnimationView alloc] initWithFrame:window.bounds];
        _addCoinAnimationView.delegate = self;
    }
    return _addCoinAnimationView;
}

@end
