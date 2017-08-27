//
//  MCLocationDataTransformModel.m
//  MCRun
//
//  Created by moshuqi on 15/11/27.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "MCLocationDataTransformModel.h"
#import "MCMapAnnotation.h"
#import "MCUtilsMacro.h"

@implementation MCLocationDataTransformModel

- (NSString *)separatedString
{
    // 位置信息以“纬度|经度，纬度|经度”格式用字符串进行数据库的存储，取出时通过“,”进行数据拆分
    return @",";
}

- (NSArray *)getDataArrayWithComponents:(NSArray *)components
{
    // dataArray包含的是位置MCMapAnnotation数据
    NSMutableArray *array = [NSMutableArray array];
    for (NSString *string in components)
    {
        // string保存的为“纬度|经度”，通过“|”进行拆分
        NSArray *comps = [string componentsSeparatedByString:@"|"];
        if ([comps count] == 2)
        {
            // 纬度
            NSString *latitudeStr = comps[0];
            double latitude = [latitudeStr doubleValue];
            
            // 经度
            NSString *longitudeStr = comps[1];
            double longitude = [longitudeStr doubleValue];
            
            CLLocationCoordinate2D coordinate = {latitude, longitude};
            MCMapAnnotation *annotation = [[MCMapAnnotation alloc] initWithCoordinate:coordinate];
            [array addObject:annotation];
        }
        else
        {
            MCLog(@"字符串格式不为 “纬度|经度” ");
        }
    }
    
    return array;
}

- (NSString *)getDataStringWithArray:(NSArray *)array
{
    // 将MCMapAnnotation数据数组，转化成“纬度|经度，纬度|经度”格式的字符串
    NSMutableString *dataString = [NSMutableString string];
    if ([array count] > 0)
    {
        MCMapAnnotation *annotation = [array firstObject];
        NSString *string = [self locationStringFromAnnotation:annotation];
        [dataString appendString:string];
        
        for (NSInteger i = 1; i < [array count]; i++)
        {
            annotation = array[i];
            string = [NSString stringWithFormat:@",%@", [self locationStringFromAnnotation:annotation]];
            [dataString appendString:string];
        }
    }
    else
    {
        MCLog(@"array数组元素为空！");
        return nil;
    }
    
    return dataString;
}

- (NSString *)locationStringFromAnnotation:(MCMapAnnotation *)annotation
{
    // "纬度|经度" 格式
    CLLocationCoordinate2D coordinate = annotation.coordinate;
    NSString *locationString = [NSString stringWithFormat:@"%f|%f", coordinate.latitude, coordinate.longitude];
    
    return locationString;
}

@end
