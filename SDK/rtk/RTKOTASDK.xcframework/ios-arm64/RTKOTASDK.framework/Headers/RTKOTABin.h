//
//  RTKOTABin.h
//  RTKOTASDK
//
//  Created by jerome_gu on 2019/4/16.
//  Copyright (c) 2019, Realtek Semiconductor Corporation. All rights reserved.
//
//  SPDX-License-Identifier: LicenseRef-Realtek-5-Clause
//

#import <Foundation/Foundation.h>

#define RTK_DEPRECATED_ENUM(new_name) __attribute__((deprecated("Use " #new_name " instead")))

/// Constants that indicates the type of an image.
///
/// `RTKOTAImageType` constants are defined to support different SOC platforms. The case value is reused for different SOC platform. So when be used to compare, the SOC platform is required.
typedef NS_ENUM(NSUInteger, RTKOTAImageType) {
    RTKOTAImageType_Unknown = 0,
    
    // =======================================================
    // MARK: - New Standard Names (Recommended)
    // =======================================================
    /* Legacy */
    RTKOTAImageType_Patch   = 0x01,     ///< Patch
    RTKOTAImageType_AppBank0,           ///< App in bank 0
    RTKOTAImageType_AppBank1,           ///< App in bank 1
    RTKOTAImageType_Data,               ///< Data
    RTKOTAImageType_PatchExt,           ///< Patch extension
    RTKOTAImageType_Config,             ///< Configuration
    
    RTKOTAImageType_87x2_SOCV_CFG  = 0x01,     ///< SOCV Configuration
    RTKOTAImageType_87x2_SystemConfig,         ///< System Configuration
    RTKOTAImageType_87x2_OTAHeader,            ///< OTA Header
    RTKOTAImageType_87x2_Secure_Boot_Loader,   ///< Secure Boot Loader
    RTKOTAImageType_87x2_ROM_PATCH,            ///< ROM Patch
    RTKOTAImageType_87x2_APP_IMG,              ///< App
    RTKOTAImageType_87x2_APP_DATA1,            ///< App Data 1
    RTKOTAImageType_87x2_APP_DATA2,            ///< App Data 2
    RTKOTAImageType_87x2_APP_DATA3,            ///< App Data 3
    RTKOTAImageType_87x2_APP_DATA4,            ///< App Data 4
    RTKOTAImageType_87x2_APP_DATA5,            ///< App Data 5
    RTKOTAImageType_87x2_APP_DATA6,            ///< App Data 6
    RTKOTAImageType_87x2_UPPERSTACK,           ///< Upper Stack
    RTKOTAImageType_87x2_StackPatch,           ///< StackPatch (8752H)
    RTKOTAImageType_87x2_User_Data1,           ///< User Data 1
    RTKOTAImageType_87x2_User_Data2,           ///< User Data 2
    
    RTKOTAImageType_87x3_SOCV_CFG                  = 1,      ///< SOCV Configuration
    RTKOTAImageType_87x3_SystemConfig              = 2,      ///< System Configuration
    RTKOTAImageType_87x3_OTAHeader                 = 3,      ///< OTA Header
    RTKOTAImageType_87x3_Secure_Boot_Loader        = 4,      ///< Secure Boot Loader
    RTKOTAImageType_87x3_ROM_PATCH                 = 5,      ///< ROM Patch
    RTKOTAImageType_87x3_APP_IMG                   = 6,      ///< App
    RTKOTAImageType_87x3_DSP_System                = 7,      ///< DSP System
    RTKOTAImageType_87x3_DSP_APP                   = 8,      ///< DSP App
    RTKOTAImageType_87x3_DSP_UI_PARAMETER          = 9,      ///< DSP UI Parameter (DSP Configure)
    RTKOTAImageType_87x3_APP_UI_PARAMETER          = 10,     ///< App UI Parameter (APP Configure)
    RTKOTAImageType_87x3_EXT_IMAGE0                = 11,     ///< Extension Image 0 (ANC)
    RTKOTAImageType_87x3_EXT_IMAGE1                = 12,     ///< Extension Image 1
    RTKOTAImageType_87x3_EXT_IMAGE2                = 13,     ///< Extension Image 2 (Sensor)
    RTKOTAImageType_87x3_EXT_IMAGE3                = 14,     ///< Extension Image 3
    RTKOTAImageType_87x3_FACTORY_IMAGE             = 15,     ///< Factory Image
    RTKOTAImageType_87x3_BootPatch                 = 15,     ///< Boot Patch Image
    RTKOTAImageType_87x3_BACKUP_DATA               = 16,     ///< Backup Data
    RTKOTAImageType_87x3_BACKUP_DATA2              = 17,     ///< Backup Data 2
    RTKOTAImageType_87x3_Platform_Img              = 18,     ///< Platform Image
    RTKOTAImageType_87x3_Lower_Stack_Img           = 19,     ///< Lower Stack
    RTKOTAImageType_87x3_Upper_Stack_Img           = 20,     ///< Upper Stack
    RTKOTAImageType_87x3_Framework_Img             = 21,     ///< Framework Image
    RTKOTAImageType_87x3_PreSys_Patch_Img          = 22,     ///< Pre_platform Image
    RTKOTAImageType_87x3_PreStack_Patch_Img        = 23,
    RTKOTAImageType_87x3_PreUpper_Stack_Img        = 24,     ///< Pre_upperstack Image
    RTKOTAImageType_87x3_Voice_Prompt_Data_Img     = 25,     ///< Voice Prompt Data
    RTKOTAImageType_87x3_UserData1                 = 26,     ///< User Data
    RTKOTAImageType_87x3_UserData2                 = 27,
    RTKOTAImageType_87x3_UserData3                 = 28,
    RTKOTAImageType_87x3_UserData4                 = 29,
    RTKOTAImageType_87x3_UserData5                 = 30,
    RTKOTAImageType_87x3_UserData6                 = 31,
    RTKOTAImageType_87x3_UserData7                 = 32,
    RTKOTAImageType_87x3_UserData8                 = 33,
    
    RTKOTAImageType_87x2G_BootPatch                 = 2,
    RTKOTAImageType_87x2G_OTAHeader                 = 32,
    RTKOTAImageType_87x2G_SecurePatch               = 33,
    RTKOTAImageType_87x2G_SecureAPP                 = 34,
    RTKOTAImageType_87x2G_SecureAPPData             = 35,
    RTKOTAImageType_87x2G_PMCPatch                  = 36,
    RTKOTAImageType_87x2G_BTSystemPatch             = 37,
    RTKOTAImageType_87x2G_BTLowerStackPatch         = 39,
    RTKOTAImageType_87x2G_NonSecurePatch            = 40,
    RTKOTAImageType_87x2G_UpperStack                = 41,
    RTKOTAImageType_87x2G_APP                       = 42,
    RTKOTAImageType_87x2G_APPConfigData             = 43,
    RTKOTAImageType_87x2G_DSPPatch                  = 44,
    RTKOTAImageType_87x2G_DSPAPP                    = 45,
    RTKOTAImageType_87x2G_DSPData                   = 46,
    RTKOTAImageType_87x2G_APPData1                  = 47,
    RTKOTAImageType_87x2G_APPData2                  = 48,
    RTKOTAImageType_87x2G_APPData3                  = 49,
    RTKOTAImageType_87x2G_APPData4                  = 50,
    RTKOTAImageType_87x2G_APPData5                  = 51,
    RTKOTAImageType_87x2G_APPData6                  = 52,
    
    RTKOTAImageType_87x2G_UserData8                 = 120,
    RTKOTAImageType_87x2G_UserData7                 = 121,
    RTKOTAImageType_87x2G_UserData6                 = 122,
    RTKOTAImageType_87x2G_UserData5                 = 123,
    RTKOTAImageType_87x2G_UserData4                 = 124,
    RTKOTAImageType_87x2G_UserData3                 = 125,
    RTKOTAImageType_87x2G_UserData2                 = 126,
    RTKOTAImageType_87x2G_UserData1                 = 127,
    
    // =======================================================
    // MARK: - Deprecated Names (Backward Compatibility)
    // =======================================================

    RTKOTAImageType_Bee_Patch    RTK_DEPRECATED_ENUM(RTKOTAImageType_Patch)    = RTKOTAImageType_Patch,
    RTKOTAImageType_Bee_AppBank0 RTK_DEPRECATED_ENUM(RTKOTAImageType_AppBank0) = RTKOTAImageType_AppBank0,
    RTKOTAImageType_Bee_AppBank1 RTK_DEPRECATED_ENUM(RTKOTAImageType_AppBank1) = RTKOTAImageType_AppBank1,
    RTKOTAImageType_Bee_Data     RTK_DEPRECATED_ENUM(RTKOTAImageType_Data)     = RTKOTAImageType_Data,
    RTKOTAImageType_Bee_PatchExt RTK_DEPRECATED_ENUM(RTKOTAImageType_PatchExt) = RTKOTAImageType_PatchExt,
    RTKOTAImageType_Bee_Config   RTK_DEPRECATED_ENUM(RTKOTAImageType_Config)   = RTKOTAImageType_Config,
    
    RTKOTAImageType_SBee2_SOCV_CFG        RTK_DEPRECATED_ENUM(RTKOTAImageType_87x2_SOCV_CFG)        = RTKOTAImageType_87x2_SOCV_CFG,
    RTKOTAImageType_SBee2_SystemConfig    RTK_DEPRECATED_ENUM(RTKOTAImageType_87x2_SystemConfig)    = RTKOTAImageType_87x2_SystemConfig,
    RTKOTAImageType_SBee2_OTAHeader       RTK_DEPRECATED_ENUM(RTKOTAImageType_87x2_OTAHeader)       = RTKOTAImageType_87x2_OTAHeader,
    RTKOTAImageType_SBee2_Secure_Boot_Loader RTK_DEPRECATED_ENUM(RTKOTAImageType_87x2_Secure_Boot_Loader) = RTKOTAImageType_87x2_Secure_Boot_Loader,
    RTKOTAImageType_SBee2_ROM_PATCH       RTK_DEPRECATED_ENUM(RTKOTAImageType_87x2_ROM_PATCH)       = RTKOTAImageType_87x2_ROM_PATCH,
    RTKOTAImageType_SBee2_APP_IMG         RTK_DEPRECATED_ENUM(RTKOTAImageType_87x2_APP_IMG)         = RTKOTAImageType_87x2_APP_IMG,
    RTKOTAImageType_SBee2_APP_DATA1       RTK_DEPRECATED_ENUM(RTKOTAImageType_87x2_APP_DATA1)       = RTKOTAImageType_87x2_APP_DATA1,
    RTKOTAImageType_SBee2_APP_DATA2       RTK_DEPRECATED_ENUM(RTKOTAImageType_87x2_APP_DATA2)       = RTKOTAImageType_87x2_APP_DATA2,
    RTKOTAImageType_SBee2_APP_DATA3       RTK_DEPRECATED_ENUM(RTKOTAImageType_87x2_APP_DATA3)       = RTKOTAImageType_87x2_APP_DATA3,
    RTKOTAImageType_SBee2_APP_DATA4       RTK_DEPRECATED_ENUM(RTKOTAImageType_87x2_APP_DATA4)       = RTKOTAImageType_87x2_APP_DATA4,
    RTKOTAImageType_SBee2_APP_DATA5       RTK_DEPRECATED_ENUM(RTKOTAImageType_87x2_APP_DATA5)       = RTKOTAImageType_87x2_APP_DATA5,
    RTKOTAImageType_SBee2_APP_DATA6       RTK_DEPRECATED_ENUM(RTKOTAImageType_87x2_APP_DATA6)       = RTKOTAImageType_87x2_APP_DATA6,
    RTKOTAImageType_SBee2_UPPERSTACK      RTK_DEPRECATED_ENUM(RTKOTAImageType_87x2_UPPERSTACK)      = RTKOTAImageType_87x2_UPPERSTACK,
    RTKOTAImageType_SBee2_StackPatch      RTK_DEPRECATED_ENUM(RTKOTAImageType_87x2_StackPatch)      = RTKOTAImageType_87x2_StackPatch,
    RTKOTAImageType_SBee2_User_Data1      RTK_DEPRECATED_ENUM(RTKOTAImageType_87x2_User_Data1)      = RTKOTAImageType_87x2_User_Data1,
    RTKOTAImageType_SBee2_User_Data2      RTK_DEPRECATED_ENUM(RTKOTAImageType_87x2_User_Data2)      = RTKOTAImageType_87x2_User_Data2,
    
    RTKOTAImageType_BBpro_SOCV_CFG        RTK_DEPRECATED_ENUM(RTKOTAImageType_87x3_SOCV_CFG)        = RTKOTAImageType_87x3_SOCV_CFG,
    RTKOTAImageType_BBpro_SystemConfig    RTK_DEPRECATED_ENUM(RTKOTAImageType_87x3_SystemConfig)    = RTKOTAImageType_87x3_SystemConfig,
    RTKOTAImageType_BBpro_OTAHeader       RTK_DEPRECATED_ENUM(RTKOTAImageType_87x3_OTAHeader)       = RTKOTAImageType_87x3_OTAHeader,
    RTKOTAImageType_BBpro_Secure_Boot_Loader RTK_DEPRECATED_ENUM(RTKOTAImageType_87x3_Secure_Boot_Loader) = RTKOTAImageType_87x3_Secure_Boot_Loader,
    RTKOTAImageType_BBpro_ROM_PATCH       RTK_DEPRECATED_ENUM(RTKOTAImageType_87x3_ROM_PATCH)       = RTKOTAImageType_87x3_ROM_PATCH,
    RTKOTAImageType_BBpro_APP_IMG         RTK_DEPRECATED_ENUM(RTKOTAImageType_87x3_APP_IMG)         = RTKOTAImageType_87x3_APP_IMG,
    RTKOTAImageType_BBpro_DSP_System      RTK_DEPRECATED_ENUM(RTKOTAImageType_87x3_DSP_System)      = RTKOTAImageType_87x3_DSP_System,
    RTKOTAImageType_BBpro_DSP_APP         RTK_DEPRECATED_ENUM(RTKOTAImageType_87x3_DSP_APP)         = RTKOTAImageType_87x3_DSP_APP,
    RTKOTAImageType_BBpro_DSP_UI_PARAMETER RTK_DEPRECATED_ENUM(RTKOTAImageType_87x3_DSP_UI_PARAMETER) = RTKOTAImageType_87x3_DSP_UI_PARAMETER,
    RTKOTAImageType_BBpro_APP_UI_PARAMETER RTK_DEPRECATED_ENUM(RTKOTAImageType_87x3_APP_UI_PARAMETER) = RTKOTAImageType_87x3_APP_UI_PARAMETER,
    RTKOTAImageType_BBpro_EXT_IMAGE0      RTK_DEPRECATED_ENUM(RTKOTAImageType_87x3_EXT_IMAGE0)      = RTKOTAImageType_87x3_EXT_IMAGE0,
    RTKOTAImageType_BBpro_EXT_IMAGE1      RTK_DEPRECATED_ENUM(RTKOTAImageType_87x3_EXT_IMAGE1)      = RTKOTAImageType_87x3_EXT_IMAGE1,
    RTKOTAImageType_BBpro_EXT_IMAGE2      RTK_DEPRECATED_ENUM(RTKOTAImageType_87x3_EXT_IMAGE2)      = RTKOTAImageType_87x3_EXT_IMAGE2,
    RTKOTAImageType_BBpro_EXT_IMAGE3      RTK_DEPRECATED_ENUM(RTKOTAImageType_87x3_EXT_IMAGE3)      = RTKOTAImageType_87x3_EXT_IMAGE3,
    RTKOTAImageType_BBpro_FACTORY_IMAGE   RTK_DEPRECATED_ENUM(RTKOTAImageType_87x3_FACTORY_IMAGE)   = RTKOTAImageType_87x3_FACTORY_IMAGE,
    RTKOTAImageType_BBpro_BootPatch       RTK_DEPRECATED_ENUM(RTKOTAImageType_87x3_BootPatch)       = RTKOTAImageType_87x3_BootPatch,
    RTKOTAImageType_BBpro_BACKUP_DATA     RTK_DEPRECATED_ENUM(RTKOTAImageType_87x3_BACKUP_DATA)     = RTKOTAImageType_87x3_BACKUP_DATA,
    RTKOTAImageType_BBpro_BACKUP_DATA2    RTK_DEPRECATED_ENUM(RTKOTAImageType_87x3_BACKUP_DATA2)    = RTKOTAImageType_87x3_BACKUP_DATA2,
    RTKOTAImageType_BBpro_Platform_Img    RTK_DEPRECATED_ENUM(RTKOTAImageType_87x3_Platform_Img)    = RTKOTAImageType_87x3_Platform_Img,
    RTKOTAImageType_BBpro_Lower_Stack_Img RTK_DEPRECATED_ENUM(RTKOTAImageType_87x3_Lower_Stack_Img) = RTKOTAImageType_87x3_Lower_Stack_Img,
    RTKOTAImageType_BBpro_Upper_Stack_Img RTK_DEPRECATED_ENUM(RTKOTAImageType_87x3_Upper_Stack_Img) = RTKOTAImageType_87x3_Upper_Stack_Img,
    RTKOTAImageType_BBpro_Framework_Img   RTK_DEPRECATED_ENUM(RTKOTAImageType_87x3_Framework_Img)   = RTKOTAImageType_87x3_Framework_Img,
    RTKOTAImageType_BBpro_PreSys_Patch_Img RTK_DEPRECATED_ENUM(RTKOTAImageType_87x3_PreSys_Patch_Img) = RTKOTAImageType_87x3_PreSys_Patch_Img,
    RTKOTAImageType_BBpro_PreStack_Patch_Img RTK_DEPRECATED_ENUM(RTKOTAImageType_87x3_PreStack_Patch_Img) = RTKOTAImageType_87x3_PreStack_Patch_Img,
    RTKOTAImageType_BBpro_PreUpper_Stack_Img RTK_DEPRECATED_ENUM(RTKOTAImageType_87x3_PreUpper_Stack_Img) = RTKOTAImageType_87x3_PreUpper_Stack_Img,
    RTKOTAImageType_BBpro_Voice_Prompt_Data_Img RTK_DEPRECATED_ENUM(RTKOTAImageType_87x3_Voice_Prompt_Data_Img) = RTKOTAImageType_87x3_Voice_Prompt_Data_Img,
    RTKOTAImageType_BBpro_UserData1       RTK_DEPRECATED_ENUM(RTKOTAImageType_87x3_UserData1)       = RTKOTAImageType_87x3_UserData1,
    RTKOTAImageType_BBpro_UserData2       RTK_DEPRECATED_ENUM(RTKOTAImageType_87x3_UserData2)       = RTKOTAImageType_87x3_UserData2,
    RTKOTAImageType_BBpro_UserData3       RTK_DEPRECATED_ENUM(RTKOTAImageType_87x3_UserData3)       = RTKOTAImageType_87x3_UserData3,
    RTKOTAImageType_BBpro_UserData4       RTK_DEPRECATED_ENUM(RTKOTAImageType_87x3_UserData4)       = RTKOTAImageType_87x3_UserData4,
    RTKOTAImageType_BBpro_UserData5       RTK_DEPRECATED_ENUM(RTKOTAImageType_87x3_UserData5)       = RTKOTAImageType_87x3_UserData5,
    RTKOTAImageType_BBpro_UserData6       RTK_DEPRECATED_ENUM(RTKOTAImageType_87x3_UserData6)       = RTKOTAImageType_87x3_UserData6,
    RTKOTAImageType_BBpro_UserData7       RTK_DEPRECATED_ENUM(RTKOTAImageType_87x3_UserData7)       = RTKOTAImageType_87x3_UserData7,
    RTKOTAImageType_BBpro_UserData8       RTK_DEPRECATED_ENUM(RTKOTAImageType_87x3_UserData8)       = RTKOTAImageType_87x3_UserData8,
    
    RTKOTAImageType_Bee3Pro_OTAHeader     RTK_DEPRECATED_ENUM(RTKOTAImageType_87x2G_OTAHeader)         = RTKOTAImageType_87x2G_OTAHeader,
    RTKOTAImageType_Bee3Pro_SecurePatch   RTK_DEPRECATED_ENUM(RTKOTAImageType_87x2G_SecurePatch)       = RTKOTAImageType_87x2G_SecurePatch,
    RTKOTAImageType_Bee3Pro_SecureAPP     RTK_DEPRECATED_ENUM(RTKOTAImageType_87x2G_SecureAPP)         = RTKOTAImageType_87x2G_SecureAPP,
    RTKOTAImageType_Bee3Pro_SecureAPPData RTK_DEPRECATED_ENUM(RTKOTAImageType_87x2G_SecureAPPData)     = RTKOTAImageType_87x2G_SecureAPPData,
    RTKOTAImageType_Bee3Pro_PMCPatch      RTK_DEPRECATED_ENUM(RTKOTAImageType_87x2G_PMCPatch)          = RTKOTAImageType_87x2G_PMCPatch,
    RTKOTAImageType_Bee3Pro_BTSystemPatch RTK_DEPRECATED_ENUM(RTKOTAImageType_87x2G_BTSystemPatch)     = RTKOTAImageType_87x2G_BTSystemPatch,
    RTKOTAImageType_Bee3Pro_BTLowerStackPatch RTK_DEPRECATED_ENUM(RTKOTAImageType_87x2G_BTLowerStackPatch) = RTKOTAImageType_87x2G_BTLowerStackPatch,
    RTKOTAImageType_Bee3Pro_NonSecurePatch RTK_DEPRECATED_ENUM(RTKOTAImageType_87x2G_NonSecurePatch)   = RTKOTAImageType_87x2G_NonSecurePatch,
    RTKOTAImageType_Bee3Pro_UpperStack    RTK_DEPRECATED_ENUM(RTKOTAImageType_87x2G_UpperStack)        = RTKOTAImageType_87x2G_UpperStack,
    RTKOTAImageType_Bee3Pro_APP           RTK_DEPRECATED_ENUM(RTKOTAImageType_87x2G_APP)               = RTKOTAImageType_87x2G_APP,
    RTKOTAImageType_Bee3Pro_APPConfigData RTK_DEPRECATED_ENUM(RTKOTAImageType_87x2G_APPConfigData)     = RTKOTAImageType_87x2G_APPConfigData,
    RTKOTAImageType_Bee3Pro_DSPPatch      RTK_DEPRECATED_ENUM(RTKOTAImageType_87x2G_DSPPatch)          = RTKOTAImageType_87x2G_DSPPatch,
    RTKOTAImageType_Bee3Pro_DSPAPP        RTK_DEPRECATED_ENUM(RTKOTAImageType_87x2G_DSPAPP)            = RTKOTAImageType_87x2G_DSPAPP,
    RTKOTAImageType_Bee3Pro_DSPData       RTK_DEPRECATED_ENUM(RTKOTAImageType_87x2G_DSPData)           = RTKOTAImageType_87x2G_DSPData,
    RTKOTAImageType_Bee3Pro_APPData1      RTK_DEPRECATED_ENUM(RTKOTAImageType_87x2G_APPData1)          = RTKOTAImageType_87x2G_APPData1,
    RTKOTAImageType_Bee3Pro_APPData2      RTK_DEPRECATED_ENUM(RTKOTAImageType_87x2G_APPData2)          = RTKOTAImageType_87x2G_APPData2,
    RTKOTAImageType_Bee3Pro_APPData3      RTK_DEPRECATED_ENUM(RTKOTAImageType_87x2G_APPData3)          = RTKOTAImageType_87x2G_APPData3,
    RTKOTAImageType_Bee3Pro_APPData4      RTK_DEPRECATED_ENUM(RTKOTAImageType_87x2G_APPData4)          = RTKOTAImageType_87x2G_APPData4,
    RTKOTAImageType_Bee3Pro_APPData5      RTK_DEPRECATED_ENUM(RTKOTAImageType_87x2G_APPData5)          = RTKOTAImageType_87x2G_APPData5,
    RTKOTAImageType_Bee3Pro_APPData6      RTK_DEPRECATED_ENUM(RTKOTAImageType_87x2G_APPData6)          = RTKOTAImageType_87x2G_APPData6,
    
    RTKOTAImageType_Bee4_UserData8        RTK_DEPRECATED_ENUM(RTKOTAImageType_87x2G_UserData8)         = RTKOTAImageType_87x2G_UserData8,
    RTKOTAImageType_Bee4_UserData7        RTK_DEPRECATED_ENUM(RTKOTAImageType_87x2G_UserData7)         = RTKOTAImageType_87x2G_UserData7,
    RTKOTAImageType_Bee4_UserData6        RTK_DEPRECATED_ENUM(RTKOTAImageType_87x2G_UserData6)         = RTKOTAImageType_87x2G_UserData6,
    RTKOTAImageType_Bee4_UserData5        RTK_DEPRECATED_ENUM(RTKOTAImageType_87x2G_UserData5)         = RTKOTAImageType_87x2G_UserData5,
    RTKOTAImageType_Bee4_UserData4        RTK_DEPRECATED_ENUM(RTKOTAImageType_87x2G_UserData4)         = RTKOTAImageType_87x2G_UserData4,
    RTKOTAImageType_Bee4_UserData3        RTK_DEPRECATED_ENUM(RTKOTAImageType_87x2G_UserData3)         = RTKOTAImageType_87x2G_UserData3,
    RTKOTAImageType_Bee4_UserData2        RTK_DEPRECATED_ENUM(RTKOTAImageType_87x2G_UserData2)         = RTKOTAImageType_87x2G_UserData2,
    RTKOTAImageType_Bee4_UserData1        RTK_DEPRECATED_ENUM(RTKOTAImageType_87x2G_UserData1)         = RTKOTAImageType_87x2G_UserData1,
    RTKOTAImageType_Bee4_BootPatch        RTK_DEPRECATED_ENUM(RTKOTAImageType_87x2G_BootPatch)         = RTKOTAImageType_87x2G_BootPatch,
};
#undef RTK_DEPRECATED_ENUM

NS_ASSUME_NONNULL_BEGIN


/// An abstract class that represents an image binary.
///
/// The `RTKOTABin` class is an abstract base class that defines common behavior for objects representing image binary, regardless of whther it is installed at peripheral. There are ``RTKOTAInstalledBin`` subclass which represent an image reside in a real device and ``RTKOTAUpgradeBin`` subclass which represent an image to upgrade.
///
/// You typically don’t create instances of either `RTKOTABin` or its concrete subclasses. Instead, the SDK creates them for you when peripheral information settle or extracted from archive file.
@interface RTKOTABin : NSObject

/// The image type this binary is.
@property (readonly) RTKOTAImageType type;

/// Return a integer version number of the binary object.
@property (readonly) uint64_t version;


/// The name of the binary object.
@property (readonly) NSString *name;

/// Return a human-readable version string.
@property (readonly) NSString *versionString;


/// Compare version and return result of this binary object and a passed binary object.
///
/// The method used to compare may be different for different image type.
- (NSComparisonResult)compareVersionWith:(RTKOTABin *)anotherBin;

@end


NS_ASSUME_NONNULL_END
