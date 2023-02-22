//
//  DeviceListModel.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2022/12/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DeviceListModel : NSObject

@property (nonatomic, assign) BOOL isPair;
@property (nonatomic, copy) NSString * device_Name;
@property (nonatomic, copy) NSString * mac_Address;
@property (nonatomic, copy) NSString * adapt_Number;
@property (nonatomic, strong) CBPeripheral * peripheral;
@property (nonatomic, strong) NSDictionary * advertisementData;
@property (nonatomic, strong) NSNumber * RSSI;

@end

NS_ASSUME_NONNULL_END
