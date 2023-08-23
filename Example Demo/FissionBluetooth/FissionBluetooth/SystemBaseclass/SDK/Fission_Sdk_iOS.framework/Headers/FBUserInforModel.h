//
//  FBUserInforModel.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2021/2/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/*
 用户个人信息｜User personal information
*/
@interface FBUserInforModel : NSObject

/**
 用户ID（大于0，小于0xFFFFFFFF）｜User ID (greater than 0, less than 0xFFFFFF)
 */
@property (nonatomic, assign) NSInteger userId;

/**
 用户昵称（长度小于或等于31个字节，用户昵称超出最大长度，自动截取）｜User nickname (the length is less than or equal to 31 bytes, and the user nickname exceeds the maximum length, automatically intercepted)
 */
@property (nonatomic, copy) NSString *userNickname;

/**
 用户身高（单位cm，大于100，小于250）｜User's height (in cm, greater than 100, less than 250)
 */
@property (nonatomic, assign) NSInteger userHeight;

/**
 用户体重（单位kg， 大于30，  小于250）｜User's weight (in kg, more than 30, less than 250)
 */
@property (nonatomic, assign) NSInteger userWeight;

/**
 时区偏移时间（分钟）｜Time zone offset time (minutes)
 */
@property (nonatomic, assign) NSInteger userTimeZoneMinute;

/**
 用户性别｜User gender
 */
@property (nonatomic, assign) FB_USERGENDER UserGender;

/**
 用户年龄（大于5岁，小于130岁）｜User age (over 5, under 130)
 */
@property (nonatomic, assign) NSInteger userAge;

/**
 用户步幅（单位cm）｜User stride (in cm)
 */
@property (nonatomic, assign) NSInteger userStride;

/**
 女性生理周期信息｜Female physiological cycle information
 */
@property (nonatomic, strong) FBFemalePhysiologyModel *physiologyModel;

@end

NS_ASSUME_NONNULL_END
