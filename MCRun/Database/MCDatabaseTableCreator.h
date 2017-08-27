//
//  MCDatabaseTableCreator.h
//  MCRun
//
//  Created by moshuqi on 15/12/29.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FMDatabaseQueue;

@interface MCDatabaseTableCreator : NSObject

- (id)initWithQueue:(FMDatabaseQueue *)queue;
- (void)checkTables;

@end
