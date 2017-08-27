//
//  MCCicularProgressView.h
//  MCRun
//
//  Created by moshuqi on 15/10/16.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MCCicularProgressView : UIView

- (id)initWithFrame:(CGRect)frame lineWidth:(CGFloat)lineWidth;

- (void)animationToProgress:(CGFloat)progress;
- (CGPoint)getGapPoint;


@end
