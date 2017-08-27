//
//  MCTimeLocationArray.h
//  MCRun
//
//  Created by moshuqi on 16/1/26.
//  Copyright © 2016年 msq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MCTimeLocationArray : NSObject

- (id)initWithLocationArray:(NSArray *)locationArray
             timestampArray:(NSArray *)timestampArray;

- (BOOL)hasTimeData;
- (NSArray *)getDataArray;

@end
