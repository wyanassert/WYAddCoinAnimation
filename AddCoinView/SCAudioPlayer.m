//
//  SCAudioPlayer.m
//  SnapUpload
//
//  Created by tali on 16/5/19.
//  Copyright © 2016年 JellyKit Inc. All rights reserved.
//

#import "SCAudioPlayer.h"
#import <AudioToolBox/AudioToolbox.h>

@implementation SCAudioPlayer

+ (void)playSoundWithFileName:(NSString *)aFileName bundleName:(NSString *)aBundleName ofType:(NSString *)ext andAlert:(BOOL)alert
{
    NSBundle *bundle = [NSBundle mainBundle];
    if (aBundleName.length) {
        bundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:aBundleName withExtension:@"bundle"]];
    }
    
    if (!bundle) {
        NSLog(@"play sound cannot find bundle,%@",aBundleName);
        return ;
    }
    
    NSString *path = [bundle pathForResource:aFileName ofType:ext];
    
    if (!path) {
        NSLog(@"play sound cannot find file [%@] in bundle [%@]",aFileName ,aBundleName);
        return ;
    }
    
    NSURL *urlFile = [NSURL fileURLWithPath:path];
    
    // ID[unsigned long]
    SystemSoundID ID;
    
    // create source return ID
    OSStatus err = AudioServicesCreateSystemSoundID((__bridge CFURLRef)urlFile, &ID);
    
    if (err) {
        NSLog(@"play sound cannot create file url [%@]",urlFile);
        return ;
    }
    
    // system or no
    if (alert) {
        AudioServicesPlayAlertSound(ID);
    }
    else {
        AudioServicesPlaySystemSound(ID);
    }
}

@end
