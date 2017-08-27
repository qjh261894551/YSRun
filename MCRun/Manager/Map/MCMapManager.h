//
//  MCMapManager.h
//  MCRun
//
//  Created by moshuqi on 15/10/18.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MAMapKit/MAMapKit.h>

@protocol MCMapManagerDelegate <NSObject>

@required
- (void)updateDistance:(CGFloat)distance;

@end

@interface MCMapManager : NSObject

@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, weak) id<MCMapManagerDelegate> delegate;

@property (nonatomic, strong) UILabel *testLabel;   // 显示数据的标签

- (void)testRoute;
- (void)setupMapView;
- (void)startLocation;
- (void)endLocation;

- (CGFloat)getHighestSpeed;
- (CGFloat)getLowestSpeed;
- (CGFloat)getTotalDistance;
- (NSArray *)getCoordinateRecord;

@end
