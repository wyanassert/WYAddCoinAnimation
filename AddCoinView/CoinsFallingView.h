//
//  CoinsFallingView.h
//  UIDynamicsDemo
//
//  Created by Amay on 5/22/16.
//  Copyright © 2016 Beddup. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CoinsFallingViewDelegate <NSObject>

- (void)fallingAnimationFinished;

@end

@interface CoinsFallingView : UIView

@property (nonatomic) BOOL shouldShowCoinsNumberLabel;
@property (nonatomic) BOOL shouldShowCoinsPile;

@property (nonatomic, weak) id<CoinsFallingViewDelegate> delegate;

- (void)willAddCoins:(NSInteger)coinsNumbers;
- (void)addCoins:(NSInteger)coinsNumber;
- (void)confirmCoinAdded:(NSInteger)coinNumber;

@end
