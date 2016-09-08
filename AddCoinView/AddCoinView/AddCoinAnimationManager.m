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

- (void)dealloc {
    [self.addCoinAnimationView stop];
    [self.addCoinAnimationView removeFromSuperview];
}

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
- (void)popCoinAnimationFinished {
    if(self.delegate && [self.delegate respondsToSelector:@selector(AddCoinPopAnimationDidFinished)]) {
        [self.delegate AddCoinPopAnimationDidFinished];
    }
}

- (void)allTheAnimationDinished {
    [self.addCoinAnimationView removeFromSuperview];
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(AddCoinAllAnimationDidFinished)]) {
        [self.delegate AddCoinAllAnimationDidFinished];
    }
}


#pragma mark - Getter
- (AddCoinAnimationView *)addCoinAnimationView {
    if (!_addCoinAnimationView) {
        _addCoinAnimationView = [[AddCoinAnimationView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _addCoinAnimationView.delegate = self;
    }
    return _addCoinAnimationView;
}

#pragma mark - Setter
- (void)setSnapRect:(CGRect)rect {
    _snapRect = rect;
    self.addCoinAnimationView.snapRect = rect;
}

- (void)setDisplayRect:(CGRect)rect {
    _displayRect = rect;
    self.addCoinAnimationView.displayRect = rect;
}

@end
