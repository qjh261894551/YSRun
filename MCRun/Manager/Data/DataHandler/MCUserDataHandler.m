//
//  MCUserDataHandler.m
//  MCRun
//
//  Created by moshuqi on 15/12/14.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "MCUserDataHandler.h"
#import "MCNetworkManager.h"
#import "MCDataManager.h"
#import "MCDatabaseManager.h"
#import "MCUtilsMacro.h"

@interface MCUserDataHandler () <MCNetworkManagerDelegate>

@end

@implementation MCUserDataHandler

- (void)uploadHeadImage:(UIImage *)headImage
{
    MCNetworkManager *networkManager = [MCNetworkManager new];
    networkManager.delegate = self;
    
    NSString *uid = [[MCDataManager shareDataManager] getUid];
    [networkManager uploadHeadImage:headImage uid:uid];
}

#pragma mark - MCNetworkManagerDelegate

- (void)uploadHeadImageSuccessWithPath:(NSString *)path
{
    // 头像上传成功，修改数据库用户头像的路径，并更新界面。
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        NSString *uid = [[MCDataManager shareDataManager] getUid];
        
        MCDatabaseManager *databaseManager = [MCDatabaseManager new];
        [databaseManager setUser:uid withHeadImagePath:path];
        
        [[MCDataManager shareDataManager] resetData];
        
        if ([self.delegate respondsToSelector:@selector(uploadHeadImageFinish)])
        {
            [self.delegate uploadHeadImageFinish];
        }
    });
}

- (void)uploadHeadImageFailureWithMessage:(NSString *)message
{
    MCLog(@"%@", message);
}

@end
