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

- (instancetype)init {
    if (self = [super init]) {
        _batterySoures = NSMutableArray.array;
    }
    return self;
}

/// 文件解压
- (void)UnzipFormFilePath:(NSString *)filePath block:(void (^)(NSArray<FBCustomDialListModel *> * _Nullable, NSError * _Nullable))block {
    
    _packet_bin = nil;
    _info_png = nil;
    [_batterySoures removeAllObjects];
    
    // 解压后的文件路径
    NSString *unzipPath = FBDocumentDirectory(FBDownloadFile);

    // 创建解压文件夹
    NSError *pathError = nil;
    [[NSFileManager defaultManager] createDirectoryAtURL:[NSURL fileURLWithPath:unzipPath] withIntermediateDirectories:YES attributes:nil error:&pathError];
    FBLog(@"💁解压到路径: %@ ERROR: %@", unzipPath, pathError);
    
    NSError *error = nil;
    if ([SSZipArchive unzipFileAtPath:filePath toDestination:unzipPath preserveAttributes:YES overwrite:YES password:nil error:&error delegate:self]) {
                
        //目的文件路径
        FBLog(@"💁解压成功: %@", unzipPath);

        // 数据解析
        [self AnalysisOfZipFile:unzipPath block:block];

    } else {
        
        FBLog(@"💁解压失败～ERROR: %@", error);
        if (block) {
            block(nil, error ? error : FBCustomDialObject.error);
        }
    }
}

- (void)AnalysisOfZipFile:(NSString *)zipFilePath block:(void(^)(NSArray<FBCustomDialListModel *> * _Nullable list, NSError * _Nullable error))block {
    
    // 包含所有图片资源数据的 bin
    NSString *packetPath = [NSString stringWithFormat:@"%@/packet.bin", zipFilePath];
    NSData *packet_bin = [NSData dataWithContentsOfFile:packetPath];
    _packet_bin = packet_bin;
    FBLog(@"🌇解析packet.bin长度: %ld", packet_bin.length);
    
    // 包含所有图片资源名称的 json
    NSData *info_png = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/info_png.json", zipFilePath]];
    if (info_png && packet_bin) {
        
        FBFirmwareVersionObject *object = FBAllConfigObject.firmwareConfig;
        
        // 数据源 array
        NSMutableArray <FBCustomDialListModel *> *dataSoures = NSMutableArray.array;
        
        // 原数据 dictionary
        NSDictionary *info_png_dict = [NSJSONSerialization JSONObjectWithData:info_png options:NSJSONReadingMutableLeaves error:nil];
        _info_png = info_png_dict;
        FBLog(@"🌇解析info_png.json成功: %@", info_png_dict);
        
        
#pragma mark - - - - - - - - - - - - - - - - - - - - - - - - - - - 背景 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        
        // 背景图片
        NSArray <NSDictionary *> *defaultBgImageList = info_png_dict[@"defaultBgImageList"];
        
        NSMutableArray <FBCustomDialSoures *> *defaultBgImageList_Array = NSMutableArray.array;
        for (int k = 0; k < defaultBgImageList.count + 1; k++) {
            UIImage *image = nil;
            if (k == 0) {
                image = UIImageMake(@"ic_share_add"); // 首个位置为 + 号
            } else {
                image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", zipFilePath, defaultBgImageList[k-1][@"Background_Name"]]];
            }
            
            if (image) {
                FBCustomDialSoures *BgImageList_Soures = FBCustomDialSoures.new;
                BgImageList_Soures.allowRepeatSelection = NO;
                BgImageList_Soures.itemEvent = FBCustomDialListItemsEvent_BackgroundImage;
                BgImageList_Soures.image = image;
                BgImageList_Soures.title = nil;
                BgImageList_Soures.isSelect = k==1; // 默认选择第一张图
                BgImageList_Soures.index = k==0 ? -1 : [defaultBgImageList[k-1][@"Background_Type"] integerValue];
                [defaultBgImageList_Array addObject:BgImageList_Soures];
            }
        }
        
        FBCustomDialItems *BgImageList_Item = FBCustomDialItems.new;
        BgImageList_Item.title = nil;
        BgImageList_Item.souresType = FBCustomDialListSouresType_Image;
        BgImageList_Item.items = @[defaultBgImageList_Array];
        
        FBCustomDialListModel *BgImageListModel = FBCustomDialListModel.new;
        BgImageListModel.listType = FBCustomDialListType_Background;
        BgImageListModel.list = @[BgImageList_Item];
        
        [dataSoures addObject:BgImageListModel];
        
        
#pragma mark - - - - - - - - - - - - - - - - - - - - - - - - - - - 表盘 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        
        NSMutableArray <FBCustomDialSoures *> *DialTypeTextList_Array = NSMutableArray.array;
        NSArray *DialTypeTextList = @[LWLocalizbleString(@"Number"), LWLocalizbleString(@"Pointer"), LWLocalizbleString(@"Scale")];
        for (int k = 0; k < DialTypeTextList.count; k++) {
            FBCustomDialSoures *DialTypeTextList_Soures = FBCustomDialSoures.new;
            DialTypeTextList_Soures.allowRepeatSelection = NO;
            DialTypeTextList_Soures.itemEvent = FBCustomDialListItemsEvent_DialTypeText;
            DialTypeTextList_Soures.image = nil;
            DialTypeTextList_Soures.title = DialTypeTextList[k];
            DialTypeTextList_Soures.isSelect = k==0; // 默认选择数字
            DialTypeTextList_Soures.isTitleSelect = k==0;
            DialTypeTextList_Soures.index = k;
            [DialTypeTextList_Array addObject:DialTypeTextList_Soures];
        }
        
        FBCustomDialItems *DialTypeTextList_Item = FBCustomDialItems.new;
        DialTypeTextList_Item.title = LWLocalizbleString(@"Type");
        DialTypeTextList_Item.souresType = FBCustomDialListSouresType_Text;
        DialTypeTextList_Item.items = @[DialTypeTextList_Array];
        
        // 时间日期组件图片
        NSArray <NSDictionary *> *timeStyleList = info_png_dict[@"timeStyleList"];
        
        NSMutableArray <FBCustomDialSoures *> *timeStyleList_Array = NSMutableArray.array;
        for (int k = 0; k < timeStyleList.count; k++) {
            UIImage *image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", zipFilePath, timeStyleList[k][@"TimeStyle_Name"]]];
            if (image) {
                FBCustomDialSoures *timeStyleList_Soures = FBCustomDialSoures.new;
                timeStyleList_Soures.allowRepeatSelection = YES;
                timeStyleList_Soures.itemEvent = FBCustomDialListItemsEvent_NumberImage;
                timeStyleList_Soures.title = nil;
                timeStyleList_Soures.image = image;
                timeStyleList_Soures.isSelect = k==0;
                timeStyleList_Soures.index = [timeStyleList[k][@"TimeStyle_Type"] integerValue];
                [timeStyleList_Array addObject:timeStyleList_Soures];
            }
        }
        
        
        // 指针组件图片
        NSArray <NSDictionary *> *pointerBgList = info_png_dict[@"pointerBgList"];
        
        NSMutableArray <FBCustomDialSoures *> *pointerBgList_Array = NSMutableArray.array;
        for (int k = 0; k < pointerBgList.count; k++) {
            UIImage *image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", zipFilePath, pointerBgList[k][@"PointerSet_Name"]]];
            if (image) {
                FBCustomDialSoures *pointerBgList_Soures = FBCustomDialSoures.new;
                pointerBgList_Soures.allowRepeatSelection = YES;
                pointerBgList_Soures.itemEvent = FBCustomDialListItemsEvent_PointerImage;
                pointerBgList_Soures.image = image;
                pointerBgList_Soures.title = nil;
                pointerBgList_Soures.isSelect = NO;
                pointerBgList_Soures.index = [pointerBgList[k][@"PointerSet_Type"] integerValue];
                [pointerBgList_Array addObject:pointerBgList_Soures];
            }
        }
        
        
        // 刻度组件图片
        NSArray <NSDictionary *> *scaleBgList = info_png_dict[@"scaleBgList"];
        
        NSMutableArray <FBCustomDialSoures *> *scaleBgList_Array = NSMutableArray.array;
        for (int k = 0; k < scaleBgList.count; k++) {
            UIImage *image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", zipFilePath, scaleBgList[k][@"Graduation_Name"]]];
            if (image) {
                FBCustomDialSoures *scaleBgList_Soures = FBCustomDialSoures.new;
                scaleBgList_Soures.allowRepeatSelection = YES;
                scaleBgList_Soures.itemEvent = FBCustomDialListItemsEvent_ScaleImage;
                scaleBgList_Soures.image = image;
                scaleBgList_Soures.title = nil;
                scaleBgList_Soures.isSelect = NO;
                scaleBgList_Soures.index = [scaleBgList[k][@"Graduation_Type"] integerValue];
                [scaleBgList_Array addObject:scaleBgList_Soures];
            }
        }
        
        
        FBCustomDialItems *DialTypeImageList_Item = FBCustomDialItems.new;
        DialTypeImageList_Item.title = nil;
        DialTypeImageList_Item.souresType = FBCustomDialListSouresType_Image;
        DialTypeImageList_Item.items = @[timeStyleList_Array, pointerBgList_Array, scaleBgList_Array];
        
        
        FBCustomDialListModel *DialTypeListModel = FBCustomDialListModel.new;
        DialTypeListModel.listType = FBCustomDialListType_DialType;
        DialTypeListModel.list = @[DialTypeTextList_Item, DialTypeImageList_Item];
        
        [dataSoures addObject:DialTypeListModel];
        
        
#pragma mark - - - - - - - - - - - - - - - - - - - - - - - - - - - 组件 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        
        NSMutableArray <NSString *> *StatusTypeText = NSMutableArray.array;
        NSMutableArray <NSMutableArray <FBCustomDialSoures *> *> *StatusTypeImages = NSMutableArray.array;
        
        // 电池电量组件图片
        NSArray <NSDictionary *> *batteryStyleList = info_png_dict[@"batteryStyleList"];
        
        NSMutableArray <FBCustomDialSoures *> *batteryStyleList_Array = NSMutableArray.array;
        for (int k = 0; k < batteryStyleList.count; k++) {
            UIImage *image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", zipFilePath, batteryStyleList[k][@"BatteryStyle_Name"]]];
            if (image) {
                FBCustomDialSoures *batteryStyleList_Soures = FBCustomDialSoures.new;
                batteryStyleList_Soures.allowRepeatSelection = YES;
                batteryStyleList_Soures.itemEvent = FBCustomDialListItemsEvent_StateBatteryImage;
                batteryStyleList_Soures.image = image;
                batteryStyleList_Soures.title = nil;
                batteryStyleList_Soures.isSelect = NO;
                batteryStyleList_Soures.index = [batteryStyleList[k][@"BatteryStyle_Type"] integerValue];
                [batteryStyleList_Array addObject:batteryStyleList_Soures];
            }
        }
        
        if (batteryStyleList_Array.count) {
            [StatusTypeText addObject:LWLocalizbleString(@"Battery")];
            [StatusTypeImages addObject:batteryStyleList_Array];
        }
        
        // 电池电量图标（不带文字，FBCustomDialHeadView用）
        NSArray <NSDictionary *> *batteryList = info_png_dict[@"batteryList"];
        for (int k = 0; k < batteryList.count; k++) {
            UIImage *image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", zipFilePath, batteryList[k][@"battery_Name"]]];
            if (image) {
                FBCustomDialSoures *batteryList_Soures = FBCustomDialSoures.new;
                batteryList_Soures.allowRepeatSelection = YES;
                batteryList_Soures.itemEvent = FBCustomDialListItemsEvent_StateBatteryImage;
                batteryList_Soures.image = image;
                batteryList_Soures.title = nil;
                batteryList_Soures.isSelect = NO;
                batteryList_Soures.index = [batteryList[k][@"battery_Type"] integerValue];
                [_batterySoures addObject:batteryList_Soures];
            }
        }
        
        // BLE 蓝牙组件图片
        NSArray <NSDictionary *> *BLEIconList = info_png_dict[@"BLEIconList"];
        
        NSMutableArray <FBCustomDialSoures *> *BLEIconList_Array = NSMutableArray.array;
        for (int k = 0; k < BLEIconList.count; k++) {
            UIImage *image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", zipFilePath, BLEIconList[k][@"ble_Name"]]];
            if (image) {
                FBCustomDialSoures *BLEIconList_Soures = FBCustomDialSoures.new;
                BLEIconList_Soures.allowRepeatSelection = YES;
                BLEIconList_Soures.itemEvent = FBCustomDialListItemsEvent_StateBluetoothImage_BLE;
                BLEIconList_Soures.image = image;
                BLEIconList_Soures.title = nil;
                BLEIconList_Soures.isSelect = NO;
                BLEIconList_Soures.index = k;
                [BLEIconList_Array addObject:BLEIconList_Soures];
            }
        }
        
        if (BLEIconList_Array.count) {
            [StatusTypeText addObject:LWLocalizbleString(@"Bluetooth connection")];
            [StatusTypeImages addObject:BLEIconList_Array];
        }
        
        
        // BT 蓝牙组件图片
        NSArray <NSDictionary *> *BTIconList = info_png_dict[@"BTIconList"];

        NSMutableArray <FBCustomDialSoures *> *BTIconList_Array = NSMutableArray.array;
        for (int k = 0; k < BTIconList.count; k++) {
            UIImage *image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", zipFilePath, BTIconList[k][@"bt_Name"]]];
            if (image) {
                FBCustomDialSoures *BTIconList_Soures = FBCustomDialSoures.new;
                BTIconList_Soures.allowRepeatSelection = YES;
                BTIconList_Soures.itemEvent = FBCustomDialListItemsEvent_StateBluetoothImage_BT;
                BTIconList_Soures.image = image;
                BTIconList_Soures.title = nil;
                BTIconList_Soures.isSelect = NO;
                BTIconList_Soures.index = k;
                [BTIconList_Array addObject:BTIconList_Soures];
            }
        }
        
        if (BTIconList_Array.count && object.supportCalls) {
            [StatusTypeText addObject:LWLocalizbleString(@"Call Bluetooth")];
            [StatusTypeImages addObject:BTIconList_Array];
        }
        
        NSMutableArray <FBCustomDialSoures *> *StatesTypeText_Array = NSMutableArray.array;
        for (int k = 0; k < StatusTypeText.count; k++) {
            FBCustomDialSoures *StatesTypeText_Soures = FBCustomDialSoures.new;
            StatesTypeText_Soures.allowRepeatSelection = NO;
            StatesTypeText_Soures.itemEvent = FBCustomDialListItemsEvent_StateTypeText;
            StatesTypeText_Soures.image = nil;
            StatesTypeText_Soures.title = StatusTypeText[k];
            StatesTypeText_Soures.isSelect = k==0;
            StatesTypeText_Soures.index = k;
            [StatesTypeText_Array addObject:StatesTypeText_Soures];
        }

        FBCustomDialItems *StatesTypeText_Item = FBCustomDialItems.new;
        StatesTypeText_Item.title = LWLocalizbleString(@"Watch Status");
        StatesTypeText_Item.souresType = FBCustomDialListSouresType_Text;
        StatesTypeText_Item.items = @[StatesTypeText_Array];
        
        FBCustomDialItems *StatesTypeImage_Item = FBCustomDialItems.new;
        StatesTypeImage_Item.title = nil;
        StatesTypeImage_Item.souresType = FBCustomDialListSouresType_Image;
        StatesTypeImage_Item.items = StatusTypeImages;
        
        
        // 组件集⬇️
        
        NSMutableArray <NSString *> *ModuleTypeText = NSMutableArray.array;
        NSMutableArray <NSMutableArray <FBCustomDialSoures *> *> *ModuleTypeImage_Items = NSMutableArray.array;
        
        // 步数组件图片
        NSArray <NSDictionary *> *stepcountIconList = info_png_dict[@"stepcountIconList"];
        
        NSMutableArray <FBCustomDialSoures *> *stepcountIconList_Array = NSMutableArray.array;
        for (int k = 0; k < stepcountIconList.count; k++) {
            FBCustomDialSoures *stepcountIconList_Soures = FBCustomDialSoures.new;
            stepcountIconList_Soures.allowRepeatSelection = YES;
            stepcountIconList_Soures.itemEvent = FBCustomDialListItemsEvent_ModuleStepImage;
            stepcountIconList_Soures.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", zipFilePath, stepcountIconList[k][@"stepcount_Name"]]];
            stepcountIconList_Soures.title = nil;
            stepcountIconList_Soures.isSelect = NO;
            stepcountIconList_Soures.index = k;
            [stepcountIconList_Array addObject:stepcountIconList_Soures];
        }
        if (stepcountIconList_Array.count) {
            [ModuleTypeText addObject:LWLocalizbleString(@"Step")];
            [ModuleTypeImage_Items addObject:stepcountIconList_Array];
        }
        
        // 卡路里组件图片
        NSArray <NSDictionary *> *caroliIconList = info_png_dict[@"caroliIconList"];
        
        NSMutableArray <FBCustomDialSoures *> *caroliIconList_Array = NSMutableArray.array;
        for (int k = 0; k < caroliIconList.count; k++) {
            FBCustomDialSoures *caroliIconList_Soures = FBCustomDialSoures.new;
            caroliIconList_Soures.allowRepeatSelection = YES;
            caroliIconList_Soures.itemEvent = FBCustomDialListItemsEvent_ModuleCalorieImage;
            caroliIconList_Soures.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", zipFilePath, caroliIconList[k][@"caroli_Name"]]];
            caroliIconList_Soures.title = nil;
            caroliIconList_Soures.isSelect = NO;
            caroliIconList_Soures.index = k;
            [caroliIconList_Array addObject:caroliIconList_Soures];
        }
        if (caroliIconList_Array.count) {
            [ModuleTypeText addObject:LWLocalizbleString(@"Calorie")];
            [ModuleTypeImage_Items addObject:caroliIconList_Array];
        }
        
        // 距离组件图片
        NSArray <NSDictionary *> *distanceIconList = info_png_dict[@"distanceIconList"];
        
        NSMutableArray <FBCustomDialSoures *> *distanceIconList_Array = NSMutableArray.array;
        for (int k = 0; k < distanceIconList.count; k++) {
            FBCustomDialSoures *distanceIconList_Soures = FBCustomDialSoures.new;
            distanceIconList_Soures.allowRepeatSelection = YES;
            distanceIconList_Soures.itemEvent = FBCustomDialListItemsEvent_ModuleDistanceImage;
            distanceIconList_Soures.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", zipFilePath, distanceIconList[k][@"distance_Name"]]];
            distanceIconList_Soures.title = nil;
            distanceIconList_Soures.isSelect = NO;
            distanceIconList_Soures.index = k;
            [distanceIconList_Array addObject:distanceIconList_Soures];
        }
        if (distanceIconList_Array.count) {
            [ModuleTypeText addObject:LWLocalizbleString(@"Distance")];
            [ModuleTypeImage_Items addObject:distanceIconList_Array];
        }
        
        // 心率组件图片
        NSArray <NSDictionary *> *HeartrateIconList = info_png_dict[@"HeartrateIconList"];
        
        NSMutableArray <FBCustomDialSoures *> *HeartrateIconList_Array = NSMutableArray.array;
        for (int k = 0; k < HeartrateIconList.count; k++) {
            FBCustomDialSoures *HeartrateIconList_Soures = FBCustomDialSoures.new;
            HeartrateIconList_Soures.allowRepeatSelection = YES;
            HeartrateIconList_Soures.itemEvent = FBCustomDialListItemsEvent_ModuleHeartRateImage;
            HeartrateIconList_Soures.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", zipFilePath, HeartrateIconList[k][@"Heartrate_Name"]]];
            HeartrateIconList_Soures.title = nil;
            HeartrateIconList_Soures.isSelect = NO;
            HeartrateIconList_Soures.index = k;
            [HeartrateIconList_Array addObject:HeartrateIconList_Soures];
        }
        if (HeartrateIconList_Array.count) {
            [ModuleTypeText addObject:LWLocalizbleString(@"Heart Rate")];
            [ModuleTypeImage_Items addObject:HeartrateIconList_Array];
        }
        
        // 血氧组件图片
        NSArray <NSDictionary *> *bloodoxygenIconList = info_png_dict[@"bloodoxygenIconList"];
        
        NSMutableArray <FBCustomDialSoures *> *bloodoxygenIconList_Array = NSMutableArray.array;
        for (int k = 0; k < bloodoxygenIconList.count; k++) {
            FBCustomDialSoures *bloodoxygenIconList_Soures = FBCustomDialSoures.new;
            bloodoxygenIconList_Soures.allowRepeatSelection = YES;
            bloodoxygenIconList_Soures.itemEvent = FBCustomDialListItemsEvent_ModuleBloodOxygenImage;
            bloodoxygenIconList_Soures.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", zipFilePath, bloodoxygenIconList[k][@"bloodoxygen_Name"]]];
            bloodoxygenIconList_Soures.title = nil;
            bloodoxygenIconList_Soures.isSelect = NO;
            bloodoxygenIconList_Soures.index = k;
            [bloodoxygenIconList_Array addObject:bloodoxygenIconList_Soures];
        }
        if (bloodoxygenIconList_Array.count) {
            [ModuleTypeText addObject:LWLocalizbleString(@"Blood Oxygen")];
            [ModuleTypeImage_Items addObject:bloodoxygenIconList_Array];
        }
        
        // 血压组件图片
        NSArray <NSDictionary *> *bloodpressureIconList = info_png_dict[@"bloodpressureIconList"];
        
        NSMutableArray <FBCustomDialSoures *> *bloodpressureIconList_Array = NSMutableArray.array;
        for (int k = 0; k < bloodpressureIconList.count; k++) {
            FBCustomDialSoures *bloodpressureIconList_Soures = FBCustomDialSoures.new;
            bloodpressureIconList_Soures.allowRepeatSelection = YES;
            bloodpressureIconList_Soures.itemEvent = FBCustomDialListItemsEvent_ModuleBloodPressureImage;
            bloodpressureIconList_Soures.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", zipFilePath, bloodpressureIconList[k][@"bloodpressure_Name"]]];
            bloodpressureIconList_Soures.title = nil;
            bloodpressureIconList_Soures.isSelect = NO;
            bloodpressureIconList_Soures.index = k;
            [bloodpressureIconList_Array addObject:bloodpressureIconList_Soures];
        }
        if (bloodpressureIconList_Array.count && object.supportBloodPressure) {
            [ModuleTypeText addObject:LWLocalizbleString(@"Blood Pressure")];
            [ModuleTypeImage_Items addObject:bloodpressureIconList_Array];
        }
        
        // 压力组件图片
        NSArray <NSDictionary *> *stressIconList = info_png_dict[@"stressIconList"];
        
        NSMutableArray <FBCustomDialSoures *> *stressIconList_Array = NSMutableArray.array;
        for (int k = 0; k < stressIconList.count; k++) {
            FBCustomDialSoures *stressIconList_Soures = FBCustomDialSoures.new;
            stressIconList_Soures.allowRepeatSelection = YES;
            stressIconList_Soures.itemEvent = FBCustomDialListItemsEvent_ModuleStressImage;
            stressIconList_Soures.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", zipFilePath, stressIconList[k][@"stress_Name"]]];
            stressIconList_Soures.title = nil;
            stressIconList_Soures.isSelect = NO;
            stressIconList_Soures.index = k;
            [stressIconList_Array addObject:stressIconList_Soures];
        }
        if (stressIconList_Array.count && object.supportMentalStress) {
            [ModuleTypeText addObject:LWLocalizbleString(@"Mental Stress")];
            [ModuleTypeImage_Items addObject:stressIconList_Array];
        }
        
        NSMutableArray <FBCustomDialSoures *> *ModuleTypeText_Array = NSMutableArray.array;
        for (int k = 0; k < ModuleTypeText.count; k++) {
            FBCustomDialSoures *ModuleTypeText_Soures = FBCustomDialSoures.new;
            ModuleTypeText_Soures.allowRepeatSelection = NO;
            ModuleTypeText_Soures.itemEvent = FBCustomDialListItemsEvent_ModuleTypeText;
            ModuleTypeText_Soures.image = nil;
            ModuleTypeText_Soures.title = ModuleTypeText[k];
            ModuleTypeText_Soures.isSelect = k==0;
            ModuleTypeText_Soures.index = k;
            [ModuleTypeText_Array addObject:ModuleTypeText_Soures];
        }
        
        FBCustomDialItems *ModuleTypeText_Item = FBCustomDialItems.new;
        ModuleTypeText_Item.title = LWLocalizbleString(@"Component Style");
        ModuleTypeText_Item.souresType = FBCustomDialListSouresType_Text;
        ModuleTypeText_Item.items = @[ModuleTypeText_Array];
        
        FBCustomDialItems *ModuleTypeImage_Item = FBCustomDialItems.new;
        ModuleTypeImage_Item.title = nil;
        ModuleTypeImage_Item.souresType = FBCustomDialListSouresType_Image;
        ModuleTypeImage_Item.items = ModuleTypeImage_Items;
        
        FBCustomDialListModel *ModuleListModel = FBCustomDialListModel.new;
        ModuleListModel.listType = FBCustomDialListType_Module;
        ModuleListModel.list = @[StatesTypeText_Item, StatesTypeImage_Item, ModuleTypeText_Item, ModuleTypeImage_Item];
        
        [dataSoures addObject:ModuleListModel];
        
        
        // 颜色
        NSArray <UIColor *> *colorList = @[COLOR_HEX(0xFFFFFF, 1), COLOR_HEX(0xbce672, 1),  COLOR_HEX(0x00bc12, 1),  COLOR_HEX(0x057748, 1),  COLOR_HEX(0x48c0a3, 1),  COLOR_HEX(0x758a99, 1),  COLOR_HEX(0xe9f1f6, 1), COLOR_HEX(0x75878a, 1), COLOR_HEX(0x3d3b4f, 1), COLOR_HEX(0x161823, 1), COLOR_HEX(0xfff143, 1), COLOR_HEX(0xffa631, 1), COLOR_HEX(0xff7500, 1), COLOR_HEX(0x9b4400, 1), COLOR_HEX(0xff461f, 1), COLOR_HEX(0xf00056, 1), COLOR_HEX(0xf20c00, 1), COLOR_HEX(0x9d2933, 1), COLOR_HEX(0x8d4bbb, 1), COLOR_HEX(0x56004f, 1), COLOR_HEX(0x003371, 1), COLOR_HEX(0x4c8dae, 1), COLOR_HEX(0xb0a4e3, 1), COLOR_HEX(0xe4c6d0, 1), COLOR_HEX(0x44cef6, 1)];
        NSMutableArray <FBCustomDialSoures *> *colorList_Array = NSMutableArray.array;
        for (int k = 0; k < colorList.count; k++) {
            FBCustomDialSoures *colorList_Soures = FBCustomDialSoures.new;
            colorList_Soures.allowRepeatSelection = NO;
            colorList_Soures.itemEvent = FBCustomDialListItemsEvent_ModuleTypeText;
            colorList_Soures.image = nil;
            colorList_Soures.title = nil;
            colorList_Soures.color = colorList[k];
            colorList_Soures.isSelect = k==0;
            colorList_Soures.index = k;
            [colorList_Array addObject:colorList_Soures];
        }
        
        FBCustomDialItems *colorList_Item = FBCustomDialItems.new;
        colorList_Item.title = nil;
        colorList_Item.souresType = FBCustomDialListSouresType_Color;
        colorList_Item.items = @[colorList_Array];
        
        FBCustomDialListModel *colorListModel = FBCustomDialListModel.new;
        colorListModel.listType = FBCustomDialListType_Colour;
        colorListModel.list = @[colorList_Item];
        
        [dataSoures addObject:colorListModel];

        
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
