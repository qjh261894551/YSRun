//
//  MCPulldownView.h
//  MCRun
//
//  Created by moshuqi on 15/10/19.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MCPulldownType)
{
    MCPulldownTypeGeneralMode = 1,
    MCPulldownTypeMapMode
};

@interface MCPulldownView : UIView

+ (instancetype)defaultPulldownViewWithRadius:(CGFloat)radius;
- (void)setAppearanceWithType:(MCPulldownType)type;

@end
