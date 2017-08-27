//
//  MCRunningRecordViewController.h
//  MCRun
//
//  Created by moshuqi on 15/10/16.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MCRunningRecordViewControllerDelegate <NSObject>

@required
- (void)runningRecordFinish;

@end

@interface MCRunningRecordViewController : UIViewController

@property (nonatomic, weak) id<MCRunningRecordViewControllerDelegate> delegate;

@end
