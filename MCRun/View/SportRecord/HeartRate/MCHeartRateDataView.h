//
//  MCHeartRateDataView.h
//  MCRun
//
//  Created by moshuqi on 16/1/25.
//  Copyright © 2016年 msq. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MCDataRecordModel;

@interface MCHeartRateDataView : UIView

- (void)setupWithDataRecordModel:(MCDataRecordModel *)dataRecordModel;
- (void)showPercentValue;

@end
