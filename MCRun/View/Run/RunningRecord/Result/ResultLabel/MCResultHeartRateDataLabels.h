//
//  MCResultHeartRateDataLabels.h
//  MCRun
//
//  Created by moshuqi on 15/11/23.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MCResultHeartRateDataLabelsDelegate <NSObject>

@required
- (void)heartRateDataLabelsTapDetail;

@end

@interface MCResultHeartRateDataLabels : UIView

@property (nonatomic, weak) id<MCResultHeartRateDataLabelsDelegate> delegate;

- (void)setDistance:(CGFloat)distance time:(NSString *)time calorie:(CGFloat)calorie heartRateProportion:(CGFloat)proportion;

@end
