//
//  MCContentHelpView.m
//  MCRun
//
//  Created by moshuqi on 15/11/24.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "MCContentHelpView.h"
#import "MCHelpDetailComponent.h"
#import "MCStatisticsDefine.h"
#import "MCAppMacro.h"

@interface MCContentHelpView ()

@property (nonatomic, weak) IBOutlet MCHelpDetailComponent *detailComponet1;
@property (nonatomic, weak) IBOutlet MCHelpDetailComponent *detailComponet2;
@property (nonatomic, weak) IBOutlet MCHelpDetailComponent *detailComponet3;

@end

@implementation MCContentHelpView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        self.backgroundColor = RGB(245, 245, 245);
    }
    
    return self;
}

- (void)setupComponents
{
    NSString *detailStr1 = @"代表心率不能达到快速减脂效果，需要加快运动";
    [self.detailComponet1 setDetailWithText:detailStr1 color:JoggingColor];
    
    NSString *detailStr2 = @"代表心率已到达快速减脂效果";
    [self.detailComponet2 setDetailWithText:detailStr2 color:EfficientReduceFatColor];
    
    NSString *detailStr3 = @"代表心率过快，导致无氧呼吸，不能有效减脂";
    [self.detailComponet3 setDetailWithText:detailStr3 color:AnaerobicExerciseColor];
}

- (void)setColor:(UIColor *)color
{
    // 设置背景颜色
    self.backgroundColor = color;
}

@end
