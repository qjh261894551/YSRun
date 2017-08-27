//
//  MCModelReformer.h
//  MCRun
//
//  Created by moshuqi on 15/10/28.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MCRunDatabaseModel;
@class MCRunInfoModel;
@class MCUserDatabaseModel;
@class MCUserInfoResponseModel;
@class MCDataRecordModel;

@interface MCModelReformer : NSObject

+ (MCRunDatabaseModel *)runDatabaseModelFromRunInfoModel:(MCRunInfoModel *)runInfoModel;
+ (MCUserDatabaseModel *)userDatabaseModelFromUserInfoResponseModel:(MCUserInfoResponseModel *)userInfoResponse;
+ (MCDataRecordModel *)dataRecordModelFromRunDatabaseModel:(MCRunDatabaseModel *)runDatabaseModel;
+ (MCDataRecordModel *)dataRecordModelFromRunInfoModel:(MCRunInfoModel *)runInfoModel;
+ (NSString *)stringFromDate:(NSDate *)date;

@end
