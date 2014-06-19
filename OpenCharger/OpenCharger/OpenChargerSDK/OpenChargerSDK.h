//
//  OpenChargerSDK.h
//  OpenCharger
//
//  Created by Yongfeng on 14-5-1.
//  Copyright (c) 2014年 Yongfeng He. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

typedef void (^OCSuccessBlock)(id response, NSError *error);

@interface OpenChargerSDK : NSObject <CBCentralManagerDelegate, CBPeripheralDelegate>

@property (strong, nonatomic) NSMutableArray *peripherals;
@property (strong, nonatomic) CBCentralManager *cm;
@property (strong, nonatomic) CBPeripheral *activePeripheral;

- (void)writeValue:(CBUUID *)serviceUUID characteristicUUID:(CBUUID *)characteristicUUID  p:(CBPeripheral *)p data:(NSData *)data;
- (void)readValue:(CBUUID *)serviceUUID characteristicUUID:(CBUUID *)characteristicUUID  p:(CBPeripheral *)p;
- (void)notification:(CBUUID *)serviceUUID characteristicUUID:(CBUUID *)characteristicUUID  p:(CBPeripheral *)p on:(BOOL)on;

- (UInt16)swap:(UInt16)s;
- (int)controlSetup;
- (int)findBLEPeripherals:(int)timeout;
- (const char *)centralManagerStateToString:(int)state;
- (void)scanTimer:(NSTimer *)timer;
- (void)printKnownPeripherals;
- (void)printPeripheralInfo:(CBPeripheral*)peripheral;
- (void)connectPeripheral:(CBPeripheral *)peripheral;

- (CBService *)findServiceFromUUID:(CBUUID *)UUID p:(CBPeripheral *)p;
- (CBCharacteristic *)findCharacteristicFromUUID:(CBUUID *)UUID service:(CBService*)service;
- (const char *)UUIDToString:(CFUUIDRef)UUID;
- (const char *)CBUUIDToString:(CBUUID *)UUID;
- (int)compareCBUUID:(CBUUID *)UUID1 UUID2:(CBUUID *)UUID2;
- (int)compareCBUUIDToInt:(CBUUID *)UUID1 UUID2:(UInt16)UUID2;
- (UInt16)CBUUIDToInt:(CBUUID *)UUID;
- (int)UUIDSAreEqual:(CFUUIDRef)u1 u2:(CFUUIDRef)u2;

- (void)didUpdateValueBlock:(OCSuccessBlock)block;
- (void)didPowerOnBlock:(OCSuccessBlock)block;
- (void)didDiscoverCharacteristicsBlock:(OCSuccessBlock)block;

- (void)disconnectBLEPeripherals:(CBPeripheral*)activePeripheral;

- (void)sendCodeToOpenCharger: (CBPeripheral *) thisPeripheral openChargerCode:(NSString *)openCharger chargeTime:(NSString *)chargeTime;
- (void)turnOffOpenCharger: (CBPeripheral *) thisPeripheral;

@end
