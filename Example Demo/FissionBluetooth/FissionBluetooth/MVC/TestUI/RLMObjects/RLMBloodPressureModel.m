//
//  RLMBloodPressureModel.m
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023/5/11.
//

#import "RLMBloodPressureModel.h"

@implementation RLMBloodPressureModel

- (void)QuickSetup {
    FBFirmwareVersionObject *object = FBAllConfigObject.firmwareConfig;
    self.deviceName = object.deviceName;
    self.deviceMAC  = object.mac;
    self.primaryKey_ID = [NSString stringWithFormat:@"%ld + %@ + %@", self.begin, self.deviceName, self.deviceMAC];
}

@end
