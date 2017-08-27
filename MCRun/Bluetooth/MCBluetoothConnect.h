//
//  MCBluetoothConnect.h
//  MCRun
//
//  Created by moshuqi on 15/11/9.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MCBluetoothConnectHeartRateKey  @"heartRate"

@protocol MCBluetoothConnectDelegate <NSObject>

@required
- (void)centralManagerNotPoweredOnWithMessage:(NSString *)message;
- (void)updateWithHeartRate:(NSInteger)heartRate;

@end

typedef void (^MCBLEConnectPeripheralStateBlock)(BOOL connectState);
typedef void (^MCExameBluetoothStateBlock)(BOOL isPowerOn);

@interface MCBluetoothConnect : NSObject

@property (nonatomic, weak) id<MCBluetoothConnectDelegate> delegate;

+ (instancetype)shareBluetoothConnect;
- (BOOL)hasConnectPeripheral;
- (void)connectPeripheralWithStateCallback:(MCBLEConnectPeripheralStateBlock)connectStateCallback
                           examBLECallback:(MCExameBluetoothStateBlock)examCallback;

- (void)addHeartRateObserver:(id)observer;
- (void)removeHeartRateObserver:(id)observer;

- (NSArray *)getHeartRateData;
- (void)clearHeartRateData;

@end
