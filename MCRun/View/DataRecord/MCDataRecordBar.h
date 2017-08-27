//
//  MCDataRecordBar.h
//  MCRun
//
//  Created by moshuqi on 15/11/16.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MCDataRecordBarDelegate <NSObject>

@required
- (void)viewBack;

@end

@interface MCDataRecordBar : UIView

@property (nonatomic, weak) id<MCDataRecordBarDelegate> delegate;

- (void)setBarTitle:(NSString *)title;

@end
