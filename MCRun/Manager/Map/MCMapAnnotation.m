//
//  MCMapAnnotation.m
//  MCRun
//
//  Created by moshuqi on 15/11/10.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "MCMapAnnotation.h"

@implementation MCMapAnnotation

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    self = [super init];
    if (self)
    {
        _coordinate = coordinate;
    }
    
    return self;
}

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate
{
    _coordinate = newCoordinate;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"latitude = %f, longitude = %f", _coordinate.latitude, _coordinate.longitude];
}

@end
