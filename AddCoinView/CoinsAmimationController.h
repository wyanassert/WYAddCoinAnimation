//
//  CoinsBirthController.h
//  AddCoinView
//
//  Created by wyan assert on 9/7/16.
//  Copyright © 2016 wyan assert. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CoinsAnimationControllerDelegate;

@interface CoinsAmimationController : NSObject

@property (nonatomic, assign) NSInteger                         totalCoinsNumber;
@property (nonatomic, assign) NSInteger                         notBornCoinsNumer;
@property (nonatomic, assign) NSInteger                         totalBornCoinsNumber;

@property (weak, nonatomic  ) id<CoinsAnimationControllerDelegate>  delegate;

- (instancetype)initWithIdentifier:(NSString *)identifer;

- (void)prepareForCoinsBirth:(NSInteger)coinsNumber;
- (void)makeCoinsBorn:(NSInteger)coinsNumber;
- (void)clear;

@end


@protocol CoinsAnimationControllerDelegate <NSObject>

- (void)coinsDidBorn:(NSInteger)coinsNumber withCnntrollerIdentify:(NSString *)identifer;
- (void)coinBornDidFinishedWithCnntrollerIdentify:(NSString *)identifer;

@end