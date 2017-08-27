//
//  MCSettingsViewController.h
//  MCRun
//
//  Created by moshuqi on 15/12/7.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MCSettingsViewControllerDelegate <NSObject>

@required
- (void)settingsViewDidSelectedLogout;

@end

@interface MCSettingsViewController : UIViewController

@property (nonatomic, weak) id<MCSettingsViewControllerDelegate> delegate;

@end
