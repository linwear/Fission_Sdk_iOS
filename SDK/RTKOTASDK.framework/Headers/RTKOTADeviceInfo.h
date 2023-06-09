//
//  RTKOTADeviceInfo.h
//  RTKOTASDK
//
//  Created by jerome_gu on 2020/3/9.
//  Copyright © 2022 Realtek. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef RTK_SDK_IS_STATIC_LIBRARY
#import "libRTKLEFoundation.h"
#import "RTKOTAUpgradeBin.h"
#else
#import <RTKLEFoundation/RTKLEFoundation.h>
#import <RTKOTASDK/RTKOTAUpgradeBin.h>
#endif

/// Values that indicate comunication protocol a device may implement.
typedef enum : NSUInteger {
    RTKOTAProtocolType_NA           =   0x0000,     ///< Old type for Bumblebee, GATT and SPP are supported.
    RTKOTAProtocolType_Bumblebee    =   0x0010,     ///< For Bumblebee, GATT is supported.
    RTKOTAProtocolType_Bumblebee2   =   0x0011,     ///< For Bumblebee, SPP is supported.
    RTKOTAProtocolType_Bee          =   0x0012,
    RTKOTAProtocolType_Ali          =   0x0013,
    RTKOTAProtocolType_Watch        =   0x0014,
    RTKOTAProtocolType_0015         =   0x0015,
    
    RTKOTAProtocolTypeGATTSPP       =   RTKOTAProtocolType_NA,
    RTKOTAProtocolTypeGATT          =   RTKOTAProtocolType_Bumblebee,
    RTKOTAProtocolTypeSPP           =   RTKOTAProtocolType_Bumblebee2,
} RTKOTAProtocolType;


/**
 * Values that represent the ear bud information about the remote device.
 */
typedef enum : NSUInteger {
    RTKOTAEarbudUnkown,     ///< The earbud info is not known.
    RTKOTAEarbudPrimary,    ///< The earbud is primary bud.
    RTKOTAEarbudSecondary,  ///< The earbud is secondary bud.
    RTKOTAEarbudSingle,     ///< The earbud is a single bud.
} RTKOTAEarbud;


/**
 * Values that represent the bank info about the remote device.
 */
typedef enum : NSInteger {
    RTKOTABankTypeInvalid   =   -1, ///< The bank info is not valid.
    RTKOTABankTypeSingle    = 0x00, ///< A single bank.
    RTKOTABankTypeBank0,            ///< The primary Bank in a dual bank case.
    RTKOTABankTypeBank1,            ///< The secondary Bank in a dual bank case.
} RTKOTABankType;

/**
 * Values that represent the encryption method used for image byte encryption.
 */
typedef enum : NSInteger {
    RTKOTAImageDataEncryptionMethod_first16Bytes,   ///< Encrypt first 16 bytes of a image byte packet.
    RTKOTAImageDataEncryptionMethod_allBytes,       ///< Encrypt all bytes of a image byte packet.
} RTKOTAImageDataEncryptionMethod;



NS_ASSUME_NONNULL_BEGIN

/**
 * A collection of information about the device to be upgraded.
 *
 * @discussion Use an @c RTKOTADeviceInfo object to access information about configurations of the device and how to upgrade the device. You get an @c RTKOTADeviceInfo object when succeed in calling @c -getOTAInformationWithCompletionHandler: on a @c RTKDFURoutine conformed object. Do not create @c RTKOTADeviceInfo objects directly.
 *
 *  An @c RTKDFUUpgrade uses information of this class object when upgrading device.
 */
@interface RTKOTABaseDeviceInfo : NSObject

/**
 * The protocol type this device implement.
 */
@property (readonly) RTKOTAProtocolType protocolType;

/**
 * Returns the DFU implementation version number of a device.
 */
@property (readonly) NSUInteger OTAVersion;

/// The security version of the device.
@property (readonly) NSUInteger securityVersion;

/**
 * Returns the size in bytes of temp buffer section used for upgrade.
 *
 * @discussion The value unit is 4k.
 */
@property (readonly) NSUInteger tempBufferSize;

/**
 * Returns which bank the device used currently.
 *
 * @discussion A device which could be able to be upgraded supports either "Bank Switching" or "Temp area memory" manner, can be determined by this property value. If the value is @c RTKOTABankTypeSingle, the device uses "Temp area memory". If this value is @c RTKOTABankTypeBank0 or @c RTKOTABankTypeBank1 , device uses "Bank Switching" manner. When upgrading a "Bank Switching" device, images bytes will be saved at the bank current not used.
 */
@property (readonly) RTKOTABankType activeBank;

/**
 * Returns a boolean value that indicating whether "Buffer Check" mechanism is enabled by device.
 *
 * @discussion This is used for image bytes transmission.
 */
@property (readonly) BOOL bufferCheckEnable;

/**
 * Returns a boolean value that indicating whether "AES encryption" is supported by device.
 *
 * @discussion This is used for image bytes transmission.
 */
@property (readonly) BOOL AESEnable;

/**
 * Returns the encryption mode that controls how bytes are encrypted when they are sent to device.
 *
 * @discussion This is used for image bytes transmission.
 */
@property (readonly) RTKOTAImageDataEncryptionMethod encryptionMode;


@property (readonly) BOOL copyImage;

/**
 * Returns a boolean value that indicating whether device can receive multiple images at a time.
 *
 * @discussion This is used for image bytes transmission.
 */
@property (readonly) BOOL updateMultiImages;

/**
 * Returns a boolean value that indicating whether the device supports normal OTA.
 *
 * @discussion This is used for image bytes transmission.
 */
@property (readonly) BOOL supportNormalOTA;

/**
 * Indicates whether the device can upgrade VP. (For AT)
 *
 * @discussion If this value is @c YES,  you could set  @c upgradeMode to RTKOTAUpgradeMode_updateVPData.
 */
@property (nonatomic, readonly) BOOL canUpdateVP;

/**
 * Indicates whether the device can upgrade in VP ID mode. (For AT)
 *
 * @discussion If this value is @c YES,  you could set  @c upgradeMode to RTKOTAUpgradeMode_updateVPData.
 */
@property (nonatomic, readonly) BOOL canUpdateVPID;

/**
 * Returns the offset of DFU Header.
 */
@property (readonly) NSUInteger headerOffset;


/* RWS Upgrade related properties */
/**
 * Returns a boolean value indicating whether the device is one of RWS pair.
 *
 * @discussion If this property value is @c YES , to start upgrade, you call @c -upgradeWithImagesForPrimaryBud:imagesForSecondaryBud: or @c -upgradeWithBinaryFileAtPath: with file containing images for both primary and secondary bud.
 */
@property (readonly) BOOL isRWSMember;

/**
 * Returns the bud type of a device.
 *
 * @discussion If @c isRWSMember return @c YES , the value of this property should be either @c RTKOTAEarbudPrimary or @c RTKOTAEarbudSecondary .
 */
@property (readonly) RTKOTAEarbud budType;

/**
 * Returns a boolean value indicating whether the device is in engaged with companion device.
 *
 * @discussion If this value is @c YES , when you call upgrade methods on @c RTKDFUUpgrade object, both the pair of devices will be upgraded at a time.
 */
@property (readonly) BOOL engaged;


/**
 * Indicates whether this device has received images right now, but not be activated.
 */
@property (readonly) BOOL upgradedCurrently;

/**
 * Indicates whether this device supports test mode.
 */
@property (readonly) BOOL supportTest;

@end


/**
 * An @c RTKOTABaseDeviceInfo subclass containing additional informations of the device.
 *
 * @discussion An @c RTKDFUUpgrade object creates this object when be ready for upgrading a device.
 */
@interface RTKOTADeviceInfo : RTKOTABaseDeviceInfo

/**
 * Returns the address value of a device.
 */
@property (readonly) BDAddressType bdAddress;

/**
 * Returns the address value of the companion device.
 *
 * @discussion Returns BDAddressNull if the device is not a member of RWS pair.
 */
@property (readonly) BDAddressType companionBDAddress;

/**
 * Returns a list of images that is installed in remote device.
 *
 * @discussion You can use this property to access what type and what version of images are installed at connected device.
 */
@property (readonly) NSArray <RTKOTABin*> *bins;

/**
 * Returns the buffer size for sending image bytes.
 *
 * @discussion The value is 0 if the value is not determined.
 */
@property (readonly) NSUInteger maxBufferSize;

/**
 * Returns a list of images that is installed in the inactive bank.
 *
 * @discussion You can use this property to access what type and what version of images are installed in the inactive bank.
 */
@property (readonly) NSArray <RTKOTABin*> *inactiveBins;
@end


@interface RTKOTADeviceInfo (ImageVerification)

/**
 * Check the images and return a boolean value that indicates if those images are valid to be upgraded to device.
 *
 * @discussion This method will check if the image is older version.
 * @see -isAvailableForUpgradeOfImages:checkingImageVersion:YES usingStrictMechanism:inVPMode:withActiveVPID:returnError:
 */
- (BOOL)isAvailableForUpgradeOfImages:(NSArray <RTKOTAUpgradeBin*> *)images
                 usingStrictMechanism:(BOOL)usingStrict
                             inVPMode:(BOOL)isVPmode
                       withActiveVPID:(uint16_t)VPID
                          returnError:(NSError **)error;

/**
 * Check the images and return a boolean value that indicates if those images are valid to be upgraded to device.
 *
 * @param images The images to be checked. The images could be returned by calling @c RTKOTAUpgradeBin image extract methods.
 * @param yesOrNo Indicating whether old image is allowed.
 * @param usingStrict Indicating whether to use a strict check policy (It is meaningful only when old image is not allowed)
 * @param isVPMode Indicating whether the upgradeMode is RTKOTAUpgradeMode_updateVPData
 * @param VPID The active VPID of VP image (It is meaningful only when the upgradeMode is RTKOTAUpgradeMode_updateVPData)
 * @param error A @c NSError object pointer used to return a error object if the check fails.
 *
 * @return @c YES if the passed images could be upgraded, @c NO otherwise.
 * @discussion This method check each member of @c images, confirming if each image matches the device and passes the version rule. If check failed, this method returns @c NO, and the @c error pointer is set to a error object describing the cause.
 *
 * Before calling upgrade methods to start upgrade, you can call this method to check if your images are able to be upgraded. If you call upgrade methods with unavailable images, @c RTKDFUUpgrade will report upgrade failure immediately.
 *
 * Use this method for device that is not a member of RWS pair.
 *
 * @see -isAvailableForUpgradeOfImages:returnError:
 */
- (BOOL)isAvailableForUpgradeOfImages:(NSArray <RTKOTAUpgradeBin*> *)images
                 checkingImageVersion:(BOOL)yesOrNo
                 usingStrictMechanism:(BOOL)usingStrict
                             inVPMode:(BOOL)isVPMode
                       withActiveVPID:(uint16_t)VPID
                          returnError:(NSError **)error;


/**
 * Check the images and return a boolean value that indicates if those images are valid to be upgraded to device.
 *
 * @see -isAvailableForUpgradeOfImagesForPrimaryBud:imagesForSecondaryBud:checkingImageVersion:YES usingStrictMechanism:inVPMode:withActiveVPID:returnError:
 */
- (BOOL)isAvailableForUpgradeOfImagesForPrimaryBud:(NSArray <RTKOTAUpgradeBin*> *)imagesForPrimary
                             imagesForSecondaryBud:(NSArray <RTKOTAUpgradeBin*> *)imagesForSecondary
                              usingStrictMechanism:(BOOL)usingStrict
                                          inVPMode:(BOOL)isVPmode
                                    withActiveVPID:(uint16_t)VPID
                                       returnError:(NSError **)error;

/**
 * Check the images and return a boolean value that indicates if those images are valid to be upgraded to device.
 *
 * @param imagesForPrimary The images for primary bud to be checked. The images could be returned by calling @c RTKOTAUpgradeBin image extract methods.
 * @param imagesForSecondary The images for secondary bud to be checked. The images could be returned by calling @c RTKOTAUpgradeBin image extract methods.
 * @param error A @c NSError object pointer used to return a error object if the check fails.
 * @return @c YES if the passed images could be upgraded, @c NO otherwise.
 * @discussion This method check each image of @c primaryImages and @c secondaryImages , confirming if each image matches the device and passes the version rule. If check failed, this method returns @c NO, and the @c error pointer is set to a error object describing the cause.
 *
 * Before calling upgrade methods to start upgrade, you can call this method to check if your images are able to be upgraded. If you call upgrade methods with unavailable images, @c RTKDFUUpgrade will report upgrade failure immediately.
 *
 */
- (BOOL)isAvailableForUpgradeOfImagesForPrimaryBud:(NSArray <RTKOTAUpgradeBin*> *)imagesForPrimary
                             imagesForSecondaryBud:(NSArray <RTKOTAUpgradeBin*> *)imagesForSecondary
                              checkingImageVersion:(BOOL)yesOrNo
                              usingStrictMechanism:(BOOL)usingStrict
                                     inVPMode:(BOOL)isVPmode
                                    withActiveVPID:(uint16_t)VPID
                                       returnError:(NSError **)error;

/**
 * Compare the bank information of the images and device, select and return the applicable images for upgrade.
 *
 * @param images The images to be selected. Should pass @c -isAvailableForUpgradeOfImages: method. The images could be returned by calling @c RTKOTAUpgradeBin image extract methods.
 * @discussion For a device supporting "Dual Bank" feature, and images applying to both Bank are provided, only images for current unused bank will be actually sent to this device. This method returns those available images.
 * For a device not supporting "Dual Bank", the images you passed should not applying to "Dual Bank" device.
 *
 * Typically, this method returns a subset of the passed @c images .
 */
- (NSArray <RTKOTAUpgradeBin*> *)applicableImagesSelectedFromImages:(NSArray <RTKOTAUpgradeBin*> *)images;

/**
 * Compare the bank information and bud type of the images and device, select and return the applicable images for upgrade.
 *
 * @param imagesForPrimary The images for primary bud to be selected. Should pass @c -isAvailableForUpgradeOfImagesForPrimaryBud:imagesForSecondaryBud: method. The images could be returned by calling @c RTKOTAUpgradeBin image extract methods.
 * @param imagesForSecondary The images for secondary bud to be selected. Should pass @c -isAvailableForUpgradeOfImagesForPrimaryBud:imagesForSecondaryBud: method. The images could be returned by calling @c RTKOTAUpgradeBin image extract methods.
 * @discussion Additional to what @c -applicableImagesSelectedFromImages: does, this method considers what bud type this device is, and returns only images applying to this bud type.
 *
 * Typically, this method returns a subset of the passed @c primaryImages or @c secondaryImages .
 */
- (NSArray <RTKOTAUpgradeBin*> *)applicableImagesSelectedFromImagesForPrimaryBud:(NSArray <RTKOTAUpgradeBin*> *)imagesForPrimary
                                                           imagesForSecondaryBud:(NSArray <RTKOTAUpgradeBin*> *)imagesForSecondary;

@end


NS_ASSUME_NONNULL_END
