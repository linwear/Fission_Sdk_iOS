//
//  RLMSportsModel.m
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023/5/11.
//

#import "RLMSportsModel.h"

@implementation RLMSportsModel

- (void)QuickSetup {
    FBFirmwareVersionObject *object = FBAllConfigObject.firmwareConfig;
    self.deviceName = object.deviceName;
    self.deviceMAC  = object.mac;
    self.primaryKey_ID = [NSString stringWithFormat:@"%ld + %@ + %@", self.begin, self.deviceName, self.deviceMAC];
}

@end

@implementation RLMSportsItemModel

@end

@implementation RLMSportsLocationModel

@end
