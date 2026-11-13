//
//  FBNFCCardModel.h
//  FissionBluetooth
//
//  Created by LINWEAR on 2025-07-18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 NFC卡片信息｜NFC card information
 */
@interface FBNFCCardModel : NSObject

/**
 卡片类型｜Card Type
 */
@property (nonatomic, assign) FB_NFCTYPE type;

/**
 UID
 */
@property (nonatomic, copy) NSString *uid;

/**
 ATQA
 */
@property (nonatomic, assign) NSInteger atqa;

/**
 SAK
 */
@property (nonatomic, assign) NSInteger sak;

/**
 卡片名称(长度最大 20 字节)｜Card Name (Maximum length: 20 bytes)
 */
@property (nonatomic, copy) NSString *name;

/**
 卡片背景图ID｜Card background image ID
 */
@property (nonatomic, assign) NSInteger bgImgId;

/**
 卡片数据｜Card data
 */
@property (nonatomic, strong, nullable) NSData *data;

@end

NS_ASSUME_NONNULL_END
