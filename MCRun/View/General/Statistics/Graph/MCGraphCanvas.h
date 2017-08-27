//
//  MCGraphCanvas.h
//  MCRun
//
//  Created by moshuqi on 15/12/9.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MCGraphData;

@interface MCGraphCanvas : UIView

//- (id)initWithFrame:(CGRect)frame pointArray:(NSArray *)pointArray;
- (id)initWithFrame:(CGRect)frame graphData:(MCGraphData *)graphData;
- (UIImage *)getGraphImageWithSize:(CGSize)size;

@end
