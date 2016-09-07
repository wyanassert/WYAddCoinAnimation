//
//  CoinFallingParameter.m
//  SnapUpload
//
//  Created by Mac on 16/5/23.
//  Copyright © 2016年 JellyKit Inc. All rights reserved.
//

#import "CoinFallingParameter.h"
@interface CoinFallingParameter()

@property (nonatomic, strong)   NSArray  *allFallingImages;
@property (nonatomic, strong)   NSArray  *smallPileCGImages;
@property (nonatomic, strong)   NSArray  *mediumPileCGImages;
@property (nonatomic, strong)   NSArray  *bigPileCGImages;

@end

@implementation CoinFallingParameter

static CGFloat pileRatio = 750.0 / 170;

float coinFallingRandom(float min, float length){
    return arc4random() % 100 * 1.0 / 100.0 * length + min;
}

+ (instancetype)sharedInstance{
    
    static CoinFallingParameter *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[CoinFallingParameter alloc] init];
    });
    
    return instance;
}

#pragma mark - Coin Birth
+ (float)coinBirthDuration:(NSInteger)coinNumber{
    
    if (coinNumber * 1.0 / 100 < 1.5) {
        return 1.5;
    }else{
        NSTimeInterval time = 1.5 + (coinNumber - 200) * 1.0 / 150;
        if (time > 3.0) {
            return 3.0;
        }
        return time;
    }
    
}
+ (CGSize)randomCoinSize{
    
    float width = coinFallingRandom([self minCoinWidth], [self maxCoinWidth] - [self minCoinWidth]);
    return CGSizeMake(width, width);
}

+ (CGRect)coinBirthArea{
    return CGRectMake(100, 200, 100, 100);
}

#pragma mark - UIDynamics
+ (float)coinElasticity{
    return 0.3;
}
+ (float)gravityMagnitude{
    return 1.5;
}

+ (float)randomAngularVelocity{
    return coinFallingRandom( -M_PI_4, M_PI_2);
}

+ (float)randomCoinBirthAngle{
    return coinFallingRandom(- M_PI * 2.0 / 3, M_PI / 3);
}

+ (float)randomCoinBirthmagnitude{
    return coinFallingRandom(0.1, 0.1);
}

+ (float)randomStopYPositionTop:(CGFloat)top andBottom:(CGFloat)bottom{
    return coinFallingRandom(top, bottom - top);
}

+ (CGFloat)coinBouncePosition{
    return 3.0 / 4;
}

#pragma mark - Images

+ (UIImage *)randomCoinFallingImage{
    NSArray *allImages = [CoinFallingParameter sharedInstance].allFallingImages;
    NSInteger imageIndex = (NSInteger)(coinFallingRandom(0, allImages.count - 1) + 0.5);
    return allImages[imageIndex];
    
}
+ (NSArray *)coinPilesCGImages:(NSInteger)coinNumber{
    
    if (coinNumber <= 10) {
        return [CoinFallingParameter sharedInstance].smallPileCGImages;
        
    }else if (coinNumber < 100){
        return  [CoinFallingParameter sharedInstance].mediumPileCGImages;
        
    }else{
        
        return [CoinFallingParameter sharedInstance].bigPileCGImages;
    }
}

+ (NSArray *)getAnimateImageArray{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:5];
    for(int i = 1; i <=5; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"coin_%01d", i]];
        [array addObject:image];
    }
    return [array copy];
}

#pragma mark - Others
+ (NSArray *)coinPileKeyTimes:(NSInteger)coinNumber{
    
    if (coinNumber <= 10) {
        
        return @[@(1.0 / 6),
                 @(3.0 / 6),
                 @(5.0 / 6)];
        
    }else if (coinNumber <= 100){
        
        return @[@(1.0 / 6),
                 @(3.0 / 6),
                 @(5.0 / 6)];
        
    }else{
        
        return @[@(0.1),
                 @(0.3),
                 @(0.5),
                 @(0.7),
                 @(0.9)];
        
    }
    
}
+ (CGPoint)randomPointInRect:(CGRect)rect{
    return  CGPointMake(coinFallingRandom(CGRectGetMinX(rect), CGRectGetWidth(rect)), coinFallingRandom(CGRectGetMinY(rect), CGRectGetHeight(rect)));
}
+ (BOOL)shouldPlaySound{
    return YES;
}
+ (CGSize)coinPileSize{
    CGFloat width = [self coinPileWidth];
    return CGSizeMake(width, width / pileRatio);
}

#pragma mark - Private
+ (CGFloat)minCoinWidth{
    return 24.0;
}
+ (CGFloat)maxCoinWidth{
    return 36.0;
}

+ (float)coinPileWidth{
    return 375 > [UIScreen mainScreen].bounds.size.width ? [UIScreen mainScreen].bounds.size.width : 375 ;
}


#pragma mark - Getter

- (NSArray *)allFallingImages{
    if (!_allFallingImages) {
        _allFallingImages = @[[UIImage imageNamed:@"coin_1"],
                              [UIImage imageNamed:@"coin_2"],
                              [UIImage imageNamed:@"coin_3"],
                              [UIImage imageNamed:@"coin_4"],
                              [UIImage imageNamed:@"coin_5"]];
    }
    return _allFallingImages;
}

- (NSArray *)smallPileCGImages{
    if (!_smallPileCGImages) {
        _smallPileCGImages = @[(id)[UIImage imageNamed:@"coins_level1_1"].CGImage,
                               (id)[UIImage imageNamed:@"coins_level1_2"].CGImage,
                               (id)[UIImage imageNamed:@"coins_level1_3"].CGImage];

    }
    return _smallPileCGImages;
}

- (NSArray *)mediumPileCGImages{
    if (!_mediumPileCGImages) {
        _mediumPileCGImages = @[(id)[UIImage imageNamed:@"coins_level2_1"].CGImage,
                                (id)[UIImage imageNamed:@"coins_level2_2"].CGImage,
                                (id)[UIImage imageNamed:@"coins_level2_3"].CGImage];
    }
    return _mediumPileCGImages;
}

- (NSArray *)bigPileCGImages{
    if (!_bigPileCGImages) {
        _bigPileCGImages =  @[(id)[UIImage imageNamed:@"coins_level3_1"].CGImage,
                              (id)[UIImage imageNamed:@"coins_level3_2"].CGImage,
                              (id)[UIImage imageNamed:@"coins_level3_3"].CGImage,
                              (id)[UIImage imageNamed:@"coins_level3_4"].CGImage,
                              (id)[UIImage imageNamed:@"coins_level3_5"].CGImage];

    }
    return _bigPileCGImages;
}
@end


