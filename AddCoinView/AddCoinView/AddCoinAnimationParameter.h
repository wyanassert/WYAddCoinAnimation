//
//  AddCoinAnimationParameter.h
//
//  Created by Mac on 16/5/23.
//  Copyright © 2016年 wyan assert. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, CoinBirthAreaType) {
    CoinBirthAreaSmall,     //100x100
    CoinBirthAreaMedium,    //120x120
    CoinBirthAreaLarge      //150x150
};

@interface AddCoinAnimationParameter : NSObject

+ (instancetype)sharedInstance;

#pragma mark - Coin Birth
+ (float)coinBirthDuration:(NSInteger)coinNumber;
+ (CGSize)randomCoinSize;

#pragma mark - UIDynamics
+ (float)coinElasticity;
+ (CGFloat)coinBouncePosition; // between 0 - 1.0
+ (float)randomCoinBirthAngle;
+ (float)randomCoinBirthmagnitude;
+ (float)randomStopYPositionTop:(CGFloat)top andBottom:(CGFloat)bottom;
+ (float)randomCycleTime;
+ (float)randomCycleRotation;
+ (float)gravityMagnitude;
+ (float)getBirthDuration;

#pragma mark - Images
+ (NSArray *)getAnimateImageArray;

#pragma mark - Other
+ (CGPoint)randomPointInRect:(CGRect)rect;

#pragma mark - DisplayAmount
+ (NSInteger)getMaxDisplayAmount;

@end
