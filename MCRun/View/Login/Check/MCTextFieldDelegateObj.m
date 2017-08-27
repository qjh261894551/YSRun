//
//  MCTextFieldDelegateObj.m
//  MCRun
//
//  Created by moshuqi on 16/1/13.
//  Copyright © 2016年 msq. All rights reserved.
//

#import "MCTextFieldDelegateObj.h"
#import "MCEditingCheck.h"
#import "MCContentCheck.h"

@interface MCTextFieldDelegateObj ()

@property (nonatomic, copy) NSString *beginText;
@property (nonatomic, copy) NSString *endText;

@property (nonatomic, copy) NSArray<MCEditingCheck *> *editingCheckArray;
@property (nonatomic, copy) NSArray<MCContentCheck *> *contentCheckArray;

@end

@implementation MCTextFieldDelegateObj

- (id)initWithEditingCheckArray:(NSArray<MCEditingCheck *> *)editingCheckArray
              contentCheckArray:(NSArray<MCContentCheck *> *)contentCheckArray
{
    self = [super init];
    if (self)
    {
        self.editingCheckArray = editingCheckArray;
        self.contentCheckArray = contentCheckArray;
    }
    
    return self;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([self.editingCheckArray count] > 0)
    {
        for (MCEditingCheck *check in self.editingCheckArray)
        {
            BOOL checkResult = [check checkTextField:textField inRange:range replacementString:string];
            if (checkResult == NO)
            {
                return NO;
            }
        }
    }
    
    // 输入内容检查放在确定能输入之后
    if ([self.contentCheckArray count] > 0)
    {
        NSString *beginText = textField.text;
        NSMutableString *endText = [NSMutableString stringWithString:beginText];
        [endText replaceCharactersInRange:range withString:string];
        
        for (MCContentCheck *contentCheck in self.contentCheckArray)
        {
            [contentCheck checkWithTextField:textField beginText:beginText endText:endText];
        }
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(textFieldDidReturn:)])
    {
        [self.delegate textFieldDidReturn:textField];
    }
    
    return YES;
}

@end
