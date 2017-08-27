//
//  MCResultRecordView.h
//  MCRun
//
//  Created by moshuqi on 15/10/16.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MCRunInfoModel;

@protocol MCResultRecordViewDelegate <NSObject>

@required
- (void)showRunDataDetail;
- (void)showHeartRateDataDetail;
- (void)resultRecordViewBack;

@end

@interface MCResultRecordView : UIView

@property (nonatomic, weak) id<MCResultRecordViewDelegate> delegate;

- (void)setupRecordWith:(MCRunInfoModel *)runInfoModel;

@end
