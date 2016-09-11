//
//  CoinAnimationItemView.m
//  AddCoinView
//
//  Created by wyan assert on 9/7/16.
//  Copyright © 2016 wyan assert. All rights reserved.
//

#import "CoinAnimationItemView.h"

@implementation CoinAnimationItemView

- (instancetype)init {
    if(self = [super init]) {
        self.hasAttached = NO;
        self.hasContacted = NO;
        self.isSigned = NO;
    }
    return self;
}

@end