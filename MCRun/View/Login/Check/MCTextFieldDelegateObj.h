//
//  MCTextFieldDelegateObj.h
//  MCRun
//
//  Created by moshuqi on 16/1/13.
//  Copyright © 2016年 msq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class MCEditingCheck;
@class MCContentCheck;

@protocol MCTextFieldDelegateObjCallBack <NSObject>

@optional
- (void)textFieldDidReturn:(UITextField *)textField;

@end

@interface MCTextFieldDelegateObj : NSObject <UITextFieldDelegate>

@property (nonatomic, weak) id<MCTextFieldDelegateObjCallBack> delegate;

- (id)initWithEditingCheckArray:(NSArray<MCEditingCheck *> *)editingCheckArray
        contentCheckArray:(NSArray<MCContentCheck *> *)contentCheckArray;

@end
