//
//  FBEphemerisManager.m
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023-12-19.
//

#import "FBEphemerisManager.h"

@interface FBEphemerisManager ()

@property (nonatomic, strong) FBAGPSEphemerisModel *ephemerisModel;

@end

@implementation FBEphemerisManager

+ (FBEphemerisManager *)sharedInstance {
    static FBEphemerisManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = FBEphemerisManager.new;
    });
    return manager;
}

- (void)requestEphemerisDataWithBlock:(void (^)(NSData * _Nullable, NSString * _Nullable))ephemerisBlock {
    
    self.ephemerisModel = FBAGPSEphemerisModel.new;
    
    WeakSelf(self);
    [LWNetworkingManager requestURL:@"api/v2/ota/agps" httpMethod:GET params:@{} success:^(NSDictionary *result) {
                
        if ([result[@"code"] integerValue] == 200) {
            
            FBEphemerisModel *ephemerisModel = FBEphemerisModel.new;
            
            NSDictionary *dictionary = result[@"data"];
            ephemerisModel.GPS_Glonass_Url = dictionary[@"dataFileUrl"];
            
            NSArray *extFileList = dictionary[@"extFileList"];
            
            for (NSDictionary *dict in extFileList) {
                if ([dict[@"elpoType"] integerValue] == 2) {
                    ephemerisModel.Beidou_Url = dict[@"dataFileUrl"];
                } else if ([dict[@"elpoType"] integerValue] == 1) {
                    ephemerisModel.Galileo_Url = dict[@"dataFileUrl"];
                }
            }
            
            if (StringIsEmpty(ephemerisModel.GPS_Glonass_Url) || StringIsEmpty(ephemerisModel.Beidou_Url) || StringIsEmpty(ephemerisModel.Galileo_Url)) {
                FBLog(@"星历Url请求失败...");
                if (ephemerisBlock) {
                    ephemerisBlock(nil, LWLocalizbleString(@"Fail"));
                }
            } else {
                [self downloadWithModel:ephemerisModel url:ephemerisModel.GPS_Glonass_Url block:ephemerisBlock];
            }
        } else {
            if (ephemerisBlock) {
                ephemerisBlock(nil, result[@"msg"]);
            }
        }
                
    } failure:^(NSError * _Nonnull error, id  _Nullable responseObject) {
        if (ephemerisBlock) {
            ephemerisBlock(nil, error.localizedDescription);
        }
    }];
}

- (void)downloadWithModel:(FBEphemerisModel *)ephemerisModel url:(NSString *)url
                    block:(void(^)(NSData  * _Nullable binData, NSString  * _Nullable errorString))ephemerisBlock {

    WeakSelf(self);
    [LWNetworkingManager requestDownloadURL:url namePrefix:@"FBEphemerisData" success:^(id  _Nonnull result) {

        // 源文件路径
        NSString *sourceFilePath = result[@"filePath"];
        if ([url isEqualToString:ephemerisModel.GPS_Glonass_Url]) {
            weakSelf.ephemerisModel.GPS_Glonass = [NSData dataWithContentsOfFile:sourceFilePath];
            
            [weakSelf downloadWithModel:ephemerisModel url:ephemerisModel.Beidou_Url block:ephemerisBlock];
        }
        else if ([url isEqualToString:ephemerisModel.Beidou_Url]) {
            weakSelf.ephemerisModel.Beidou = [NSData dataWithContentsOfFile:sourceFilePath];
            
            [weakSelf downloadWithModel:ephemerisModel url:ephemerisModel.Galileo_Url block:ephemerisBlock];
        }
        else if ([url isEqualToString:ephemerisModel.Galileo_Url]) {
            weakSelf.ephemerisModel.Galileo = [NSData dataWithContentsOfFile:sourceFilePath];
            
            if (weakSelf.ephemerisModel.GPS_Glonass.length && weakSelf.ephemerisModel.Beidou.length && weakSelf.ephemerisModel.Galileo) {
                NSData *binFile = [FBCustomDataTools.sharedInstance fbGenerateAGPSEphemerisBinFileDataWithModel:weakSelf.ephemerisModel];
                if (ephemerisBlock) {
                    ephemerisBlock(binFile, nil); // 成功
                }
            } else {
                FBLog(@"星历文件下载失败...");
                if (ephemerisBlock) {
                    ephemerisBlock(nil, LWLocalizbleString(@"Fail"));
                }
            }
        }

    } failure:^(NSError * _Nonnull error, id  _Nullable responseObject) {
        if (ephemerisBlock) {
            ephemerisBlock(nil, error.localizedDescription);
        }
    }];
}

@end


@implementation FBEphemerisModel
@end
