//
//  FBEphemerisManager.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023-12-19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FBEphemerisManager : NSObject

+ (FBEphemerisManager *)sharedInstance;

- (void)requestEphemerisDataWithBlock:(void(^)(NSData  * _Nullable binData, NSString  * _Nullable errorString))ephemerisBlock;

@end


@interface FBEphemerisModel : NSObject

/** GPS+Glonass数据｜GPS+Glonass data */
@property (nonatomic, copy) NSString *GPS_Glonass_Url;

/** 北斗系统数据｜Beidou system data */
@property (nonatomic, copy) NSString *Beidou_Url;

/** 伽利略系统数据｜Galileo system data */
@property (nonatomic, copy) NSString *Galileo_Url;

@end

NS_ASSUME_NONNULL_END
