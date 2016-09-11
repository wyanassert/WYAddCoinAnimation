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
#import "AddCoinAnimationParameter.h"

@interface AddCoinAnimationManager () <AddCoinAnimationViewDelegate>

@property (nonatomic, strong) AddCoinAnimationView  *addCoinAnimationView;
@property (nonatomic, assign) NSUInteger             needToPlayCount;
@property (nonatomic, assign) NSUInteger             needToPopCount;

@end

@implementation AddCoinAnimationManager

- (instancetype)init {
    if(self = [super init]) {
        self.needToPlayCount = 0;
        self.needToPopCount = 0;
    }
    return self;
}

- (void)dealloc {
    [self.addCoinAnimationView stop];
    [self.addCoinAnimationView removeFromSuperview];
}


#pragma mark public
- (void)addCoins:(NSInteger)coinNumber {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSInteger number = coinNumber;
        NSUInteger existsCoinAmount = [self.addCoinAnimationView numberOfCoinItems];
        NSInteger maxDisplayAmount = self.maxDisplayAmount ? self.maxDisplayAmount : [AddCoinAnimationParameter getMaxDisplayAmount];
        NSUInteger maxAddAmount = maxDisplayAmount - existsCoinAmount;
        if(maxAddAmount <= 0) {
            self.needToPlayCount += number;
            return ;
        } else if(maxAddAmount < number) {
            self.needToPlayCount += number - maxAddAmount;
            [self actuallyAddCoins:maxAddAmount];
        } else if(self.needToPlayCount <= maxAddAmount - number) {
            number += self.needToPlayCount;
            self.needToPlayCount = 0;
            [self actuallyAddCoins:number];
        } else {
            self.needToPlayCount -= maxAddAmount - number;
            [self actuallyAddCoins:maxAddAmount];
        }
        NSLog(@"Add:%lu, %lu", (unsigned long)self.needToPlayCount, (unsigned long)self.needToPopCount);
    });
}

- (void)popCoins:(NSInteger)coinNumber {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSInteger number = coinNumber;
        NSUInteger existsCoinAmount = [self.addCoinAnimationView numberOfCoinItems];
        if(number >= existsCoinAmount) {
            self.needToPopCount += number - existsCoinAmount;
            [self actuallyPopCoins:existsCoinAmount];
        } else if(number + self.needToPopCount >= existsCoinAmount) {
            self.needToPopCount -= existsCoinAmount - number;
            [self actuallyPopCoins:existsCoinAmount];
        } else {
            number += self.needToPopCount;
            self.needToPopCount = 0;
            [self actuallyPopCoins:number];
        }
        NSLog(@"Pop:%lu, %lu, %lu", (unsigned long)self.needToPlayCount, (unsigned long)self.needToPopCount, existsCoinAmount);
    });
}

- (void)removeCoins:(NSInteger)coinNumber {
    
}

#pragma mark private
- (void)actuallyAddCoins:(NSInteger)coinNumber {
    
    NSLog(@"Did Reach Actually Add, %lu", coinNumber);
    if (coinNumber <= 0 ) {
        return;
    }
    
    NSInteger actuallyBornCoin = coinNumber;
    NSLog(@"coin number:%@, ActuallyBornCoin:%@",@(coinNumber),@(actuallyBornCoin));
    
    [self.addCoinAnimationView willAddCoins:actuallyBornCoin];
    
    UIWindow *window = ((AppDelegate *)[UIApplication sharedApplication].delegate).window;
    if (!self.addCoinAnimationView.superview) {
        
        NSLog(@"coin_falling_view_no_superview");
        [window addSubview:self.addCoinAnimationView];
    }
    
    [self.addCoinAnimationView addCoins:actuallyBornCoin];
    
    NSLog(@"CoinsFallingManager_add_coins:%@",@(actuallyBornCoin));
}

- (void)actuallyPopCoins:(NSInteger)coinNumber {
    if (coinNumber <= 0 ) {
        return;
    }
    
    NSInteger actuallyBornCoin = coinNumber;
    NSLog(@"coin number:%@, ActuallyBornCoin:%@",@(coinNumber),@(actuallyBornCoin));
    
    [self.addCoinAnimationView willConfirmCoinAdded:actuallyBornCoin];
    
    [self.addCoinAnimationView confirmCoinAdded:actuallyBornCoin];
    
    NSLog(@"CoinsFallingManager_add_coins:%@",@(actuallyBornCoin));

}


#pragma mark - CoinsFallingViewDelegate
- (void)popCoinAnimationFinished {
    if(self.needToPlayCount > 0) {
        [self addCoins:0];
    }
    if(self.delegate && [self.delegate respondsToSelector:@selector(AddCoinPopAnimationDidFinished)]) {
        [self.delegate AddCoinPopAnimationDidFinished];
    }
}

- (void)birthCoinAnimationFinished {
    if(self.needToPopCount) {
        [self popCoins:0];
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

-(void)setMaxDisplayAmount:(NSUInteger)maxDisplayAmount {
    _maxDisplayAmount = maxDisplayAmount;
}

@end
