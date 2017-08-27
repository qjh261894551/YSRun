//
//  MCUserNoLoginView.h
//  MCRun
//
//  Created by moshuqi on 15/10/16.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCUserSetCell.h"

@protocol MCUserNoLoginViewDelegate <NSObject>

@required
- (void)login;
- (void)userNoLoginViewDidSelectedType:(MCSettingsType)type;

@end

@interface MCUserNoLoginView : UIView

@property (nonatomic, assign) id<MCUserNoLoginViewDelegate> delegate;

@end
