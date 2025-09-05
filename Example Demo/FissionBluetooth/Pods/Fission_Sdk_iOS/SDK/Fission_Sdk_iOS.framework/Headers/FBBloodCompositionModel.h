//
//  FBBloodCompositionModel.h
//  FissionBluetooth
//
//  Created by LINWEAR on 2025-08-11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 血液成分私人模式信息｜Blood composition private mode information
 */
@interface FBBloodCompositionModel : NSObject

/** 模式开关 NO:关闭 YES:打开｜Mode switch NO: Off YES: On */
@property (nonatomic, assign) BOOL enable;

/** 尿酸（μmol/L）｜Uric acid (μmol/L) */
@property (nonatomic, assign) NSInteger uricAcid;

/** 总胆固醇（μmol/L）｜Total cholesterol (μmol/L) */
@property (nonatomic, assign) double totalCholesterol;

/** 甘油三酯（μmol/L）｜Triglycerides (μmol/L) */
@property (nonatomic, assign) double triglycerides;

/** 高密度脂蛋白（μmol/L）｜High-density lipoprotein (μmol/L) */
@property (nonatomic, assign) double HDL;

/** 低密度脂蛋白（μmol/L）｜Low-density lipoprotein (μmol/L) */
@property (nonatomic, assign) double LDL;

@end

NS_ASSUME_NONNULL_END
