//
//  MCLoginViewController.h
//  MCRun
//
//  Created by moshuqi on 15/10/16.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MCLoginViewController;
@class MCUserInfoResponseModel;
@class MCUserDatabaseModel;

@protocol MCLoginViewControllerDelegate <NSObject>

@required
- (void)loginViewController:(MCLoginViewController *)loginViewController loginFinishWithUserInfoResponseModel:(MCUserInfoResponseModel *)userInfoResponseModel;
- (void)loginViewController:(MCLoginViewController *)loginViewController registerFinishWithResponseUserInfo:(MCUserDatabaseModel *)userInfo;

@end

@interface MCLoginViewController : UIViewController

@property (nonatomic, weak) id<MCLoginViewControllerDelegate> delegate;

@end
