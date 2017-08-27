//
//  MCTimeLocationModel.h
//  MCRun
//
//  Created by moshuqi on 16/1/26.
//  Copyright © 2016年 msq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MAMapKit/MAMapKit.h>

@interface MCTimeLocationModel : NSObject

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, assign) NSInteger timestamp;

@end
