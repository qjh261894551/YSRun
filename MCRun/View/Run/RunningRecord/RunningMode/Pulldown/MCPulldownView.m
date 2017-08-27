//
//  MCPulldownView.m
//  MCRun
//
//  Created by moshuqi on 15/10/19.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "MCPulldownView.h"
#import "MCAppMacro.h"
#import "MCPulldownAnimation.h"
#import "MCAppMacro.h"

@interface MCPulldownView ()

@property (nonatomic, strong) UIView *circleView;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) MCPulldownAnimation *arrow;

@end

const CGFloat kArrowHeight = 24;

@implementation MCPulldownView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initSubviews];
    }
    
    return self;
}

+ (instancetype)defaultPulldownViewWithRadius:(CGFloat)radius
{
    CGFloat width = radius * 2;
    CGFloat distance = 15;  // 按钮和箭头的间距
    CGFloat height = radius * 2 + kArrowHeight + distance;
    CGRect frame = CGRectMake(0, 0, width, height);
    
    MCPulldownView *pulldownView = [[MCPulldownView alloc] initWithFrame:frame];
    return pulldownView;
}

- (void)initSubviews
{
    CGFloat width = CGRectGetWidth(self.frame);
    
    CGFloat radius = width / 2;
    CGRect circleFrame = CGRectMake(0, 0, radius * 2, radius * 2);
    
    self.circleView = [[UIView alloc] initWithFrame:circleFrame];
    [self addSubview:self.circleView];
    
    self.label = [[UILabel alloc] initWithFrame:self.circleView.bounds];
    [self.circleView addSubview:self.label];
    
    self.label.numberOfLines = 0;
    self.label.text = @"下拉\n暂停";
    self.label.textAlignment = NSTextAlignmentCenter;
    
    // 新界面调整去掉动画箭头 --2016.2.21
//    CGFloat height = CGRectGetHeight(self.frame);
//    CGRect arrowFrame = CGRectMake(0, height - kArrowHeight, width, kArrowHeight);
//    self.arrow = [[MCPulldownAnimation alloc] initWithFrame:arrowFrame];
//    [self.arrow starAnimation];
//    [self addSubview:self.arrow];
}

- (void)setAppearanceWithType:(MCPulldownType)type
{
    // 普通模式和地图模式下界面不一样
    
//    UIColor *greenColor = RGB(33, 221, 143);
//    
//    if (type == MCPulldownTypeGeneralMode)
//    {
//        self.circleView.layer.borderWidth = 3;
//        self.circleView.layer.borderColor = greenColor.CGColor;
//        self.circleView.backgroundColor = [UIColor clearColor];
//        
//        UIColor *textColor = RGB(107, 226, 177);
//        self.label.textColor = textColor;
//    }
//    else
//    {
//        self.circleView.backgroundColor = greenColor;
//        self.label.textColor = [UIColor whiteColor];
//    }
    
    
    // 新界面调整后普通模式和地图模式按钮一致 --2016.2.21
    self.circleView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
    self.label.textColor = GreenBackgroundColor;
    
    CGFloat radius = CGRectGetWidth(self.circleView.frame) / 2;
    self.circleView.layer.cornerRadius = radius;
}

@end
