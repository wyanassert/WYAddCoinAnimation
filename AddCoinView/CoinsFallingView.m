//
//  CoinsFallingView.m
//  UIDynamicsDemo
//
//  Created by Amay on 5/22/16.
//  Copyright © 2016年 JellyKit Inc. All rights reserved.
//


#import "CoinsFallingView.h"
#import "CoinFallingParameter.h"
#import "SCAudioPlayer.h"

#pragma mark CoinFallingItemView
@interface CoinFallingItemView : UIImageView
@property (nonatomic) BOOL hasContacted;
@property (nonatomic, assign) BOOL *hasAttached;
@end

@implementation CoinFallingItemView
@end

#pragma mark CoinBirthControll

@protocol CoinsBirthControllerDelegate <NSObject>

- (void)coinsDidBorn:(NSInteger)coinsNumber;
- (void)coinBornDidFinished;

@end

@interface CoinsBirthController : NSObject

// overall
@property (nonatomic)                   NSInteger                   totalCoinsNumber;
@property (nonatomic)                   NSInteger                   totalBornCoinsNumber;

// display link event flag
@property (nonatomic, strong)           CADisplayLink               *displayLink;
@property (nonatomic)                   NSTimeInterval              lastCoinBornAbsoluteTime;
@property (nonatomic)                   NSTimeInterval              coinsBornLeftTime;
@property (nonatomic)                   NSInteger                   notBornCoinsNumer;

@property (weak, nonatomic)             id<CoinsBirthControllerDelegate>    delegate;

- (void)prepareForCoinsBirth:(NSInteger)coinsNumber;
- (void)makeCoinsBorn:(NSInteger)coinsNumber;
- (void)clear;

@end

#pragma mark CoinsFallingView
@implementation CoinsBirthController

- (void)prepareForCoinsBirth:(NSInteger)coinsNumber{
    
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
        }else{
            NSLog(@"displaylink ok");
        }
    }else{
        NSLog(@"no display link");
    }
    
    if (!self.displayLink || self.displayLink.paused) {
        [self.displayLink invalidate];
        self.displayLink =  [CADisplayLink displayLinkWithTarget:self selector:@selector(update:)];
        self.displayLink.frameInterval = 2;
        NSLog(@"create_display_link");
    }
}

- (void)clear{
    
    self.notBornCoinsNumer = 0;
    self.coinsBornLeftTime = 0;
    self.totalCoinsNumber = 0;
    self.totalBornCoinsNumber = 0;
}



- (void)makeCoinsBorn:(NSInteger)coinsNumber{
    
    if (coinsNumber <= 0) {
        return;
    }
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    NSLog(@"display_link_add_to_mainRunLoop");

    
}


- (void)invalidateDisplayLink{
    
    [self.displayLink invalidate];
    self.displayLink = nil;
    self.coinsBornLeftTime = 0.0;
    NSLog(@"display_link_invalidate");
}

- (void)update:(CADisplayLink *)displayLink{
    if (self.notBornCoinsNumer <= 0) {
        NSLog(@"notBornCoinsNumer <= 0");
    }else if(self.coinsBornLeftTime <= 0.0){
        NSLog(@"coinsBornLeftTime <= 0");
    }
    
    
    if (self.notBornCoinsNumer <= 0 || self.coinsBornLeftTime <= 0.0) {
        [self invalidateDisplayLink];
        [self.delegate coinBornDidFinished];
    }else{
        NSInteger birthRate = self.notBornCoinsNumer * 1.0  / self.coinsBornLeftTime;
        NSInteger coinsNumber =  birthRate * displayLink.duration + 0.5;
        if (coinsNumber < 1) {
            coinsNumber = 1;
        }
        
        NSTimeInterval timeInterval = CFAbsoluteTimeGetCurrent() - self.lastCoinBornAbsoluteTime;
        self.coinsBornLeftTime = self.coinsBornLeftTime - timeInterval;
        self.lastCoinBornAbsoluteTime = CFAbsoluteTimeGetCurrent();
        
        coinsNumber = coinsNumber > self.notBornCoinsNumer ? self.notBornCoinsNumer : coinsNumber;
        [self.delegate coinsDidBorn:coinsNumber];
        NSLog(@"dispalylink make %@ coins born",@(coinsNumber));

        self.notBornCoinsNumer = self.notBornCoinsNumer - coinsNumber;
        self.totalBornCoinsNumber = self.totalBornCoinsNumber + coinsNumber;

    }

}

@end

static BOOL coinPileAppearAnimationPlayed = NO;

@interface CoinsFallingView()<UICollisionBehaviorDelegate,UIDynamicAnimatorDelegate,CoinsBirthControllerDelegate>

@property (nonatomic)                   CGRect                      coinBirthRect;
@property (nonatomic)                   CGFloat                     bouncePositionY;

// UIDynamic
@property (strong,nonatomic ) UIDynamicAnimator      *animator;
@property (strong,nonatomic ) UIDynamicItemBehavior  *itemBehavior;
@property (strong,nonatomic ) UIGravityBehavior      *gravityBehavior;
@property (strong,nonatomic ) UICollisionBehavior    *collisionBehavior;
@property (nonatomic, strong) UISnapBehavior         *snapBehavior;

@property (strong,nonatomic ) NSMutableSet           *pushBehaviors;

@property (strong, nonatomic) CoinsBirthController   *coinBirthController;

@property (strong,nonatomic ) UILabel                *coinNumberLabel;
@property (strong,nonatomic ) UIView                 *coinPileView;

//emitter
@property (nonatomic, strong) CAEmitterLayer         *emitterLayer;

@end

@implementation CoinsFallingView

#pragma  mark - Init
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self configure];
    }
    return self;
}

#pragma mark - LifeCycle

- (void)layoutSubviews{
    [self configureGeometryInfo];
}

- (void)removeFromSuperview{
    
    [super removeFromSuperview];
    NSLog(@"coinsFallingViewRemovedFromSuperview,animator:%@,collision:%@,gravity:%@,itembehavior:%@",self.animator,self.collisionBehavior,self.gravityBehavior,self.itemBehavior);
}

#pragma mark - Configure
-(void)configure{
    
    
    self.userInteractionEnabled = NO;
    self.backgroundColor = [UIColor clearColor];
    // diable coinNumberLabel tem..ly
//    [self addSubview:self.coinNumberLabel];
    [self configureGeometryInfo];

}

#pragma mark - Public

- (void)willAddCoins:(NSInteger)coinsNumbers{
    NSInteger coinsToBeBorn = coinsNumbers;
    if (coinsToBeBorn > 500) {
        coinsToBeBorn = 500;
    }
    [self.coinBirthController prepareForCoinsBirth:coinsNumbers];
}

- (void)addCoins:(NSInteger)coinsNumber{
    
    if (coinsNumber <= 0 ) {
        return;
    }
    
    if (self.coinBirthRect.size.width <= 0 || self.coinBirthRect.size.height <= 0) {
        [self.delegate fallingAnimationFinished];
    }
    
    NSInteger coinsToBeBorn = coinsNumber;
    if (coinsToBeBorn > 500) {
        coinsToBeBorn = 500;
    }
    
    self.coinNumberLabel.hidden = !self.shouldShowCoinsNumberLabel;
    
    [self.coinBirthController makeCoinsBorn:coinsToBeBorn];
    
    // make emitter work
    [self startEmitter];
    
}

- (void)confirmCoinAdded:(NSInteger)coinNumber {
    for(UIView *view in self.subviews) {
        if([view isKindOfClass:[CoinFallingItemView class]]) {
            if(coinNumber <= 0) {
                break;
            }
            CoinFallingItemView *item = (CoinFallingItemView *)view;
            if(!item.hasContacted) {
                [self popItem:item toSnap:CGPointMake(320, 10)];
                coinNumber--;
            }
        }
    }
}

#pragma mark - Private

- (void)configureGeometryInfo{

    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat height =  CGRectGetHeight(self.bounds);

    // calucaute geomotry and boundary
//    CGRect birthUnitRect = [CoinFallingParameter coinBirthArea];
//    self.coinBirthRect = CGRectApplyAffineTransform(birthUnitRect,
//                                                    CGAffineTransformScale(CGAffineTransformIdentity, width, height));
    self.coinBirthRect = [CoinFallingParameter coinBirthArea];
    self.coinNumberLabel.frame = self.coinBirthRect;

    self.bouncePositionY = CGRectGetMaxY([CoinFallingParameter coinBirthArea]);
    [self.collisionBehavior removeBoundaryWithIdentifier:@"bottom"];
    [self.collisionBehavior addBoundaryWithIdentifier:@"bottom"
                                            fromPoint:CGPointMake(-6000, self.bouncePositionY)
                                              toPoint:CGPointMake(6000, self.bouncePositionY)];
}

- (void)startEmitter{
//    self.emitterLayer.birthRate = ;
}

- (void)playSound{
    
    if ([CoinFallingParameter shouldPlaySound]) {
        
        [SCAudioPlayer playSoundWithFileName:@"sound_coin_harvest"
                                  bundleName:nil
                                      ofType:@"mp3"
                                    andAlert:NO];
    }
}

- (void)addCoinsToDynamics:(NSInteger)number{
    if (number <= 0 ) {
        return;
    }
    // add new coin to dynamic system
    for (NSInteger index = 0; index < number; index ++) {

        CoinFallingItemView *view = [[CoinFallingItemView alloc]init];
//        view.layer.contents = (__bridge id _Nullable)([[CoinFallingParameter randomCoinFallingImage] CGImage]);
        view.animationImages = [CoinFallingParameter getAnimateImageArray];
        view.animationDuration = 0.5f;
        view.animationRepeatCount = 0;
        [view startAnimating];
        
        CGSize size = [CoinFallingParameter randomCoinSize];
        CGPoint center = [CoinFallingParameter randomPointInRect:self.coinBirthRect];
        CGRect frame = CGRectMake(center.x - size.width / 2, center.y - size.height / 2, size.width, size.height);
//        CGRect emitterRect =  [self.emitterLayer convertRect:frame fromLayer:self.layer];
//        self.emitterLayer.emitterPosition = CGPointMake(CGRectGetMidX(emitterRect), CGRectGetMidY(emitterRect) + 10);
//        NSLog(@"coinFrame:%@",NSStringFromCGRect(frame));
        view.frame = frame;

        view.alpha = 0.1;
        [self addSubview:view];
        
        [self.itemBehavior addItem:view];
        [self.itemBehavior addAngularVelocity:[CoinFallingParameter randomAngularVelocity] forItem:view];
        
        [self.gravityBehavior addItem:view];
        [self.collisionBehavior addItem:view];
        
        // give each a up instant push with random angle
        UIPushBehavior *pushBehavior = [[UIPushBehavior alloc]initWithItems:@[view] mode:UIPushBehaviorModeInstantaneous];
        [pushBehavior setAngle: [CoinFallingParameter randomCoinBirthAngle] magnitude:[CoinFallingParameter randomCoinBirthmagnitude]];
        [self.animator addBehavior:pushBehavior];
        [self.pushBehaviors addObject:pushBehavior];
        
    }
//    NSLog(@"fallingview add coin");
    if (!self.coinNumberLabel.hidden) {
        self.coinNumberLabel.text = [NSString stringWithFormat:@"+%@",@(self.coinBirthController.totalBornCoinsNumber)];
//        [self bringSubviewToFront:self.coinNumberLabel];
    }
    
    
}

- (void)popItem:(CoinFallingItemView *)item toSnap:(CGPoint)point {
    item.hasContacted = YES;
    UISnapBehavior *snapBehavior = [[UISnapBehavior alloc] initWithItem:item snapToPoint:point];
    snapBehavior.damping = 1;
    [self.animator addBehavior:snapBehavior];
}

#pragma mark - CoinsBirthControllerDelegate
- (void)coinsDidBorn:(NSInteger)coinsNumber{
    
    static NSTimeInterval lastSoundPlayTime = 0;
    NSTimeInterval currentAbsoluteTime = CFAbsoluteTimeGetCurrent();
    if (currentAbsoluteTime - lastSoundPlayTime >= 0.8) {
        [self playSound];
        lastSoundPlayTime = currentAbsoluteTime;
    }
    [self addCoinsToDynamics:coinsNumber];
//    NSLog(@"%@ coins born",@(coinsNumber));

    
}

- (void)coinBornDidFinished{
    self.coinNumberLabel.text = [NSString stringWithFormat:@"+%@",@(self.coinBirthController.totalCoinsNumber)];
}

#pragma mark - UICollisionBehaviorDelegate
- (void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item withBoundaryIdentifier:(id<NSCopying>)identifier atPoint:(CGPoint)p{
   
//    NSLog(@"contact began");
    [(CoinFallingItemView *)item setHasContacted:YES];
    ((CoinFallingItemView *)item).layer.contents = (__bridge id _Nullable)([[CoinFallingParameter randomCoinFallingImage] CGImage]);
    
    if (!coinPileAppearAnimationPlayed && self.shouldShowCoinsPile) {
        coinPileAppearAnimationPlayed = YES;
        
        [self addSubview:self.coinPileView];
        self.coinPileView.hidden = NO;
        
        NSArray *keyFrameImages = [CoinFallingParameter coinPilesCGImages:self.coinBirthController.totalCoinsNumber];
        self.coinPileView.layer.contents = [keyFrameImages lastObject];

        CAKeyframeAnimation *keyFrameAnimation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
        keyFrameAnimation.values = keyFrameImages;
        keyFrameAnimation.keyTimes = [CoinFallingParameter coinPileKeyTimes:self.coinBirthController.totalCoinsNumber];
        NSTimeInterval birthDuration = [CoinFallingParameter coinBirthDuration:self.coinBirthController.totalCoinsNumber];
        keyFrameAnimation.duration = birthDuration;
        [self.coinPileView.layer addAnimation:keyFrameAnimation forKey:@"contentsChanged"];

    }
}

- (void)collisionBehavior:(UICollisionBehavior*)behavior endedContactForItem:(id <UIDynamicItem>)item withBoundaryIdentifier:(nullable id <NSCopying>)identifier{
    
    // remove collision after contact
    [self.collisionBehavior removeItem:item];
//    NSLog(@"ccontact end");

    
}

#pragma mark - UIDynamicAnimatorDelegate
- (void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator{
 
    NSLog(@"did pause");
    [UIView animateWithDuration:0.5 animations:^{
            self.coinNumberLabel.alpha = 0.3;
            self.coinPileView.alpha = 0.3;
        } completion:^(BOOL finished) {

            self.coinNumberLabel.alpha = 1.0;

            [self.coinPileView removeFromSuperview];
            self.coinPileView = nil;
        
            coinPileAppearAnimationPlayed = NO;

            [self.coinBirthController clear];
            
            if (self.itemBehavior.items.count == 0 && self.coinBirthController.notBornCoinsNumer <= 0) {
                [self.delegate fallingAnimationFinished];
                NSLog(@"animation finished");
            }

        }];
}

#pragma mark - Getter

- (UIDynamicAnimator *)animator{
    if (!_animator) {
         _animator = [[UIDynamicAnimator alloc]initWithReferenceView:self];
        _animator.delegate = self;
        [_animator addBehavior:self.gravityBehavior];
        [_animator addBehavior:self.collisionBehavior];
        [_animator addBehavior:self.itemBehavior];
    }
    return _animator;
}

- (UIGravityBehavior *)gravityBehavior{
    if (!_gravityBehavior) {
        _gravityBehavior = [[UIGravityBehavior alloc]init];
        _gravityBehavior.magnitude = [CoinFallingParameter gravityMagnitude];
    }
    return _gravityBehavior;
}

- (UICollisionBehavior *)collisionBehavior{
    if (!_collisionBehavior) {
        _collisionBehavior = [[UICollisionBehavior alloc]init];
        _collisionBehavior.collisionMode = UICollisionBehaviorModeBoundaries;
        _collisionBehavior.collisionDelegate = self;
        [_collisionBehavior removeBoundaryWithIdentifier:@"bottom"];
        [_collisionBehavior addBoundaryWithIdentifier:@"bottom"
                                   fromPoint:CGPointMake(-6000, self.bouncePositionY)
                                     toPoint:CGPointMake(6000, self.bouncePositionY)];

    }
    return _collisionBehavior;
}

- (UIDynamicItemBehavior *)itemBehavior{
    if (!_itemBehavior) {
        _itemBehavior = [[UIDynamicItemBehavior alloc]init];
        _itemBehavior.allowsRotation = YES;
        _itemBehavior.density = 0.7;
        _itemBehavior.elasticity = [CoinFallingParameter coinElasticity];

        __weak UIDynamicItemBehavior *weakItemBehavior = _itemBehavior;
        __weak typeof(self) weakSelf = self;
        weakItemBehavior.action = ^(){
            if (!weakSelf) {
                NSLog(@"weakself is nil");
                return;
            }
            // fade in when born and fade out when collision
            NSArray *items = [weakItemBehavior.items copy];
            //
            for (CoinFallingItemView *item in items) {
                if (item.alpha > 0.9 || CGRectGetMidY(item.frame) >= CGRectGetMaxY([CoinFallingParameter coinBirthArea])) {
                    if (CGRectGetMidY(item.frame) < [CoinFallingParameter randomStopYPositionTop:CGRectGetMinY([CoinFallingParameter coinBirthArea]) andBottom:CGRectGetMaxY([CoinFallingParameter coinBirthArea])]) {
                        [weakItemBehavior removeItem:item];
                        [weakSelf.gravityBehavior removeItem:item];
                        [weakSelf.collisionBehavior removeItem:item];
//                        [item removeFromSuperview];

                    }
                }else{
                    item.alpha += 0.1;
                }
            }
            // no longer need pushbehavior after birth
            for (UIPushBehavior *pushBehavior in weakSelf.pushBehaviors) {
                [weakSelf.animator removeBehavior:pushBehavior];
            }
            [weakSelf.pushBehaviors removeAllObjects];
        };

    }
    return _itemBehavior;
}

- (NSMutableSet *)pushBehaviors{
    if (!_pushBehaviors) {
        _pushBehaviors = [ NSMutableSet set];
    }
    return _pushBehaviors;
}

- (CAEmitterLayer *)emitterLayer{
    if (!_emitterLayer) {
        
        CAEmitterCell *emitterCell = [CAEmitterCell emitterCell];
        emitterCell.birthRate = 5;
        emitterCell.lifetime = 0.5;
        emitterCell.lifetimeRange = 0.2;
        emitterCell.emissionRange = 4;
        emitterCell.scaleRange = 0.5;
        emitterCell.velocity = 20;
        emitterCell.velocityRange = 10;
        emitterCell.xAcceleration = 0.5;
        emitterCell.yAcceleration = 0.5;
        emitterCell.zAcceleration = 0.5;
        emitterCell.contents = (__bridge id _Nullable)([UIImage imageNamed:@"star"].CGImage);
        
        _emitterLayer = [[CAEmitterLayer alloc] init];
        _emitterLayer.frame = self.coinBirthRect;
        _emitterLayer.emitterCells = @[emitterCell];
        _emitterLayer.scale = 0.7;
        _emitterLayer.velocity = 3;
        _emitterLayer.emitterPosition = CGPointMake(CGRectGetWidth(self.coinBirthRect) / 2, CGRectGetHeight(self.coinBirthRect) / 2);
        _emitterLayer.emitterShape = kCAEmitterLayerCircle;
        _emitterLayer.birthRate = 0;
        [self.layer addSublayer:_emitterLayer];
        
        
    }
    return _emitterLayer;
}

- (UIView *)coinPileView{
    if (!_coinPileView) {
        _coinPileView = [[UIView alloc]init];
        _coinPileView.hidden = YES;
        CGSize pileSize = [CoinFallingParameter coinPileSize];
        _coinPileView.frame = CGRectMake((CGRectGetWidth(self.bounds) - pileSize.width) / 2,
                                             self.bouncePositionY - pileSize.height * 2.0 / 3,
                                             pileSize.width,
                                             pileSize.height);

    }
    return _coinPileView;
}

- (UILabel *)coinNumberLabel{
    if (!_coinNumberLabel) {
        UILabel *coinNumberLabel = [[UILabel alloc]init];
        _coinNumberLabel = coinNumberLabel;
        _coinNumberLabel.textColor = [UIColor orangeColor];
        _coinNumberLabel.textAlignment = NSTextAlignmentCenter;
        _coinNumberLabel.hidden = YES;
        _coinNumberLabel.font = [UIFont systemFontOfSize:36 weight:UIFontWeightLight];
    }
//    return _coinNumberLabel;
    return nil;
}

- (CoinsBirthController *)coinBirthController{
    if (!_coinBirthController) {
        _coinBirthController = [[CoinsBirthController alloc] init];
        _coinBirthController.delegate = self;
    }
    return _coinBirthController;
}

#pragma mark - Setter

- (void)setShouldShowCoinsNumberLabel:(BOOL)shouldShowCoinsNumberLabel{
    _shouldShowCoinsNumberLabel = shouldShowCoinsNumberLabel;
    self.coinNumberLabel.hidden = !shouldShowCoinsNumberLabel;
}







@end
