//
//  AddCoinAnimationManager.h
//  AddCoinView
//
//  Created by wyan assert on 9/8/16.
//  Copyright © 2016 wyan assert. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol AddCoinAnimationManagerDelegate;

@interface AddCoinAnimationManager : NSObject

- (void)addCoins:(NSInteger)coinNumber;
- (void)popCoins:(NSInteger)coinNumber;
- (void)removeCoins:(NSInteger)coinNumber;

- (void)stop;

@property (nonatomic, assign) CGRect                                snapRect;
@property (nonatomic, assign) CGRect                                displayRect;
@property (nonatomic, assign) NSUInteger                            maxDisplayAmount;

@property (nonatomic, weak  ) UIView                               *associatedView;

@property (nonatomic, weak  ) id<AddCoinAnimationManagerDelegate>   delegate;

@end

@protocol AddCoinAnimationManagerDelegate <NSObject>

- (void)AddCoinPopAnimationDidFinished:(NSInteger)coinNumber;

@end
