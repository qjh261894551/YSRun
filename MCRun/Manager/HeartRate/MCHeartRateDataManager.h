//
//  MCHeartRateDataManager.h
//  MCRun
//
//  Created by moshuqi on 15/12/1.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MCHeartRateDataManager : NSObject

- (void)addHeartRate:(NSInteger)heartRate;
- (NSArray *)getHeartRateDataArray;
+ (double)efficientProportionWithHeartRateArray:(NSArray *)heartRateArray;

@end
