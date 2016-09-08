//
//  AddCoinAnimationParameter.m
//  AddCoinView
//
//  Created by Mac on 16/5/23.
//  Copyright © 2016年 wyan assert. All rights reserved.
//

#import "AddCoinAnimationParameter.h"

@implementation AddCoinAnimationParameter

float coinFallingRandom(float min, float length) {
    return arc4random() % 100 * 1.0 / 100.0 * length + min;
}

#pragma mark - Coin Birth
+ (float)coinBirthDuration:(NSInteger)coinNumber {
    
    if (coinNumber * 1.0 / 100 < 1.5) {
        return 1.5;
    } else {
        NSTimeInterval time = 1.5 + (coinNumber - 200) * 1.0 / 150;
        if (time > 3.0) {
            return 3.0;
        }
        return time;
    }
}

+ (CGSize)randomCoinSize {
    float width = coinFallingRandom([self minCoinWidth], [self maxCoinWidth] - [self minCoinWidth]);
    return CGSizeMake(width, width);
}


#pragma mark - UIDynamics
+ (float)coinElasticity {
    return 0.3;
}

+ (float)randomCoinBirthAngle {
    return coinFallingRandom(- M_PI * 3.0 / 4, M_PI / 2);
}

+ (float)randomCoinBirthmagnitude {
    return coinFallingRandom(0.2, 0);
}

+ (float)randomStopYPositionTop:(CGFloat)top andBottom:(CGFloat)bottom {
    return coinFallingRandom(top, bottom - top);
}

+ (CGFloat)coinBouncePosition {
    return 3.0 / 4;
}


#pragma mark - Images
+ (NSArray *)getAnimateImageArray {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:5];
    for(int i = 1; i <=5; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"coin_%01d", i]];
        [array addObject:image];
    }
    return [array copy];
}


#pragma mark - Others
+ (CGPoint)randomPointInRect:(CGRect)rect {
    return  CGPointMake(coinFallingRandom(CGRectGetMinX(rect), CGRectGetWidth(rect)), coinFallingRandom(CGRectGetMinY(rect), CGRectGetHeight(rect)));
}


#pragma mark - DisplayAmount
+ (NSInteger)getMaxDisplayAmount {
    return 20;
}

#pragma mark - Private
+ (CGFloat)minCoinWidth {
    return 24.0;
}
+ (CGFloat)maxCoinWidth {
    return 36.0;
}

+ (float)coinPileWidth {
    return 375 > [UIScreen mainScreen].bounds.size.width ? [UIScreen mainScreen].bounds.size.width : 375 ;
}

@end


