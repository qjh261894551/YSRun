//
//  MCPhoneTextFieldLimitDelegate.h
//  MCRun
//
//  Created by moshuqi on 15/10/22.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol MCPhoneTextFieldLimitDelegateCallback <NSObject>

- (void)phoneLengthMoreThanLimit;

@end

@interface MCPhoneTextFieldLimitDelegate : NSObject <UITextFieldDelegate>

@property (nonatomic, weak) id<MCPhoneTextFieldLimitDelegateCallback> delegate;

@end
