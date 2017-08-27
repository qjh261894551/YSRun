//
//  MCShareInfo.m
//  MCRun
//
//  Created by moshuqi on 15/12/5.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "MCShareInfo.h"

@implementation MCShareInfo

+ (instancetype)defaultShareInfoWithImages:(NSArray *)images
{
    return [MCShareInfo defaultShareInfoWithImages:images contentText:nil];
}

+ (instancetype)defaultShareInfoWithImages:(NSArray *)images contentText:(NSString *)contentText
{
    MCShareInfo *shareInfo = [MCShareInfo new];
    shareInfo.imageArray = images;
    shareInfo.contentText = contentText;
    
    // 其他参数为默认值
    shareInfo.url = [NSURL URLWithString:@"http://www.yspaobu.com"];
    shareInfo.title = @"易瘦跑步";
    
    return shareInfo;
}

@end
