//
//  MCResultRunDataLabels.h
//  MCRun
//
//  Created by moshuqi on 15/12/11.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MCResultRunDataLabelsDelegate <NSObject>

@required
- (void)runDataLabelsTapDetail;

@end

@interface MCResultRunDataLabels : UIView

@property (nonatomic, weak) id<MCResultRunDataLabelsDelegate> delegate;

- (void)setDistance:(CGFloat)distance time:(NSString *)time calorie:(CGFloat)calorie;

@end
