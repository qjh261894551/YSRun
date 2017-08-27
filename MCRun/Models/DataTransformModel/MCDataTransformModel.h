//
//  MCDataTransformModel.h
//  MCRun
//
//  Created by moshuqi on 15/11/27.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MCDataTransformModel : NSObject

@property (nonatomic, copy) NSArray *dataArray;
@property (nonatomic, copy) NSString *dataString;

- (id)initWithDataArray:(NSArray *)dataArray;
- (id)initWithDataString:(NSString *)dataString;

@end
