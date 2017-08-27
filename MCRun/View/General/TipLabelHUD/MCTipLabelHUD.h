//
//  MCTipLabelHUD.h
//  MCRun
//
//  Created by moshuqi on 15/10/22.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MCTipLabelHUD : NSObject 

+ (instancetype)shareTipLabelHUD;
- (void)showTipWithText:(NSString *)text;

@end
