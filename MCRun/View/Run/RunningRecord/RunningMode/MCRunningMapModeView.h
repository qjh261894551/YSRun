//
//  MCRunningMapModeView.h
//  MCRun
//
//  Created by moshuqi on 15/10/19.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "MCRunningModeView.h"

@class MCMapManager;

@interface MCRunningMapModeView : MCRunningModeView

- (MCMapManager *)getMapManager;
- (void)setupMap;
- (void)mapLocation;

@end
