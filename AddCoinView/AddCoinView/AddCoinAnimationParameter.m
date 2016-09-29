//
//  AddCoinAnimationParameter.m
//  AddCoinView
//
//  Created by Mac on 16/5/23.
//  Copyright © 2016年 wyan assert. All rights reserved.
//

#import "AddCoinAnimationParameter.h"

@interface AddCoinAnimationParameter ()

@property (nonatomic, assign) CoinBirthAreaType type;

@end

@implementation AddCoinAnimationParameter

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static AddCoinAnimationParameter *instance;
    dispatch_once(&onceToken, ^{
        instance = [[AddCoinAnimationParameter alloc] init];
        if([UIScreen mainScreen].bounds.size.width > 375) {
            instance.type = CoinBirthAreaLarge;
        } else if([UIScreen mainScreen].bounds.size.width > 320)  {
            instance.type = CoinBirthAreaMedium;
        } else {
            instance.type = CoinBirthAreaSmall;
        }
    });
    return instance;
}

float coinFallingRandom(float min, float length) {
    return arc4random() % 100 * 1.0 / 100.0 * length + min;
}

#pragma mark - Coin Birth
+ (float)coinBirthDuration:(NSInteger)coinNumber {
    if (coinNumber * 1.0 / 100 < 1.5) {
        return 1.5;
    } else {
        NSTimeInterval time = 1.5 + (coinNumber - 150) * 1.0 / 150;
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
    switch ([AddCoinAnimationParameter sharedInstance].type) {
        case CoinBirthAreaSmall: {
            return coinFallingRandom(-2.0 * M_PI / 3, M_PI / 3.0);
            break;
        }
        case CoinBirthAreaMedium: {
            return coinFallingRandom(-2.0 * M_PI / 3, M_PI / 3.0);
            break;
        }
        case CoinBirthAreaLarge: {
            return coinFallingRandom(-3.0 * M_PI / 4, M_PI_2);
            break;
        }
    }
}

+ (float)randomCoinBirthmagnitude {
    switch ([AddCoinAnimationParameter sharedInstance].type) {
        case CoinBirthAreaSmall: {
            return coinFallingRandom(0.06, 0.04);
            break;
        }
        case CoinBirthAreaMedium: {
            return coinFallingRandom(0.07, 0.05);
            break;
        }
        case CoinBirthAreaLarge: {
            return coinFallingRandom(0.12, 0.08);
            break;
        }
    }
}

+ (float)randomStopYPositionTop:(CGFloat)top andBottom:(CGFloat)bottom {
    return coinFallingRandom(top, bottom - top);
}

+ (CGFloat)coinBouncePosition {
    return 3.0 / 4;
}

+ (float)randomCycleTime {
    return coinFallingRandom(0.3, 0.3);
}

+ (float)gravityMagnitude {
    switch ([AddCoinAnimationParameter sharedInstance].type) {
        case CoinBirthAreaSmall: {
            return 0.40;
            break;
        }
        case CoinBirthAreaMedium: {
            return 0.50;
            break;
        }
        case CoinBirthAreaLarge: {
            return 0.52;
            break;
        }
    }
}

+ (float)randomCycleRotation {
    return 0;
}

+ (float)getBirthDuration {
    return coinFallingRandom(0.2, 0.2);
}


#pragma mark - Images
+ (NSArray *)getAnimateImageArray {
    CGFloat tmp = coinFallingRandom(0, 3);
    NSInteger num = 0;
    if(tmp < 1) {
        num = 0;
    } else if (tmp < 2) {
        num = 1;
    } else {
        num = 2;
    }
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:5];
    for(int i = 0; i < 5; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"coin_%01d_%01d", num, i]];
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
    if([UIScreen mainScreen].bounds.size.width > 375) {
        return 42.0;
    }
    else {
        return 28.0;
    }
}
+ (CGFloat)maxCoinWidth {
    if([UIScreen mainScreen].bounds.size.width > 375) {
        return 48.0;
    }
    else {
        return 36.0;
    }
}

+ (float)coinPileWidth {
    return 375 > [UIScreen mainScreen].bounds.size.width ? [UIScreen mainScreen].bounds.size.width : 375 ;
}

@end


