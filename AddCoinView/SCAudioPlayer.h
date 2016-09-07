//
//  SCAudioPlayer.h
//  SnapUpload
//
//  Created by tali on 16/5/19.
//  Copyright © 2016年 JellyKit Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCAudioPlayer : NSObject

+ (void)playSoundWithFileName:(NSString *)aFileName
                   bundleName:(NSString *)aBundleName
                       ofType:(NSString *)ext
                     andAlert:(BOOL)alert;

@end
