//
//  MCResultTipView.h
//  MCRun
//
//  Created by moshuqi on 16/2/23.
//  Copyright © 2016年 msq. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MCResultTipViewDelegate <NSObject>

@optional
- (void)showHelpFromPoint:(CGPoint)point;

@end

@interface MCResultTipView : UIView

@property (nonatomic, weak) id<MCResultTipViewDelegate> delegate;

- (void)showTipWithRating:(NSInteger)rating;

@end
