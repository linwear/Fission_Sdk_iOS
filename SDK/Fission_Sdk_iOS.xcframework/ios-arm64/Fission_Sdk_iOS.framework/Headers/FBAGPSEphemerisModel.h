//
//  FBAGPSEphemerisModel.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023-12-18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 AGPS星历数据信息｜AGPS ephemeris data information
*/
@interface FBAGPSEphemerisModel : NSObject

/** GPS+Glonass数据｜GPS+Glonass data */
@property (nonatomic, strong) NSData *GPS_Glonass;

/** 北斗系统数据｜Beidou system data */
@property (nonatomic, strong) NSData *Beidou;

/** 伽利略系统数据｜Galileo system data */
@property (nonatomic, strong) NSData *Galileo;

@end

NS_ASSUME_NONNULL_END
