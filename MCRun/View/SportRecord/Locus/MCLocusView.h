//
//  MCLocusView.h
//  MCRun
//
//  Created by moshuqi on 16/1/25.
//  Copyright © 2016年 msq. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MCDataRecordModel;

@interface MCLocusView : UIView

- (void)setupWithDataRecordModel:(MCDataRecordModel *)dataRecordModel;
- (UIImage *)getMapScreenShot;

@end
