//
//  MCChart.h
//  PieChartDemo
//
//  Created by moshuqi on 15/11/16.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCChartData.h"
#import "MCAppMacro.h"

@interface MCChart : UIView

@property (nonatomic, strong) MCChartData *chartData;
@property (nonatomic, strong) NSMutableArray *elementLabelArray;     // 显示每个元素名称、百分比的标签数组

- (void)setChartElementVisible:(BOOL)elementVisible percentVisible:(BOOL)percentVisible;

@end
