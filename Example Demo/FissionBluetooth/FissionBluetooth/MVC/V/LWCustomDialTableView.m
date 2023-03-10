//
//  LWCustomDialTableView.m
//  LinWear
//
//  Created by 裂变智能 on 2021/6/16.
//  Copyright © 2021 lw. All rights reserved.
//

#import "LWCustomDialTableView.h"
#import "LWCustomDialCell.h"
#import "LWCustomDialColorCell.h"
#import "LWCustomDialPickerView.h"

@interface LWCustomDialTableView () <UITableViewDelegate, UITableViewDataSource, TZImagePickerControllerDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) UIImagePickerController *imagePickerVc; // 图片选择器

@end

static NSString *const idty = @"LWCustomDialCell";

@implementation LWCustomDialTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        
        self.delegate = self;
        self.dataSource = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self registerClass:LWCustomDialCell.class forCellReuseIdentifier:idty];
        [self registerNib:[UINib nibWithNibName:@"LWCustomDialColorCell" bundle:nil] forCellReuseIdentifier:@"LWCustomDialColorCell"];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return self;
}

- (void)setTitles:(NSArray *)titles{
    _titles = titles;
    
    [self reloadData];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
    return self.titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WeakSelf(self);
    if (indexPath.row >= self.titles.count) return nil;
    
    NSDictionary *dict = self.titles[indexPath.row];
    NSString *title = dict.allKeys.firstObject;
    if ([title isEqualToString:NSLocalizedString(@"Text Color Replacement", nil)]) {
        LWCustomDialColorCell *colorCell = [tableView dequeueReusableCellWithIdentifier:@"LWCustomDialColorCell"];
        colorCell.titleLabel.text = title;
        colorCell.selectColor = self.selectModel.selectColor;
        colorCell.didSelectColorBlock = ^(UIColor * _Nullable didSelectColor) {
            if (weakSelf.customDialSelectModeBlock) {
                weakSelf.customDialSelectModeBlock(LWCustomDialSelectFontColor, didSelectColor);
            }
        };
        return colorCell;
    } else {
        LWCustomDialCell *dialCell = [tableView dequeueReusableCellWithIdentifier:idty forIndexPath:indexPath];
        dialCell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSDictionary *dict = self.titles[indexPath.row];
        NSString *title = dict.allKeys.firstObject;
        dialCell.titleLabel.text = title;
        dialCell.contentLabel.text = [self returnContentString:title withArray:dict.allValues.firstObject];
        
        return dialCell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row >= self.titles.count) return 0;
    
    NSDictionary *dict = self.titles[indexPath.row];
    NSString *title = dict.allKeys.firstObject;
    if ([title isEqualToString:NSLocalizedString(@"Text Color Replacement", nil)]) {
        return 100;
    } else {
        return 60;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WeakSelf(self);
    NSDictionary *dict = self.titles[indexPath.row];
    NSString *title = dict.allKeys.firstObject;
    NSArray *array = dict.allValues.firstObject;
    
    if ([title isEqualToString:NSLocalizedString(@"Text Style", nil)]) {
        
        NSInteger selectObj = self.selectModel.selectStyle;
        [[LWCustomDialPickerView sharedInstance] showMode:LWCustomDialSelectFontStyle withTitle:NSLocalizedString(@"Text Style", nil) withArrayData:array withSelectObj:selectObj withBlock:^(LWCustomDialSelectMode mode, NSInteger result) {
            if (mode==LWCustomDialSelectFontStyle) {
                LWCustomDialStyle selectStyle = result;
                if (weakSelf.customDialSelectModeBlock) {
                    weakSelf.customDialSelectModeBlock(mode, @(selectStyle));
                }
            }
        }];
    }
    else if ([title isEqualToString:NSLocalizedString(@"Background Picture", nil)]) {
        [self handleSelectedPhoto];
    }
    else if ([title isEqualToString:NSLocalizedString(@"Time Position", nil)]) {
        
        NSInteger selectObj = self.selectModel.selectPosition;
        [[LWCustomDialPickerView sharedInstance] showMode:LWCustomDialSelectPosition withTitle:NSLocalizedString(@"Time Position", nil) withArrayData:array withSelectObj:selectObj withBlock:^(LWCustomDialSelectMode mode, NSInteger result) {
            if (mode==LWCustomDialSelectPosition) {
                LWCustomTimeLocationStyle selectPosition = result;
                if (weakSelf.customDialSelectModeBlock) {
                    weakSelf.customDialSelectModeBlock(mode, @(selectPosition));
                }
            }
        }];
    }
    else if ([title isEqualToString:NSLocalizedString(@"More Content", nil)]) {
        
        NSInteger selectObj = self.selectModel.selectTimeTopStyle;
        [[LWCustomDialPickerView sharedInstance] showMode:LWCustomDialSelectTimeTopStyle withTitle:NSLocalizedString(@"More Content", nil) withArrayData:array withSelectObj:selectObj withBlock:^(LWCustomDialSelectMode mode, NSInteger result) {
            if (mode==LWCustomDialSelectTimeTopStyle) {
                LWCustomTimeTopStyle selectTimeTopStyle = result;
                if (weakSelf.customDialSelectModeBlock) {
                    weakSelf.customDialSelectModeBlock(mode, @(selectTimeTopStyle));
                }
            }
        }];
    }
    else if ([title isEqualToString:NSLocalizedString(@"Time Below", nil)]) {
        
        NSInteger selectObj = self.selectModel.selectTimeBottomStyle;
        [[LWCustomDialPickerView sharedInstance] showMode:LWCustomDialSelectTimeBottomStyle withTitle:NSLocalizedString(@"Time Below", nil) withArrayData:array withSelectObj:selectObj withBlock:^(LWCustomDialSelectMode mode, NSInteger result) {
            if (mode==LWCustomDialSelectTimeBottomStyle) {
                LWCustomTimeBottomStyle selectTimeBottomStyle = result;
                if (weakSelf.customDialSelectModeBlock) {
                    weakSelf.customDialSelectModeBlock(mode, @(selectTimeBottomStyle));
                }
            }
        }];
    }
    else if ([title isEqualToString:NSLocalizedString(@"Restore Default Settings", nil)]) {
        if (weakSelf.customDialSelectModeBlock) {
            weakSelf.customDialSelectModeBlock(LWCustomDialSelectRestoreDefault, @(YES));
        }
    }
}

- (NSString *)returnContentString:(NSString *)title withArray:(NSArray *)array {
    NSString *content = @"";
    if ([title isEqualToString:NSLocalizedString(@"Text Style", nil)]) {
        
        for (NSDictionary *dict in array) {
            if ([dict.allValues.firstObject integerValue] == self.selectModel.selectStyle) {
                return dict.allKeys.firstObject;
                break;
            }
        }
    } else if ([title isEqualToString:NSLocalizedString(@"Time Position", nil)]) {
        
        for (NSDictionary *dict in array) {
            if ([dict.allValues.firstObject integerValue] == self.selectModel.selectPosition) {
                return dict.allKeys.firstObject;
                break;
            }
        }
    } else if ([title isEqualToString:NSLocalizedString(@"More Content", nil)]) {
        
        for (NSDictionary *dict in array) {
            if ([dict.allValues.firstObject integerValue] == self.selectModel.selectTimeTopStyle) {
                return dict.allKeys.firstObject;
                break;
            }
        }
    } else if ([title isEqualToString:NSLocalizedString(@"Time Below", nil)]) {
        
        for (NSDictionary *dict in array) {
            if ([dict.allValues.firstObject integerValue] == self.selectModel.selectTimeBottomStyle) {
                return dict.allKeys.firstObject;
                break;
            }
        }
    }
    return content;
}


#pragma mark - SelectedPhoto
- (void)handleSelectedPhoto {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertVC addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Select from album", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        // 相册
        [self getPhoto];
    }]];

    [alertVC addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Photograph", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 拍照
        [self takePhoto];

    }]];

    [alertVC addAction:[UIAlertAction actionWithTitle:LWLocalizbleString(@"Cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

    }]];

    [[NSObject getCurrentVC:self] presentViewController:alertVC animated:YES completion:nil];
}


//#pragma mark - TimeLocation
//- (void)selectTimeLocation {
//    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//    [alertVC addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"上", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [self.headerView selectedCustomDiaStyle:LWCustomDialStyleA timeLocation:LWCustomTimeLocationStyleTop bgImageView:self.bkImageView handler:^(UIImage * _Nullable bkImage, UIImage * _Nullable preView, LWCustomTimeLocationStyle locationStyle) {
//            FBLog(@"%@ - %@ - %ld", bkImage, preView, locationStyle);
//        }];
//    }]];
//
//    [alertVC addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"下", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [self.headerView selectedCustomDiaStyle:LWCustomDialStyleA timeLocation:LWCustomTimeLocationStyleBottom bgImageView:self.bkImageView handler:^(UIImage * _Nullable bkImage, UIImage * _Nullable preView, LWCustomTimeLocationStyle locationStyle) {
//            FBLog(@"%@ - %@ - %ld", bkImage, preView, locationStyle);
//        }];
//    }]];
//
//    [alertVC addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"左", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [self.headerView selectedCustomDiaStyle:LWCustomDialStyleA timeLocation:LWCustomTimeLocationStyleLeft bgImageView:self.bkImageView handler:^(UIImage * _Nullable bkImage, UIImage * _Nullable preView, LWCustomTimeLocationStyle locationStyle) {
//            FBLog(@"%@ - %@ - %ld", bkImage, preView, locationStyle);
//        }];
//    }]];
//
//    [alertVC addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"右", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [self.headerView selectedCustomDiaStyle:LWCustomDialStyleA timeLocation:LWCustomTimeLocationStyleRight bgImageView:self.bkImageView handler:^(UIImage * _Nullable bkImage, UIImage * _Nullable preView, LWCustomTimeLocationStyle locationStyle) {
//            FBLog(@"%@ - %@ - %ld", bkImage, preView, locationStyle);
//        }];
//    }]];
//
//    [alertVC addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//
//    }]];
//
//    [self presentViewController:alertVC animated:YES completion:nil];
//
//}
//
#pragma mark - 访问相册
- (void)getPhoto {
    if ([PHPhotoLibrary authorizationStatus] == 2) { // 已被拒绝，没有相册权限

        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Can't access album", nil) message:[NSString stringWithFormat:NSLocalizedString(@"Please allow %@ to access the album in \"Settings-Privacy-Album\" of the iPhone", nil), @"🧍‍♀️"] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:LWLocalizbleString(@"Cancel") style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Set", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //进入系统设置页面，APP本身的权限管理页面
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
        }];
        [alert addAction:cancelAction];
        [alert addAction:okAction];
        [[NSObject getCurrentVC:self] presentViewController:alert animated:YES completion:nil];

    } else if ([PHPhotoLibrary authorizationStatus] == 0) { // 未请求过相册权限
        [[TZImageManager manager] requestAuthorizationWithCompletion:^{
            [self getPhoto];
        }];
    } else {
        [self pushImagePickerTypePhotoController];
    }
}

- (void)pushImagePickerTypePhotoController {

    TZImagePickerController *imagePC = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    imagePC.allowPickingVideo = NO;
    imagePC.allowTakeVideo = NO;
    imagePC.allowPickingOriginalPhoto = NO;
    imagePC.showSelectBtn = NO;
    imagePC.allowCrop = YES;
    imagePC.modalPresentationStyle = UIModalPresentationFullScreen;

    // 根据手表显示不同形状裁剪框
    if (Tools.getShapeOFTheWatchCurrentlyConnectedIsRound) {
        imagePC.needCircleCrop = YES;       ///< 需要圆形裁剪框
        NSInteger width = (SCREEN_WIDTH - 60);
        imagePC.circleCropRadius = width/2;  ///< 圆形裁剪框半径大小
    } else {
        imagePC.needCircleCrop = NO;       ///< 不需要圆形裁剪框
        NSInteger left = 30;
        NSInteger width = (SCREEN_WIDTH - 60);
        NSInteger widthHeight = width * 1.175;
        NSInteger top = SCREEN_HEIGHT * 0.25;
        
        imagePC.cropRect = CGRectMake(left, top, width, widthHeight);;
    }
    
    imagePC.scaleAspectFillCrop = YES;
    
    [imagePC setCropViewSettingBlock:^(UIView *cropView) {
        cropView.layer.borderColor = [UIColor whiteColor].CGColor;
        cropView.layer.borderWidth = 2;
    }];
    WeakSelf(self);
    [imagePC setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        UIImage *tempImage = photos.firstObject;
        // 将选择的照片刷新UI表盘预览
        if (weakSelf.customDialSelectModeBlock) {
            weakSelf.customDialSelectModeBlock(LWCustomDialSelectBgImage, tempImage);
        }
    }];

    [[NSObject getCurrentVC:self] presentViewController:imagePC animated:YES completion:nil];
}

#pragma mark - 访问相机
- (void)takePhoto {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
        // 无相机权限 做一个友好的提示
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Can't use camera", nil) message:[NSString stringWithFormat:NSLocalizedString(@"Please allow %@ to access the camera in \"Settings-Privacy-Camera\" of the iPhone", nil), @"🧍‍♀️"] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:LWLocalizbleString(@"Cancel") style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Set", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //进入系统设置页面，APP本身的权限管理页面
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
        }];
        [alert addAction:cancelAction];
        [alert addAction:okAction];
        [[NSObject getCurrentVC:self] presentViewController:alert animated:YES completion:nil];

    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
        // fix issue 466, 防止用户首次拍照拒绝授权时相机页黑屏
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self takePhoto];
                });
            }
        }];
        // 拍照之前还需要检查相册权限
    } else if ([PHPhotoLibrary authorizationStatus] == 2) { // 已被拒绝，没有相册权限，将无法保存拍的照片

        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Can't access album", nil) message:[NSString stringWithFormat:NSLocalizedString(@"The photo after taking the photo needs to be added to the album, please allow %@ to access the album in \"Settings-Privacy-Album\" of the iPhone", nil), @"🧍‍♀️"] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:LWLocalizbleString(@"Cancel") style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Set", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //进入系统设置页面，APP本身的权限管理页面
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
        }];
        [alert addAction:cancelAction];
        [alert addAction:okAction];
        [[NSObject getCurrentVC:self] presentViewController:alert animated:YES completion:nil];

    } else if ([PHPhotoLibrary authorizationStatus] == 0) { // 未请求过相册权限
        [[TZImageManager manager] requestAuthorizationWithCompletion:^{
            [self takePhoto];
        }];
    } else {
        [self pushImagePickerTypeCameraController];
    }
}


- (void)pushImagePickerTypeCameraController {

    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        self.imagePickerVc.sourceType = sourceType;
        self.imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
        [[NSObject getCurrentVC:self] presentViewController:self.imagePickerVc animated:YES completion:nil];
    } else {
        
    }
}

#pragma mark - TZImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];

    if ([type isEqualToString:@"public.image"]) {
        TZImagePickerController *tzImagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
        [tzImagePickerVc showProgressHUD];

        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
//        NSDictionary *meta = [info objectForKey:UIImagePickerControllerMediaMetadata];
        // save photo and get asset / 保存图片，获取到asset
        [[TZImageManager manager] savePhotoWithImage:image completion:^(PHAsset *asset, NSError *error){
            [tzImagePickerVc hideProgressHUD];
            if (error) {
                
            } else {
                WeakSelf(self);
                TZAssetModel *assetModel = [[TZImageManager manager] createModelWithAsset:asset];
                TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initCropTypeWithAsset:assetModel.asset photo:image completion:^(UIImage *cropImage, id asset) {
                    if (weakSelf.customDialSelectModeBlock) {
                        weakSelf.customDialSelectModeBlock(LWCustomDialSelectBgImage, cropImage);
                    }
                }];
                imagePicker.allowPickingImage = YES;
                
                // 根据手表显示不同形状裁剪框
                if (Tools.getShapeOFTheWatchCurrentlyConnectedIsRound) {
                    imagePicker.needCircleCrop = YES;       ///< 需要圆形裁剪框
                    NSInteger width = (SCREEN_WIDTH - 60);
                    imagePicker.circleCropRadius = width/2;  ///< 圆形裁剪框半径大小
                } else {
                    imagePicker.needCircleCrop = NO;       ///< 不需要圆形裁剪框
                    NSInteger left = 30;
                    NSInteger width = (SCREEN_WIDTH - 60);
                    NSInteger widthHeight = width * 1.175;
                    NSInteger top = SCREEN_HEIGHT * 0.25;
                    imagePicker.cropRect = CGRectMake(left, top, width, widthHeight);;
                }

                [[NSObject getCurrentVC:self] presentViewController:imagePicker animated:YES completion:nil];
            }
        }];
    }
}


#pragma mark - Getter && Setter
- (UIImagePickerController *)imagePickerVc {
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
        // set appearance / 改变相册选择页的导航栏外观
        _imagePickerVc.navigationBar.barTintColor = [NSObject getCurrentVC:self].navigationController.navigationBar.barTintColor;
        _imagePickerVc.navigationBar.tintColor = [NSObject getCurrentVC:self].navigationController.navigationBar.tintColor;
        UIBarButtonItem *tzBarItem, *BarItem;
        if (@available(iOS 9, *)) {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        } else {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedIn:[TZImagePickerController class], nil];
            BarItem = [UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil];
        }
        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];

    }
    return _imagePickerVc;
}

@end
