//
//  MCUserViewController.h
//  MCRun
//
//  Created by moshuqi on 15/10/15.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MCUserViewControllerDelegate <NSObject>

@required
- (void)userViewUserStateChanged;   // 用户登录或者注销

@end

@interface MCUserViewController : UIViewController

@property (nonatomic, weak) id<MCUserViewControllerDelegate> delegate;

@end
