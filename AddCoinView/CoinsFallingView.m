//
//  CoinsFallingView.m
//  UIDynamicsDemo
//
//  Created by Amay on 5/22/16.
//  Copyright © 2016年 JellyKit Inc. All rights reserved.
//


#import "CoinsFallingView.h"
#import "CoinFallingParameter.h"
#import "CoinFallingItemView.h"
#import "CoinsBirthController.h"

static NSString *CoinPopControllerIdentifer = @"CoinPopControllerIdentifer";
static NSString *CoinBornControllerIdentifer = @"CoinBornControllerIdentifer";

@interface CoinsFallingView()<UICollisionBehaviorDelegate,UIDynamicAnimatorDelegate,CoinsBirthControllerDelegate>

@property (assign, nonatomic) CGRect                  coinBirthRect;
@property (assign, nonatomic) CGFloat                 bouncePositionY;

@property (strong, nonatomic) UIDynamicAnimator      *animator;
@property (strong, nonatomic) UIDynamicItemBehavior  *itemBehavior;
@property (strong, nonatomic) UIDynamicItemBehavior  *popItemBehavior;

@property (strong, nonatomic) NSMutableSet           *pushBehaviors;

@property (strong, nonatomic) CoinsBirthController   *coinBirthController;
@property (strong, nonatomic) CoinsBirthController   *coinPopController;

@end

@implementation CoinsFallingView

#pragma  mark - Init
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configure];
    }
    return self;
}

#pragma mark - LifeCycle

- (void)layoutSubviews {
    [self configureGeometryInfo];
}

- (void)removeFromSuperview {
    [super removeFromSuperview];
}

#pragma mark - Configure
-(void)configure {
    self.userInteractionEnabled = NO;
    self.backgroundColor = [UIColor clearColor];

    [self configureGeometryInfo];

}

#pragma mark - Public

- (void)willAddCoins:(NSInteger)coinsNumbers {
    NSInteger coinsToBeBorn = coinsNumbers;
    if (coinsToBeBorn > 500) {
        coinsToBeBorn = 500;
    }
    [self.coinBirthController prepareForCoinsBirth:coinsNumbers];
}

- (void)addCoins:(NSInteger)coinsNumber {
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
    
    [self.coinBirthController makeCoinsBorn:coinsToBeBorn];
    
}

- (void)willConfirmCoinAdded:(NSInteger)coinNumber {
    [self.coinPopController prepareForCoinsBirth:coinNumber];
}

- (void)confirmCoinAdded:(NSInteger)coinNumber {
    if (coinNumber <= 0 ) {
        return;
    }
    
    NSInteger coinsToBeBorn = coinNumber;
    if (coinsToBeBorn > 500) {
        coinsToBeBorn = 500;
    }
    
    [self.coinPopController makeCoinsBorn:coinsToBeBorn];
}

#pragma mark - Private
- (void)configureGeometryInfo {
    CGRect rect = [CoinFallingParameter coinBirthArea];
    self.coinBirthRect = CGRectMake(rect.origin.x + rect.size.width / 3.0,
                                    rect.origin.y + rect.size.height / 3.0,
                                    rect.size.width / 3.0,
                                    rect.size.height / 3.0);

    self.bouncePositionY = CGRectGetMaxY([CoinFallingParameter coinBirthArea]);
}

- (void)addCoinsToDynamics:(NSInteger)number {
    if (number <= 0 ) {
        return;
    }
    // add new coin to dynamic system
    for (NSInteger index = 0; index < number; index ++) {
        CoinFallingItemView *view = [[CoinFallingItemView alloc]init];
        view.animationImages = [CoinFallingParameter getAnimateImageArray];
        view.animationDuration = 0.5f;
        view.animationRepeatCount = 0;
        [view startAnimating];
        
        CGSize size = [CoinFallingParameter randomCoinSize];
        CGPoint center = [CoinFallingParameter randomPointInRect:self.coinBirthRect];
        CGRect frame = CGRectMake(center.x - size.width / 2, center.y - size.height / 2, size.width, size.height);
        view.frame = frame;

        view.alpha = 0.1;
        [self addSubview:view];
        
        [self.itemBehavior addItem:view];
        
        // give each a up instant push with random angle
        UIPushBehavior *pushBehavior = [[UIPushBehavior alloc]initWithItems:@[view] mode:UIPushBehaviorModeInstantaneous];
        [pushBehavior setAngle: [CoinFallingParameter randomCoinBirthAngle] magnitude:[CoinFallingParameter randomCoinBirthmagnitude]];
        [self.animator addBehavior:pushBehavior];
        [self.pushBehaviors addObject:pushBehavior];
    }
    
}

- (void)popCoinsToDynamics:(NSInteger)number {
    if(0 >= number) {
        return ;
    }
    for(UIView *view in self.subviews) {
        if([view isKindOfClass:[CoinFallingItemView class]]) {
            CoinFallingItemView *item = (CoinFallingItemView *)view;
            if(!item.hasAttached) {
                if(0 >= number) {
                    break;
                }
                CGRect endRect  = [CoinFallingParameter coinSnapArea];
                [self popItem:item toSnap:CGPointMake(CGRectGetMidX(endRect), CGRectGetMidY(endRect))];
                number--;
            }
        }
    }
}

- (void)popItem:(CoinFallingItemView *)item toSnap:(CGPoint)point {
    
    item.hasAttached = YES;
    UISnapBehavior *snapBehavior = [[UISnapBehavior alloc] initWithItem:item snapToPoint:point];
    snapBehavior.damping = 1;
    
    __weak typeof(self) weakSelf = self;
    __weak UISnapBehavior *weakSnap =  snapBehavior;
    item.dismissAction = ^(void) {
        [weakSelf.animator removeBehavior:weakSnap];
    };
    [self.popItemBehavior addItem:item];
    [self.animator addBehavior:snapBehavior];
}


#pragma mark - CoinsBirthControllerDelegate
- (void)coinsDidBorn:(NSInteger)coinsNumber withCnntrollerIdentify:(NSString *)identifer{
    if([identifer isEqualToString:CoinBornControllerIdentifer]) {
        [self addCoinsToDynamics:coinsNumber];
    } else if([identifer isEqualToString:CoinPopControllerIdentifer]) {
        [self popCoinsToDynamics:coinsNumber];
    }
}

- (void)coinBornDidFinishedWithCnntrollerIdentify:(NSString *)identifer{
   
}


#pragma mark - UIDynamicAnimatorDelegate
- (void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator {
    NSLog(@"did pause");
    if (self.itemBehavior.items.count == 0 && self.coinBirthController.notBornCoinsNumer <= 0) {
        [self.delegate fallingAnimationFinished];
        NSLog(@"animation finished");
    }
}

#pragma mark - Getter
- (UIDynamicAnimator *)animator {
    if (!_animator) {
         _animator = [[UIDynamicAnimator alloc]initWithReferenceView:self];
        _animator.delegate = self;
        [_animator addBehavior:self.itemBehavior];
        [_animator addBehavior:self.popItemBehavior];
    }
    return _animator;
}

- (UIDynamicItemBehavior *)itemBehavior {
    if (!_itemBehavior) {
        _itemBehavior = [[UIDynamicItemBehavior alloc]init];
        _itemBehavior.allowsRotation = YES;
        _itemBehavior.density = 0.7;
        _itemBehavior.elasticity = [CoinFallingParameter coinElasticity];

        __weak UIDynamicItemBehavior *weakItemBehavior = _itemBehavior;
        __weak typeof(self) weakSelf = self;
        weakItemBehavior.action = ^() {
            if (!weakSelf) {
                NSLog(@"weakself is nil");
                return;
            }
            // fade in when born and fade out when collision
            NSArray *items = [weakItemBehavior.items copy];
            //
            for (CoinFallingItemView *item in items) {
                if (item.alpha > 0.9 || CGRectGetMaxY(item.frame) >= CGRectGetMaxY([CoinFallingParameter coinBirthArea])) {
                    if (CGRectGetMidY(item.frame) < [CoinFallingParameter randomStopYPositionTop:CGRectGetMinY([CoinFallingParameter coinBirthArea]) andBottom:CGRectGetMaxY([CoinFallingParameter coinBirthArea])]) {
                        [weakItemBehavior removeItem:item];
                    }
                } else {
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

- (UIDynamicItemBehavior *)popItemBehavior {
    if(!_popItemBehavior) {
        _popItemBehavior = [[UIDynamicItemBehavior alloc]init];
        _popItemBehavior.allowsRotation = YES;
        
        __weak UIDynamicItemBehavior *weakPopItemBehavior = _popItemBehavior;
        __weak typeof(self) weakSelf = self;
        _popItemBehavior.action = ^() {
            if(!weakSelf) {
                return ;
            }
            NSArray *array = [weakPopItemBehavior.items copy];
            for(CoinFallingItemView *item in array) {
                if(CGRectContainsPoint([CoinFallingParameter coinSnapArea], item.center)) {
                    [weakPopItemBehavior removeItem:item];
                    item.dismissAction();
                    [item removeFromSuperview];
                }
            }
        };
        
    }
    return _popItemBehavior;
}

- (NSMutableSet *)pushBehaviors {
    if (!_pushBehaviors) {
        _pushBehaviors = [ NSMutableSet set];
    }
    return _pushBehaviors;
}

- (CoinsBirthController *)coinBirthController {
    if (!_coinBirthController) {
        _coinBirthController = [[CoinsBirthController alloc] initWithIdentifier:CoinBornControllerIdentifer];
        _coinBirthController.delegate = self;
    }
    return _coinBirthController;
}

- (CoinsBirthController *)coinPopController {
    if(!_coinPopController) {
        _coinPopController = [[CoinsBirthController alloc] initWithIdentifier:CoinPopControllerIdentifer];
        _coinPopController.delegate = self;
    }
    return _coinPopController;
}

@end
