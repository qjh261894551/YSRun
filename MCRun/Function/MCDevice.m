//
//  MCDevice.m
//  MCRun
//
//  Created by moshuqi on 15/12/17.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "MCDevice.h"
#import <UIKit/UIKit.h>

@implementation MCDevice

+ (BOOL)isPhone6Plus
{
    CGFloat scale = [UIScreen mainScreen].scale;
    if (scale > 2.1) {
        return YES;
    }
    else
    {
        return NO;
    }
}


@end
