//
//  MCEditingCheckLengthLimit.h
//  MCRun
//
//  Created by moshuqi on 16/1/13.
//  Copyright © 2016年 msq. All rights reserved.
//

#import "MCEditingCheck.h"

@protocol MCEditingCheckLengthLimitDelegate <NSObject>

@optional
- (void)beyondMaxLimit;

@end

@interface MCEditingCheckLengthLimit : MCEditingCheck

- (id)initWithMaxLimit:(NSInteger)maxLimit
              delegate:(id<MCEditingCheckLengthLimitDelegate>)delegate;

@end
