//
//  MCMapCalculateFunc.h
//  MCRun
//
//  Created by moshuqi on 16/1/15.
//  Copyright © 2016年 msq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MAMapKit/MAMapKit.h>

@class MCMapAnnotation;

@interface MCMapCalculateFunc : NSObject

+ (CGFloat)distanceBetweenAnnotation1:(MCMapAnnotation *)annotation1
                          annotation2:(MCMapAnnotation *)annotation2;
+ (CGFloat)distanceBetweenCoordinate1:(CLLocationCoordinate2D)coordinate1
                          coordinate2:(CLLocationCoordinate2D)coordinate2;

+ (CGFloat)totalDistance:(NSArray<MCMapAnnotation *> *)annotationArray;
+ (CGFloat)calculateSpeedWithTime:(NSInteger)time
                  annotationArray:(NSArray<MCMapAnnotation *> *)annotationArray;

+ (void)addAnnotationArray:(NSArray<MCMapAnnotation *> *)annotationArray
               toMapView:(MAMapView *)mapView;

+ (NSArray *)getLastObjectsFromArray:(NSArray *)fromArray
                     numberOfObjects:(NSInteger)number;

@end
