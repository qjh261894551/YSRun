//
//  MCGraph.h
//  PieChartDemo
//
//  Created by moshuqi on 15/11/12.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MCGraphData;

@interface MCGraph : UIView

- (void)setupWithGraphData:(MCGraphData *)graphData;
- (NSArray *)getPoints;

@end
