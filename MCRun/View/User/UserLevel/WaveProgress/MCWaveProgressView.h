//
//  MCWaveProgressView.h
//  MCRun
//
//  Created by moshuqi on 16/1/11.
//  Copyright © 2016年 msq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MCWaveProgressView : UIView

- (void)setupWithLevel:(NSInteger)level title:(NSString *)title grogressPercent:(CGFloat)percent;

- (void)resetWaterWaveView;
- (void)resetProgress:(CGFloat)progress;

@end
