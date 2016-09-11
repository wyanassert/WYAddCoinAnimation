//
//  CoinAnimationItemView.h
//  AddCoinView
//
//  Created by wyan assert on 9/7/16.
//  Copyright © 2016 wyan assert. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CoinAnimationItemView : UIImageView

@property (nonatomic, assign) BOOL  hasContacted;
@property (nonatomic, assign) BOOL  hasAttached;
@property (nonatomic, assign) BOOL  isSigned;

@property (nonatomic, copy)   void (^dismissAction)(void);

@end

