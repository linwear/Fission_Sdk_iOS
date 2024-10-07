//
//  FBContactModel.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2022/6/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 常用联系人信息｜Frequently used contact information
 */
@interface FBContactModel : NSObject

/**
 联系人姓名（长度小于或等于64个字节，超出最大长度，自动截取）｜Contact name (less than or equal to 64 bytes in length, automatically intercepted if the maximum length is exceeded)
 */
@property (nonatomic, copy) NSString *contactName;

/**
 号码归属地（长度小于或等于64个字节，超出最大长度，自动截取）｜Number location (if the length is less than or equal to 64 bytes, it will be automatically intercepted if the maximum length is exceeded)
 */
@property (nonatomic, copy) NSString *numberLocation;

/**
 联系人号码（长度小于或等于20个字节，超出最大长度，自动截取）｜Contact number (less than or equal to 20 bytes in length, automatically intercepted if the maximum length is exceeded)
 */
@property (nonatomic, copy) NSString *contactNumber;

@end

NS_ASSUME_NONNULL_END
