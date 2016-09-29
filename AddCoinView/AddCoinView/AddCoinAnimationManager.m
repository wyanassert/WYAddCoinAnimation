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

static NSUInteger maxOnceRemoveAmount = 20;

@interface AddCoinAnimationManager () <AddCoinAnimationViewDelegate> {
    NSUInteger calAddNum;
    NSUInteger calHandleNum;
}

@property (nonatomic, strong) AddCoinAnimationView  *addCoinAnimationView;
@property (nonatomic, assign) NSUInteger             needToPlayCount;
@property (nonatomic, assign) NSUInteger             needToPopCount;
@property (nonatomic, assign) NSUInteger             needToRemoveCount;

@property (nonatomic, assign) NSInteger              actuallyAddNum;
@property (nonatomic, assign) NSInteger              actuallyPopNum;

@end

@implementation AddCoinAnimationManager

- (instancetype)init {
    if(self = [super init]) {
        self.needToPlayCount = 0;
        self.needToPopCount = 0;
        self.needToRemoveCount = 0;
        self.actuallyAddNum = 0;
        self.actuallyPopNum = 0;
    }
    return self;
}

- (void)dealloc {
    [self stop];
}


#pragma mark public
- (void)addCoins:(NSInteger)coinNumber {
    calAddNum += coinNumber;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSInteger number = coinNumber;
        NSUInteger existsCoinAmount = [self.addCoinAnimationView numberOfCoinItems];
        NSInteger maxDisplayAmount = self.maxDisplayAmount ? self.maxDisplayAmount : [AddCoinAnimationParameter getMaxDisplayAmount];
        NSUInteger maxAddAmount = maxDisplayAmount - existsCoinAmount;
        if(maxAddAmount <= 0 || self.actuallyAddNum >= maxDisplayAmount) {
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
    });
}

- (void)popCoins:(NSInteger)coinNumber {
    if(calHandleNum + coinNumber > calAddNum) {
        coinNumber = calAddNum - calHandleNum;
    }
    calHandleNum += coinNumber;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSInteger number = coinNumber;
        NSUInteger existsCoinAmount = [self.addCoinAnimationView numberOfCoinItems];
        if(number > existsCoinAmount) {
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
    });
}

- (void)removeCoins:(NSInteger)coinNumber {
    if(calHandleNum + coinNumber > calAddNum) {
        coinNumber = calAddNum - calHandleNum;
    }
    calHandleNum += coinNumber;
    dispatch_async(dispatch_get_main_queue(), ^{
        NSInteger actuallyCoinNumber = coinNumber;
        if(self.needToPlayCount >= coinNumber + self.needToRemoveCount) {
            self.needToPlayCount -= (coinNumber + self.needToRemoveCount);
            return ;
        } else {
            actuallyCoinNumber += self.needToRemoveCount;
            self.needToRemoveCount = 0;
            actuallyCoinNumber -= self.needToPlayCount;
            self.needToPlayCount = 0;
            NSInteger existCoinNumber = [self.addCoinAnimationView numberOfCoinItems];
            if(existCoinNumber < actuallyCoinNumber) {
                self.needToRemoveCount += actuallyCoinNumber - existCoinNumber;
                [self actuallyRemoveCoins:existCoinNumber];
            } else {
                [self actuallyRemoveCoins:actuallyCoinNumber];
            }
            if(self.needToPlayCount > 0) {
                [self addCoins:0];
            } else if(self.needToPopCount > 0) {
                [self popCoins:0];
            }
        }
    });
}

- (void)setCoinsHide:(BOOL)hide {
    [self.addCoinAnimationView setCoinsHide:hide];
}

- (void)stop {
    [self.addCoinAnimationView stop];
    [self.addCoinAnimationView removeFromSuperview];
}

#pragma mark private
- (void)actuallyAddCoins:(NSInteger)coinNumber {
    
//    NSLog(@"Did Reach Actually Add, %lu", coinNumber);
    if (coinNumber <= 0 ) {
        return;
    }
    self.actuallyAddNum += coinNumber;
    NSInteger actuallyBornCoin = coinNumber;
//    NSLog(@"coin number:%@, ActuallyBornCoin:%@",@(coinNumber),@(actuallyBornCoin));
    
    [self.addCoinAnimationView willAddCoins:actuallyBornCoin];
    
    
    if (!self.addCoinAnimationView.superview) {
//        NSLog(@"coin_falling_view_no_superview");
        [self.associatedView addSubview:self.addCoinAnimationView];
    }
    
    [self.addCoinAnimationView addCoins:actuallyBornCoin];
    
//    NSLog(@"CoinsFallingManager_add_coins:%@",@(actuallyBornCoin));
}

- (void)actuallyPopCoins:(NSInteger)coinNumber {
    if (coinNumber <= 0 ) {
        return;
    }
//    NSLog(@"actually pop coin : %lu", coinNumber);
    self.actuallyAddNum -= coinNumber;
    if(self.actuallyPopNum) {
        self.actuallyPopNum += coinNumber;
    } else {
        self.actuallyPopNum = coinNumber;
    }
    NSInteger actuallyBornCoin = coinNumber;
//    NSLog(@"coin number:%@, ActuallyBornCoin:%@",@(coinNumber),@(actuallyBornCoin));
    
    [self.addCoinAnimationView willConfirmCoinAdded:actuallyBornCoin];
    
    [self.addCoinAnimationView confirmCoinAdded:actuallyBornCoin];
    
//    NSLog(@"CoinsFallingManager_add_coins:%@",@(actuallyBornCoin));

}

- (void)actuallyRemoveCoins:(NSInteger)coinNumber {
    if(coinNumber <= 0) {
        return ;
    }
    
    if(coinNumber > maxOnceRemoveAmount) {
        self.needToRemoveCount += coinNumber - maxOnceRemoveAmount;
        coinNumber = maxOnceRemoveAmount;
    }
    
    self.actuallyAddNum -= coinNumber;
//    NSLog(@"actually remove coin : %lu", coinNumber);
    [self.addCoinAnimationView willRemoveCoins:coinNumber];
    
    [self.addCoinAnimationView removeCoins:coinNumber];
}

#pragma mark - CoinsFallingViewDelegate
- (void)popCoinAnimationFinished {
//    NSLog(@"did Reach Pop Delegate, %lu to pop", (unsigned long)self.needToPopCount);
    if(self.needToPlayCount > 0) {
        [self addCoins:0];
    }
    if(self.needToPopCount > 0) {
        //when coin is to much to produce, may pop while coin is not ready to produe, so wait for a while
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self popCoins:0];
        });
    }
    if(self.delegate && [self.delegate respondsToSelector:@selector(AddCoinPopAnimationDidFinished:)]) {
        [self.delegate AddCoinPopAnimationDidFinished:self.actuallyPopNum];
    }
    
    self.actuallyPopNum = 0;
}

- (void)birthCoinAnimationFinished {
    if(self.needToPlayCount > 0) {
        [self addCoins:0];
    }
    if(self.needToPopCount > 0) {
        [self popCoins:0];
    }
    if(self.needToRemoveCount > 0) {
        [self removeCoins:0];
    }
}

- (void)removeActionFinished {
    
    if(self.needToRemoveCount > 0) {
        [self removeCoins:0];
    }
}

- (void)allTheAnimationDinished {
    [self.addCoinAnimationView removeFromSuperview];
}


#pragma mark - Getter
- (AddCoinAnimationView *)addCoinAnimationView {
    if (!_addCoinAnimationView) {
        _addCoinAnimationView = [[AddCoinAnimationView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _addCoinAnimationView.delegate = self;
    }
    return _addCoinAnimationView;
}

- (UIView *)associatedView {
    if(_associatedView) {
        return _associatedView;
    } else {
        return((AppDelegate *)[UIApplication sharedApplication].delegate).window;
    }
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
