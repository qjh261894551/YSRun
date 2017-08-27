//
//  MCContentCheckIconChange.h
//  MCRun
//
//  Created by moshuqi on 16/1/13.
//  Copyright © 2016年 msq. All rights reserved.
//

#import "MCContentCheck.h"

@protocol MCContentCheckIconChangeDelegate <NSObject>

@optional
- (void)needChangeTextField:(UITextField *)textField textEmpty:(BOOL)isEmpty;

@end

@interface MCContentCheckIconChange : MCContentCheck

- (id)initWithDelegate:(id<MCContentCheckIconChangeDelegate>)delegate;

@end
