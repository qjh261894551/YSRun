//
//  MCContentTable.h
//  MCRun
//
//  Created by moshuqi on 15/11/24.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MCDataRecordModel;

@protocol MCContentTableDelegate <NSObject>

@optional
- (void)showHeartRateRecordWithDataModel:(MCDataRecordModel *)dataModel;

@end

@interface MCContentTable : UIView

@property (nonatomic, weak) id<MCContentTableDelegate> delegate;

- (void)resetTableWithRecordDataArray:(NSArray *)recordDataArray;

@end
