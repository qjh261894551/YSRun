//
//  MCRegisterInfoRequestModel.h
//  MCRun
//
//  Created by moshuqi on 15/10/25.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MCRegisterInfoRequestModel : NSObject

@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *pwd;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, strong) NSData *photoData;

@end
