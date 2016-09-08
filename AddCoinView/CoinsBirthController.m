//
//  CoinsBirthController.m
//  AddCoinView
//
//  Created by wyan assert on 9/7/16.
//  Copyright © 2016 wyan assert. All rights reserved.
//

#import "CoinsBirthController.h"
#import "CoinFallingParameter.h"

@interface CoinsBirthController ()

@property (nonatomic, strong, readonly) NSString        *identifer;
@property (nonatomic, strong          ) CADisplayLink   *displayLink;
@property (nonatomic, assign          ) NSTimeInterval   lastCoinBornAbsoluteTime;
@property (nonatomic, assign          ) NSTimeInterval   coinsBornLeftTime;

@end

@implementation CoinsBirthController

@synthesize identifer = _identifer;

- (instancetype)initWithIdentifier:(NSString *)identifer {
    if(self = [super init]) {
        _identifer = identifer;
    }
    return self;
}

- (void)prepareForCoinsBirth:(NSInteger)coinsNumber {
    
    if (coinsNumber <= 0) {
        return;
    }
    
    self.notBornCoinsNumer = self.notBornCoinsNumer + coinsNumber;
    
    self.totalCoinsNumber = self.totalCoinsNumber + coinsNumber;
    
    self.lastCoinBornAbsoluteTime = CFAbsoluteTimeGetCurrent();
    NSTimeInterval extraBirthDuration = [CoinFallingParameter coinBirthDuration:coinsNumber];
    extraBirthDuration = self.coinsBornLeftTime > 0.0 ? extraBirthDuration * 0.5 : extraBirthDuration;
    self.coinsBornLeftTime = self.coinsBornLeftTime + extraBirthDuration;
    
    if (self.displayLink) {
        if (self.displayLink.paused) {
            NSLog(@"displaylink paused");
        } else {
            NSLog(@"displaylink ok");
        }
    } else {
        NSLog(@"no display link");
    }
    
    if (!self.displayLink || self.displayLink.paused) {
        [self.displayLink invalidate];
        self.displayLink =  [CADisplayLink displayLinkWithTarget:self selector:@selector(update:)];
        self.displayLink.frameInterval = 2;
        NSLog(@"create_display_link");
    }
}

- (void)clear {
    self.notBornCoinsNumer = 0;
    self.coinsBornLeftTime = 0;
    self.totalCoinsNumber = 0;
    self.totalBornCoinsNumber = 0;
}


- (void)makeCoinsBorn:(NSInteger)coinsNumber {
    if (coinsNumber <= 0) {
        return;
    }
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    NSLog(@"display_link_add_to_mainRunLoop");
}

- (void)invalidateDisplayLink {
    [self.displayLink invalidate];
    self.displayLink = nil;
    self.coinsBornLeftTime = 0.0;
    NSLog(@"display_link_invalidate");
}

- (void)update:(CADisplayLink *)displayLink {
    if (self.notBornCoinsNumer <= 0) {
        NSLog(@"notBornCoinsNumer <= 0");
    }else if(self.coinsBornLeftTime <= 0.0) {
        NSLog(@"coinsBornLeftTime <= 0");
    }
    
    if (self.notBornCoinsNumer <= 0 || self.coinsBornLeftTime <= 0.0) {
        [self invalidateDisplayLink];
        [self.delegate coinBornDidFinishedWithCnntrollerIdentify:self.identifer];
    } else {
        NSInteger birthRate = self.notBornCoinsNumer * 1.0  / self.coinsBornLeftTime;
        NSInteger coinsNumber =  birthRate * displayLink.duration + 0.5;
        if (coinsNumber < 1) {
            coinsNumber = 1;
        }
        
        NSTimeInterval timeInterval = CFAbsoluteTimeGetCurrent() - self.lastCoinBornAbsoluteTime;
        self.coinsBornLeftTime = self.coinsBornLeftTime - timeInterval;
        self.lastCoinBornAbsoluteTime = CFAbsoluteTimeGetCurrent();
        
        coinsNumber = coinsNumber > self.notBornCoinsNumer ? self.notBornCoinsNumer : coinsNumber;
        [self.delegate coinsDidBorn:coinsNumber withCnntrollerIdentify:self.identifer];
        NSLog(@"dispalylink make %@ coins born",@(coinsNumber));
        
        self.notBornCoinsNumer = self.notBornCoinsNumer - coinsNumber;
        self.totalBornCoinsNumber = self.totalBornCoinsNumber + coinsNumber;
        
    }
    
}

@end