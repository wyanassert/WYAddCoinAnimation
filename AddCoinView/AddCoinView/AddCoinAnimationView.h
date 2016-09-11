//
//  AddCoinAnimationView.h
//  AddCoinView
//
//  Created by wyan assert on 9/8/16.
//  Copyright © 2016 wyan assert. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddCoinAnimationViewDelegate <NSObject>

- (void)allTheAnimationDinished;

@optional

- (void)popCoinAnimationFinished;
- (void)birthCoinAnimationFinished;

@end

@interface AddCoinAnimationView : UIView

@property (nonatomic, assign) CGRect                            snapRect;
@property (nonatomic, assign) CGRect                            displayRect;

@property (nonatomic, weak  ) id<AddCoinAnimationViewDelegate>  delegate;

- (void)willAddCoins:(NSInteger)coinsNumbers;
- (void)addCoins:(NSInteger)coinsNumber;

- (void)willConfirmCoinAdded:(NSInteger)coinNumber;
- (void)confirmCoinAdded:(NSInteger)coinNumber;

- (void)willRemoveCoins:(NSInteger)coinNumber;
- (void)removeCoins:(NSInteger)coinNumber;

- (void)stop;

- (NSUInteger)numberOfCoinItems;

@end
