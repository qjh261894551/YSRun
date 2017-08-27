//
//  MCPaceCalculateFunc.h
//  MCRun
//
//  Created by moshuqi on 16/1/26.
//  Copyright © 2016年 msq. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MCTimeLocationArray;

@interface MCPaceCalculateFunc : NSObject

- (id)initWithTimeLocationArray:(MCTimeLocationArray *)timeLocationArray
                        useTime:(NSInteger)useTime;

- (NSArray *)getPaceSectionDataArray;

@end
