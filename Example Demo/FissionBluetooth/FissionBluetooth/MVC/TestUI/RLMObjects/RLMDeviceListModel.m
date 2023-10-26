//
//  RLMDeviceListModel.m
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023/5/12.
//

#import "RLMDeviceListModel.h"

@implementation RLMDeviceListModel

- (void)QuickSetup {
    FBFirmwareVersionObject *object = FBAllConfigObject.firmwareConfig;
    self.deviceName = object.deviceName;
    self.deviceMAC  = object.mac;
    self.primaryKey_ID = [NSString stringWithFormat:@"%@ + %@", self.deviceName, self.deviceMAC];
}

@end
