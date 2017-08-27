//
//  MCModifyPasswordRequestModel.h
//  MCRun
//
//  Created by moshuqi on 15/10/25.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MCModifyPasswordRequestModel : NSObject

@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *oldPassword;
@property (nonatomic, copy) NSString *modifiedPassword;

@end
