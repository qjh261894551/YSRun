//
//  MCBLEHint.h
//  MCRun
//
//  Created by moshuqi on 15/11/23.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <Foundation/Foundation.h>



@protocol MCBLEHintDelegate <NSObject>

@required
- (void)BLEConnect;
- (void)runDirectly;

@end

@interface MCBLEHint : NSObject

@property (nonatomic, weak) id<MCBLEHintDelegate> delegate;

- (void)showConnectHint;
- (void)showConnectFailureHint;

@end
