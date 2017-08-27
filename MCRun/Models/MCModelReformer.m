//
//  MCModelReformer.m
//  MCRun
//
//  Created by moshuqi on 15/10/28.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "MCModelReformer.h"
#import "MCRunDatabaseModel.h"
#import "MCRunInfoModel.h"
#import "MCUserDatabaseModel.h"
#import "MCUserInfoResponseModel.h"
#import <CoreLocation/CoreLocation.h>
#import "MCMapAnnotation.h"

#import "MCDataRecordModel.h"
#import "MCHeartRateDataTransformModel.h"
#import "MCLocationDataTransformModel.h"
#import "MCCalorieCalculateFunc.h"

// 用来封装各种model之间的转换

@implementation MCModelReformer

+ (MCRunDatabaseModel *)runDatabaseModelFromRunInfoModel:(MCRunInfoModel *)runInfoModel
{
    MCRunDatabaseModel *runDatabaseModel = [MCRunDatabaseModel new];
    
    NSString *uid = (runInfoModel.uid == nil) ? (NSString *)[NSNull null] : runInfoModel.uid;
    runDatabaseModel.uid = uid;
    runDatabaseModel.date = [MCModelReformer stringFromDate:runInfoModel.date];
    runDatabaseModel.bdate = runInfoModel.beginTime;
    runDatabaseModel.edate = runInfoModel.endTime;
    runDatabaseModel.usetime = runInfoModel.useTime;
    runDatabaseModel.lSpeed = runInfoModel.lSpeed;
    runDatabaseModel.hSpeed = runInfoModel.hSpeed;
    runDatabaseModel.speed = runInfoModel.speed;
    runDatabaseModel.pace = runInfoModel.pace;
    runDatabaseModel.distance = runInfoModel.distance;
    runDatabaseModel.star = runInfoModel.star;
    
    CGFloat calorie = [MCCalorieCalculateFunc calculateCalorieWithWeight:65 distance:(runInfoModel.distance / 1000)];
    
    runDatabaseModel.cost = calorie;
    
    MCHeartRateDataTransformModel *heartRateDataTransform = [[MCHeartRateDataTransformModel alloc] initWithDataArray:runInfoModel.heartRateArray];
    runDatabaseModel.heartRateDataString = heartRateDataTransform.dataString;
    
    MCLocationDataTransformModel *locationDataTransform = [[MCLocationDataTransformModel alloc] initWithDataArray:runInfoModel.locationArray];
    runDatabaseModel.locationDataString = locationDataTransform.dataString;
    
    return runDatabaseModel;
}

+ (MCUserDatabaseModel *)userDatabaseModelFromUserInfoResponseModel:(MCUserInfoResponseModel *)userInfoResponse
{
    MCUserDatabaseModel *userDatabaseModel = [MCUserDatabaseModel new];
    
    userDatabaseModel.uid = userInfoResponse.uid;
    userDatabaseModel.phone = userInfoResponse.phone;
    userDatabaseModel.nickname = userInfoResponse.nickname;
    userDatabaseModel.birthday = userInfoResponse.birthday;
    userDatabaseModel.headimg = userInfoResponse.headimg;
    
    // Response里不包含lasttime
    userDatabaseModel.lasttime = (NSString *)[NSNull null];
    
    userDatabaseModel.age = ([userInfoResponse.age isKindOfClass:[NSNull class]]) ? 0 : [userInfoResponse.age integerValue];
    userDatabaseModel.sex = ([userInfoResponse.sex isKindOfClass:[NSNull class]]) ? 0 : [userInfoResponse.sex integerValue];
    userDatabaseModel.height = ([userInfoResponse.height isKindOfClass:[NSNull class]]) ? 0 : [userInfoResponse.height integerValue];
    
    return userDatabaseModel;
}

+ (MCDataRecordModel *)dataRecordModelFromRunDatabaseModel:(MCRunDatabaseModel *)runDatabaseModel
{
    MCDataRecordModel *heartRateModel = [MCDataRecordModel new];
    
    heartRateModel.startTime = runDatabaseModel.bdate;
    heartRateModel.endTime = runDatabaseModel.edate;
    heartRateModel.calorie = runDatabaseModel.cost;
    heartRateModel.distance = runDatabaseModel.distance;
    
    MCHeartRateDataTransformModel *heartRateDataTransform = [[MCHeartRateDataTransformModel alloc] initWithDataString:runDatabaseModel.heartRateDataString];
    heartRateModel.heartRateArray = heartRateDataTransform.dataArray;
    
    MCLocationDataTransformModel *locationDataTransformModel = [[MCLocationDataTransformModel alloc] initWithDataString:runDatabaseModel.locationDataString];
    heartRateModel.locationArray = locationDataTransformModel.dataArray;
    
    return heartRateModel;
}

+ (MCDataRecordModel *)dataRecordModelFromRunInfoModel:(MCRunInfoModel *)runInfoModel
{
    MCRunDatabaseModel *runDatabaseModel = [MCModelReformer runDatabaseModelFromRunInfoModel:runInfoModel];
    MCDataRecordModel *recordModel = [MCModelReformer dataRecordModelFromRunDatabaseModel:runDatabaseModel];
    return recordModel;
}

+ (NSString *)stringFromDate:(NSDate *)date
{
    // 将date转换成string
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *destString = [dateFormatter stringFromDate:date];
    return destString;
}

@end
