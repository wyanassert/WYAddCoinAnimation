//
//  CoinFallingParameter.h
//  SnapUpload
//
//  Created by Mac on 16/5/23.
//  Copyright © 2016年 JellyKit Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface CoinFallingParameter : NSObject

#pragma mark - Coin Birth
+ (float)coinBirthDuration:(NSInteger)coinNumber;
+ (CGSize)randomCoinSize;
+ (CGRect)coinBirthArea; // in ((0,0),(1.0,1.0))

#pragma mark - UIDynamics
+ (float)coinElasticity;
+ (float)gravityMagnitude;
+ (CGFloat)coinBouncePosition; // between 0 - 1.0
+ (float)randomAngularVelocity;
+ (float)randomCoinBirthAngle;
+ (float)randomCoinBirthmagnitude;
+ (float)randomStopYPositionTop:(CGFloat)top andBottom:(CGFloat)bottom;

#pragma mark - Images
+ (UIImage *)randomCoinFallingImage;
+ (NSArray *)coinPilesCGImages:(NSInteger)coinNumber;
+ (NSArray *)getAnimateImageArray;

#pragma mark - Other
+ (NSArray *)coinPileKeyTimes:(NSInteger)coinNumber;
+ (CGPoint)randomPointInRect:(CGRect)rect;
+ (BOOL)shouldPlaySound;
+ (CGSize)coinPileSize;

@end
