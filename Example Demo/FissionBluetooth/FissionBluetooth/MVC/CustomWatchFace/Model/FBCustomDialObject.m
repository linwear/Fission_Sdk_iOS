//
//  FBCustomDialObject.m
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023-06-01.
//

#import "FBCustomDialObject.h"

@interface FBCustomDialObject () <SSZipArchiveDelegate>

@end

@implementation FBCustomDialObject

/// 单例
+ (FBCustomDialObject *)sharedInstance {
    static FBCustomDialObject *manage = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manage = FBCustomDialObject.new;
    });
    return manage;
}

/// 文件解压
- (void)UnzipFormFilePath:(NSString *)filePath block:(void (^)(NSArray<FBCustomDialListModel *> * _Nullable, NSError * _Nullable))block {
    
    self.packet_bin = nil;
    
    // 解压后的文件路径
    NSString *unzipPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"FBWatchUIResourceFolder"];

    // 创建解压文件夹
    NSError *pathError = nil;
    [[NSFileManager defaultManager] createDirectoryAtURL:[NSURL fileURLWithPath:unzipPath] withIntermediateDirectories:YES attributes:nil error:&pathError];
    FBLog(@"💁解压到路径: %@ ERROR: %@", unzipPath, pathError);
    
    NSError *error = nil;
    if ([SSZipArchive unzipFileAtPath:filePath toDestination:unzipPath preserveAttributes:YES overwrite:YES password:nil error:&error delegate:self]) {
        
        //目的文件路径
        NSString *zipFilePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"FBWatchUIResourceFolder"];

        FBLog(@"💁解压成功: %@", zipFilePath);

        // 数据解析
        [self AnalysisOfZipFile:zipFilePath block:block];

    } else {
        
        FBLog(@"💁解压失败～ERROR: %@", error);
        if (block) {
            block(nil, error ? error : FBCustomDialObject.error);
        }
    }
}

- (void)AnalysisOfZipFile:(NSString *)zipFilePath block:(void(^)(NSArray * _Nullable list, NSError * _Nullable error))block {
    
    // 包含所有图片资源数据的 bin
    NSString *packet_bin = [NSString stringWithFormat:@"%@/packet.bin", zipFilePath];
    self.packet_bin = [NSData dataWithContentsOfFile:packet_bin];
    FBLog(@"🌇解析packet.bin长度: %ld", self.packet_bin.length);
    
    // 包含所有图片资源名称的 json
    NSData *info_png = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/info_png.json", zipFilePath]];
    if (info_png) {
        
        // 数据源 array
        NSMutableArray <FBCustomDialListModel *> *dataSoures = NSMutableArray.array;
        
        // 原数据 dictionary
        NSDictionary *info_png_dict = [NSJSONSerialization JSONObjectWithData:info_png options:NSJSONReadingMutableLeaves error:nil];
        FBLog(@"🌇解析info_png.json成功: %@", info_png_dict);
        
        
#pragma mark - - - - - - - - - - - - - - - - - - - - - - - - - - - 背景 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        
        // 背景图片
        NSArray <NSString *> *defaultBgImageList = info_png_dict[@"defaultBgImageList"];
        
        NSMutableArray <UIImage *> *defaultBgImageList_Array = [NSMutableArray arrayWithObject:UIImageMake(@"ic_share_add")];
        for (NSString *string in defaultBgImageList) {
            UIImage *image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", zipFilePath, string]];
            if (image) {
                [defaultBgImageList_Array addObject:image];
            }
        }
        FBCustomDialSoures *BgImageList_Soures = FBCustomDialSoures.new;
        BgImageList_Soures.itemEvent = FBCustomDialListItemsEvent_BackgroundImage;
        BgImageList_Soures.soures = defaultBgImageList_Array;
        
        FBCustomDialItems *BgImageList_Item = FBCustomDialItems.new;
        BgImageList_Item.title = nil;
        BgImageList_Item.itemEvent = FBCustomDialListItemsEvent_BackgroundImage;
        BgImageList_Item.items = @[BgImageList_Soures];
        
        FBCustomDialListModel *BgImageListModel = FBCustomDialListModel.new;
        BgImageListModel.listType = FBCustomDialListType_Background;
        BgImageListModel.list = @[BgImageList_Item];
        
        [dataSoures addObject:BgImageListModel];
        
        
#pragma mark - - - - - - - - - - - - - - - - - - - - - - - - - - - 表盘 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        
        FBCustomDialSoures *DialTypeTextList_Soures = FBCustomDialSoures.new;
        DialTypeTextList_Soures.itemEvent = FBCustomDialListItemsEvent_DialTypeText;
        DialTypeTextList_Soures.soures = @[LWLocalizbleString(@"数字表盘"), LWLocalizbleString(@"指针表盘")];
        
        FBCustomDialItems *DialTypeTextList_Item = FBCustomDialItems.new;
        DialTypeTextList_Item.title = LWLocalizbleString(@"类型");
        DialTypeTextList_Item.itemEvent = FBCustomDialListItemsEvent_DialTypeText;
        DialTypeTextList_Item.items = @[DialTypeTextList_Soures];
        
        // 时间日期组件图片
        NSArray <NSString *> *timeStyleList = info_png_dict[@"timeStyleList"];
        
        NSMutableArray <UIImage *> *timeStyleList_Array = NSMutableArray.array;
        for (NSString *string in timeStyleList) {
            UIImage *image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", zipFilePath, string]];
            if (image) {
                [timeStyleList_Array addObject:image];
            }
        }
        
        FBCustomDialSoures *DialTypeNumberImage_Soures = FBCustomDialSoures.new;
        DialTypeNumberImage_Soures.itemEvent = FBCustomDialListItemsEvent_NumberImage;
        DialTypeNumberImage_Soures.soures = timeStyleList_Array;
        
        FBCustomDialItems *DialTypeNumberImage_Item = FBCustomDialItems.new;
        DialTypeNumberImage_Item.title = nil;
        DialTypeNumberImage_Item.itemEvent = FBCustomDialListItemsEvent_NumberImage;
        DialTypeNumberImage_Item.items = @[DialTypeNumberImage_Soures];
        
        
        // 指针组件图片
        NSArray <NSString *> *pointerBgList = info_png_dict[@"pointerBgList"];
        
        NSMutableArray <UIImage *> *pointerBgList_Array = NSMutableArray.array;
        for (NSString *string in pointerBgList) {
            UIImage *image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", zipFilePath, string]];
            if (image) {
                [pointerBgList_Array addObject:image];
            }
        }
        
        FBCustomDialSoures *pointerBgList_Soures = FBCustomDialSoures.new;
        pointerBgList_Soures.itemEvent = FBCustomDialListItemsEvent_PointerImage;
        pointerBgList_Soures.soures = pointerBgList_Array;
        
        FBCustomDialItems *pointerBgList_Item = FBCustomDialItems.new;
        pointerBgList_Item.title = LWLocalizbleString(@"指针");
        pointerBgList_Item.itemEvent = FBCustomDialListItemsEvent_PointerImage;
        pointerBgList_Item.items = @[pointerBgList_Soures];
        
        
        // 刻度组件图片
        NSArray <NSString *> *scaleBgList = info_png_dict[@"scaleBgList"];
        
        NSMutableArray <UIImage *> *scaleBgList_Array = NSMutableArray.array;
        for (NSString *string in scaleBgList) {
            UIImage *image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", zipFilePath, string]];
            if (image) {
                [scaleBgList_Array addObject:image];
            }
        }
        
        FBCustomDialSoures *scaleBgList_Soures = FBCustomDialSoures.new;
        scaleBgList_Soures.itemEvent = FBCustomDialListItemsEvent_ScaleImage;
        scaleBgList_Soures.soures = scaleBgList_Array;
        
        FBCustomDialItems *scaleBgList_Item = FBCustomDialItems.new;
        scaleBgList_Item.title = LWLocalizbleString(@"刻度");
        scaleBgList_Item.itemEvent = FBCustomDialListItemsEvent_ScaleImage;
        scaleBgList_Item.items = @[scaleBgList_Soures];
        
        
        FBCustomDialListModel *DialTypeListModel = FBCustomDialListModel.new;
        DialTypeListModel.listType = FBCustomDialListType_DialType;
        DialTypeListModel.list = @[DialTypeTextList_Item, DialTypeNumberImage_Item, pointerBgList_Item, scaleBgList_Item];
        
        [dataSoures addObject:DialTypeListModel];
        
        
#pragma mark - - - - - - - - - - - - - - - - - - - - - - - - - - - 组件 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        
        FBCustomDialSoures *StateTypeText_Soures = FBCustomDialSoures.new;
        StateTypeText_Soures.itemEvent = FBCustomDialListItemsEvent_StateTypeText;
        StateTypeText_Soures.soures = @[LWLocalizbleString(@"电量"), LWLocalizbleString(@"蓝牙")];
        
        FBCustomDialItems *StateTypeText_Item = FBCustomDialItems.new;
        StateTypeText_Item.title = LWLocalizbleString(@"手机状态");
        StateTypeText_Item.itemEvent = FBCustomDialListItemsEvent_StateTypeText;
        StateTypeText_Item.items = @[StateTypeText_Soures];
        
        // 电池电量组件图片
        NSArray <NSDictionary *> *batteryList = info_png_dict[@"batteryList"];
        
        NSMutableArray <UIImage *> *batteryList_Array = NSMutableArray.array;
        for (NSDictionary *dict in batteryList) {
            UIImage *image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", zipFilePath, dict[@"battery_Name"]]];
            if (image) {
                [batteryList_Array addObject:image];
            }
        }
        FBCustomDialSoures *batteryList_Soures = FBCustomDialSoures.new;
        batteryList_Soures.itemEvent = FBCustomDialListItemsEvent_StateTypeImage;
        batteryList_Soures.soures = batteryList_Array;
        
        // BLE 蓝牙组件图片
        NSArray <NSDictionary *> *BLEIconList = info_png_dict[@"BLEIconList"];
        
        NSMutableArray <UIImage *> *BLEIconList_Array = NSMutableArray.array;
        for (NSDictionary *dict in BLEIconList) {
            UIImage *image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", zipFilePath, dict[@"ble_Name"]]];
            if (image) {
                [BLEIconList_Array addObject:image];
            }
        }
        FBCustomDialSoures *BLEIconList_Soures = FBCustomDialSoures.new;
        BLEIconList_Soures.itemEvent = FBCustomDialListItemsEvent_StateTypeImage;
        BLEIconList_Soures.soures = BLEIconList_Array;
        
        FBCustomDialItems *battery_BLE_Item = FBCustomDialItems.new;
        battery_BLE_Item.title = nil;
        battery_BLE_Item.itemEvent = FBCustomDialListItemsEvent_StateTypeImage;
        battery_BLE_Item.items = @[batteryList_Soures, BLEIconList_Soures];
        
//        // BT 蓝牙组件图片
//        NSArray <NSDictionary *> *BTIconList = info_png_dict[@"BTIconList"];
//
//        NSMutableArray <UIImage *> *BTIconList_Array = NSMutableArray.array;
//        for (NSDictionary *dict in BTIconList) {
//            UIImage *image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", zipFilePath, dict[@"bt_Name"]]];
//            if (image) {
//                [BTIconList_Array addObject:image];
//            }
//        }
        
        
        FBCustomDialSoures *ModuleTypeText_Soures = FBCustomDialSoures.new;
        ModuleTypeText_Soures.itemEvent = FBCustomDialListItemsEvent_ModuleTypeText;
        ModuleTypeText_Soures.soures = @[LWLocalizbleString(@"步数"), LWLocalizbleString(@"卡路里"),  LWLocalizbleString(@"距离"),  LWLocalizbleString(@"心率"),  LWLocalizbleString(@"血氧"),  LWLocalizbleString(@"血压"),  LWLocalizbleString(@"压力")];
        
        FBCustomDialItems *ModuleTypeText_Item = FBCustomDialItems.new;
        ModuleTypeText_Item.title = LWLocalizbleString(@"组件样式");
        ModuleTypeText_Item.itemEvent = FBCustomDialListItemsEvent_ModuleTypeText;
        ModuleTypeText_Item.items = @[ModuleTypeText_Soures];
        
        // 步数组件图片
        NSArray <NSDictionary *> *stepcountIconList = info_png_dict[@"stepcountIconList"];
        
        NSMutableArray <UIImage *> *stepcountIconList_Array = NSMutableArray.array;
        for (NSDictionary *dict in stepcountIconList) {
            UIImage *image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", zipFilePath, dict[@"stepcount_Name"]]];
            if (image) {
                [stepcountIconList_Array addObject:image];
            }
        }
        FBCustomDialSoures *stepcountIconList_Soures = FBCustomDialSoures.new;
        stepcountIconList_Soures.itemEvent = FBCustomDialListItemsEvent_ModuleTypeImage;
        stepcountIconList_Soures.soures = stepcountIconList_Array;
        
        // 卡路里组件图片
        NSArray <NSDictionary *> *caroliIconList = info_png_dict[@"caroliIconList"];
        
        NSMutableArray <UIImage *> *caroliIconList_Array = NSMutableArray.array;
        for (NSDictionary *dict in caroliIconList) {
            UIImage *image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", zipFilePath, dict[@"caroli_Name"]]];
            if (image) {
                [caroliIconList_Array addObject:image];
            }
        }
        FBCustomDialSoures *caroliIconList_Soures = FBCustomDialSoures.new;
        caroliIconList_Soures.itemEvent = FBCustomDialListItemsEvent_ModuleTypeImage;
        caroliIconList_Soures.soures = caroliIconList_Array;
        
        // 距离组件图片
        NSArray <NSDictionary *> *distanceIconList = info_png_dict[@"distanceIconList"];
        
        NSMutableArray <UIImage *> *distanceIconList_Array = NSMutableArray.array;
        for (NSDictionary *dict in distanceIconList) {
            UIImage *image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", zipFilePath, dict[@"distance_Name"]]];
            if (image) {
                [distanceIconList_Array addObject:image];
            }
        }
        FBCustomDialSoures *distanceIconList_Soures = FBCustomDialSoures.new;
        distanceIconList_Soures.itemEvent = FBCustomDialListItemsEvent_ModuleTypeImage;
        distanceIconList_Soures.soures = distanceIconList_Array;
        
        // 心率组件图片
        NSArray <NSDictionary *> *HeartrateIconList = info_png_dict[@"HeartrateIconList"];
        
        NSMutableArray <UIImage *> *HeartrateIconList_Array = NSMutableArray.array;
        for (NSDictionary *dict in HeartrateIconList) {
            UIImage *image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", zipFilePath, dict[@"Heartrate_Name"]]];
            if (image) {
                [HeartrateIconList_Array addObject:image];
            }
        }
        FBCustomDialSoures *HeartrateIconList_Soures = FBCustomDialSoures.new;
        HeartrateIconList_Soures.itemEvent = FBCustomDialListItemsEvent_ModuleTypeImage;
        HeartrateIconList_Soures.soures = HeartrateIconList_Array;
        
        // 血氧组件图片
        NSArray <NSDictionary *> *bloodoxygenIconList = info_png_dict[@"bloodoxygenIconList"];
        
        NSMutableArray <UIImage *> *bloodoxygenIconList_Array = NSMutableArray.array;
        for (NSDictionary *dict in bloodoxygenIconList) {
            UIImage *image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", zipFilePath, dict[@"bloodoxygen_Name"]]];
            if (image) {
                [bloodoxygenIconList_Array addObject:image];
            }
        }
        FBCustomDialSoures *bloodoxygenIconList_Soures = FBCustomDialSoures.new;
        bloodoxygenIconList_Soures.itemEvent = FBCustomDialListItemsEvent_ModuleTypeImage;
        bloodoxygenIconList_Soures.soures = bloodoxygenIconList_Array;
        
        // 血压组件图片
        NSArray <NSDictionary *> *bloodpressureIconList = info_png_dict[@"bloodpressureIconList"];
        
        NSMutableArray <UIImage *> *bloodpressureIconList_Array = NSMutableArray.array;
        for (NSDictionary *dict in bloodpressureIconList) {
            UIImage *image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", zipFilePath, dict[@"bloodpressure_Name"]]];
            if (image) {
                [bloodpressureIconList_Array addObject:image];
            }
        }
        FBCustomDialSoures *bloodpressureIconList_Soures = FBCustomDialSoures.new;
        bloodpressureIconList_Soures.itemEvent = FBCustomDialListItemsEvent_ModuleTypeImage;
        bloodpressureIconList_Soures.soures = bloodpressureIconList_Array;
        
        // 压力组件图片
        NSArray <NSDictionary *> *stressIconList = info_png_dict[@"stressIconList"];
        
        NSMutableArray <UIImage *> *stressIconList_Array = NSMutableArray.array;
        for (NSDictionary *dict in stressIconList) {
            UIImage *image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", zipFilePath, dict[@"stress_Name"]]];
            if (image) {
                [stressIconList_Array addObject:image];
            }
        }
        FBCustomDialSoures *stressIconList_Soures = FBCustomDialSoures.new;
        stressIconList_Soures.itemEvent = FBCustomDialListItemsEvent_ModuleTypeImage;
        stressIconList_Soures.soures = stressIconList_Array;
        
        FBCustomDialItems *ModuleTypeImage_Item = FBCustomDialItems.new;
        ModuleTypeImage_Item.title = nil;
        ModuleTypeImage_Item.itemEvent = FBCustomDialListItemsEvent_ModuleTypeImage;
        ModuleTypeImage_Item.items = @[stepcountIconList_Soures, caroliIconList_Soures, distanceIconList_Soures, HeartrateIconList_Soures, bloodoxygenIconList_Soures, bloodpressureIconList_Soures, stressIconList_Soures];
                
//        // 冒号 : 组件图片
//        NSArray <NSString *> *colonList = info_png_dict[@"colonList"];
//
//        // 百分号 % 组件图片
//        NSArray <NSString *> *persentList = info_png_dict[@"persentList"];
        
        FBCustomDialListModel *ModuleListModel = FBCustomDialListModel.new;
        ModuleListModel.listType = FBCustomDialListType_Module;
        ModuleListModel.list = @[StateTypeText_Item, battery_BLE_Item, ModuleTypeText_Item, ModuleTypeImage_Item];
        
        [dataSoures addObject:ModuleListModel];
        
        
        // 颜色
        [dataSoures addObject:FBCustomDialListModel.new];
        
        
        if (block) {
            block(dataSoures, nil);
        }
        
    } else {
        FBLog(@"🌇解析info_png.json失败, 为nil");
        if (block) {
            block(nil, FBCustomDialObject.error);
        }
    }
}

+ (NSError *)error {
    NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain code:500 userInfo:@{NSLocalizedDescriptionKey:LWLocalizbleString(@"Fail")}];
    return error;
}

#pragma mark - SSZipArchiveDelegate
- (void)zipArchiveWillUnzipArchiveAtPath:(NSString *)path zipInfo:(unz_global_info)zipInfo {
    FBLog(@"将要解压 %@", path);
}

- (void)zipArchiveDidUnzipArchiveAtPath:(NSString *)path zipInfo:(unz_global_info)zipInfo unzippedPath:(NSString *)unzippedPat uniqueId:(NSString *)uniqueId {
    FBLog(@"解压完成 %@ - %@", path, unzippedPat);
}

@end
