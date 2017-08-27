//
//  MCIconActionSheet.h
//  MCRun
//
//  Created by moshuqi on 15/12/9.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MCIconActionSheetItemIconKey                    @"MCIconActionSheetItemIconKey"
#define MCIconActionSheetItemTextKey                    @"MCIconActionSheetItemTextKey"
#define MCIconActionSheetItemSelectorStringKey          @"MCIconActionSheetItemSelectorStringKey"
#define MCIconActionSheetItemObjectKey                  @"MCIconActionSheetItemObjectKey"

typedef void(^MCIconActionSheetCallbackBlock)();

@interface MCIconActionSheet : NSObject

- (id)initWithDictArray:(NSArray *)dictArray;
- (void)showIconActionSheet;
- (void)hideIconActionSheet;

@end
