//
//  FBWatchFunctionChangeNoticeModel.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2022/5/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/*
 手表设备功能变更通知｜Watch device function change notice
 */
@interface FBWatchFunctionChangeNoticeModel : NSObject

/**
 变更的功能 | Changed functions
*/
@property (nonatomic, assign) EM_FUNC_SWITCH functionMode;

/**
 功能更改值 | Function change value
 
 @note 根据变更的功能类型，功能更改值代表的含义不同，具体参考上述枚举【EM_FUNC_SWITCH】｜According to the changed function type, the meaning of the function change value is different. Refer to the above enumeration【EM_FUNC_SWITCH】for details
*/
@property (nonatomic, assign) NSInteger functionChangeValue;

@end

NS_ASSUME_NONNULL_END
