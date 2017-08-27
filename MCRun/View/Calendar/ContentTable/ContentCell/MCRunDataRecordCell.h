//
//  MCRunDataRecordCell.h
//  MCRun
//
//  Created by moshuqi on 15/11/24.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MCRunDataRecordCellDelegate <NSObject>

@optional
- (void)showContentHelpFromPoint:(CGPoint)point;

@end

@class MCDataRecordModel;

@interface MCRunDataRecordCell : UITableViewCell

@property (nonatomic, weak) id<MCRunDataRecordCellDelegate> delegate;

- (void)setHelpTitleHidden:(BOOL)isHidden;
- (void)resetCellWithModel:(MCDataRecordModel *)model;

@end
