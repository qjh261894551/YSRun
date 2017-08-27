//
//  MCUserDataHandler.h
//  MCRun
//
//  Created by moshuqi on 15/12/14.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MCUserDataHandlerDelegate <NSObject>

@optional
- (void)uploadHeadImageFinish;

@end

@class UIImage;

@interface MCUserDataHandler : NSObject

@property (nonatomic, weak) id<MCUserDataHandlerDelegate> delegate;

- (void)uploadHeadImage:(UIImage *)headImage;

@end
