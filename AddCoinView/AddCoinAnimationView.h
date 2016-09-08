//
//  AddCoinAnimationView.h
//  AddCoinView
//
//  Created by wyan assert on 9/8/16.
//  Copyright © 2016 wyan assert. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddCoinAnimationViewDelegate <NSObject>

- (void)fallingAnimationFinished;

@end

@interface AddCoinAnimationView : UIView

@property (nonatomic, weak) id<AddCoinAnimationViewDelegate> delegate;

- (void)willAddCoins:(NSInteger)coinsNumbers;
- (void)addCoins:(NSInteger)coinsNumber;
- (void)willConfirmCoinAdded:(NSInteger)coinNumber;
- (void)confirmCoinAdded:(NSInteger)coinNumber;

@end
