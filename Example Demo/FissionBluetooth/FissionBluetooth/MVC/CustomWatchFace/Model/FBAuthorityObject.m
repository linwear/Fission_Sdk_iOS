//
//  FBAuthorityObject.m
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023-06-01.
//

#import "FBAuthorityObject.h"

@interface FBAuthorityObject () <TZImagePickerControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIImagePickerController *imagePickerVc; // 图片选择器

@property (nonatomic, copy) FBAuthorityObjectBlock block;

@property (nonatomic, strong) UIViewController *presentViewController;

@end

@implementation FBAuthorityObject

+ (FBAuthorityObject *)sharedInstance {
    static FBAuthorityObject *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = FBAuthorityObject.new;
    });
    return manager;
}

- (void)present:(UIViewController *)presentViewController requestImageWithBlock:(FBAuthorityObjectBlock)block {
    
    self.presentViewController = presentViewController;
        
    WeakSelf(self);
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertVC addAction:[UIAlertAction actionWithTitle:LWLocalizbleString(@"Select from album") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        // 相册
        [weakSelf accessType:FBAuthorityType_Album block:block];
    }]];

    [alertVC addAction:[UIAlertAction actionWithTitle:LWLocalizbleString(@"Camera") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 拍照
        [weakSelf accessType:FBAuthorityType_Camera_Album block:block];

    }]];

    [alertVC addAction:[UIAlertAction actionWithTitle:LWLocalizbleString(@"Cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

    }]];

    [self.presentViewController presentViewController:alertVC animated:YES completion:nil];
}

- (void)accessType:(FBAuthorityType)type block:(FBAuthorityObjectBlock)block {
    self.block = block;
    
    if (type == FBAuthorityType_Album) {
        [self accessPhotoAlbum];
    } else if (type == FBAuthorityType_Camera_Album) {
        [self accessCamera];
    }
}

#pragma mark - 访问相册
- (void)accessPhotoAlbum {
    if ([PHPhotoLibrary authorizationStatus] == 2) { // 已被拒绝，没有相册权限

        [UIAlertObject presentAlertTitle:LWLocalizbleString(@"Can't access album") message:[NSString stringWithFormat:LWLocalizbleString(@"Please allow %@ to access the album in \"Settings-Privacy-Album\" of the iPhone"), Tools.appName] cancel:LWLocalizbleString(@"Cancel") sure:LWLocalizbleString(@"Set") block:^(AlertClickType clickType) {
            if (clickType == AlertClickType_Sure) {
                //进入系统设置页面，APP本身的权限管理页面
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
            }
        }];

    } else if ([PHPhotoLibrary authorizationStatus] == 0) { // 未请求过相册权限
        WeakSelf(self);
        [[TZImageManager manager] requestAuthorizationWithCompletion:^{
            [weakSelf accessPhotoAlbum];
        }];
    } else {
        [self pushImagePickerTypePhotoController];
    }
}

- (void)pushImagePickerTypePhotoController {
    BOOL allowDialVideo = FBAllConfigObject.firmwareConfig.supportVideoDial;
    
    TZImagePickerController *imagePC = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    imagePC.allowPickingVideo = allowDialVideo;
    imagePC.allowEditVideo = allowDialVideo;
    imagePC.maxCropVideoDuration = 10;
    imagePC.presetName = AVAssetExportPresetHighestQuality;
    imagePC.allowTakeVideo = NO;
    imagePC.allowPickingOriginalPhoto = NO;
    imagePC.showSelectBtn = NO;
    imagePC.allowCrop = YES;
    imagePC.modalPresentationStyle = UIModalPresentationFullScreen;
    imagePC.naviBgColor = BlueColor;
    imagePC.naviTitleColor = UIColor.whiteColor;
    imagePC.barItemTextColor = UIColor.whiteColor;

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
    // 选择的图片
    [imagePC setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        UIImage *selectImage = photos.firstObject;
        // 将选择的照片刷新UI表盘预览
        if (weakSelf.block) {
            weakSelf.block(selectImage);
        }
    }];
    
    // 选择的视频
    [imagePC setDidFinishPickingAndEditingVideoHandle:^(UIImage *coverImage, NSString *outputPath, NSString *errorMsg) {
        GCD_MAIN_QUEUE(^{
            [NSObject showLoading:LWLocalizbleString(@"Loading...")];
        });
        dispatch_async(dispatch_queue_create(0,0), ^{
            // 子线程执行任务（比如获取较大数据）
            
            [FBCustomDataTools fbHandleVideoDialWithPath:outputPath contentMode:FB_VIDEOCONTENTMODE_SCALEASPECTFILL scaleRect:CGRectZero timeRange:NSMakeRange(0, 0) callback:^(FBCustomDialVideoModel * _Nullable videoModel, NSError * _Nullable error) {
                GCD_MAIN_QUEUE(^{
                    [NSObject dismiss];
                    if (error) [NSObject showHUDText:error.localizedDescription];
                    // 将选择的照片刷新UI表盘预览
                    if (weakSelf.block) {
                        weakSelf.block(videoModel);
                    }
                });
            }];
        });
    }];

    [self.presentViewController presentViewController:imagePC animated:YES completion:nil];
}

#pragma mark - 访问相机
- (void)accessCamera {
    WeakSelf(self);
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
        // 无相机权限 做一个友好的提示
        [UIAlertObject presentAlertTitle:LWLocalizbleString(@"Can't use camera") message:[NSString stringWithFormat:LWLocalizbleString(@"Please allow %@ to access the camera in \"Settings-Privacy-Camera\" of the iPhone"), Tools.appName] cancel:LWLocalizbleString(@"Cancel") sure:LWLocalizbleString(@"Set") block:^(AlertClickType clickType) {
            if (clickType == AlertClickType_Sure) {
                //进入系统设置页面，APP本身的权限管理页面
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
            }
        }];

    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
        // fix issue 466, 防止用户首次拍照拒绝授权时相机页黑屏
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                GCD_MAIN_QUEUE(^{
                    [weakSelf accessCamera];
                });
            }
        }];
        // 拍照之前还需要检查相册权限
    } else if ([PHPhotoLibrary authorizationStatus] == 2) { // 已被拒绝，没有相册权限，将无法保存拍的照片

        [UIAlertObject presentAlertTitle:LWLocalizbleString(@"Can't access album") message:[NSString stringWithFormat:LWLocalizbleString(@"The photo after taking the photo needs to be added to the album, please allow %@ to access the album in \"Settings-Privacy-Album\" of the iPhone"), Tools.appName] cancel:LWLocalizbleString(@"Cancel") sure:LWLocalizbleString(@"Set") block:^(AlertClickType clickType) {
            if (clickType == AlertClickType_Sure) {
                //进入系统设置页面，APP本身的权限管理页面
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
            }
        }];

    } else if ([PHPhotoLibrary authorizationStatus] == 0) { // 未请求过相册权限
        [[TZImageManager manager] requestAuthorizationWithCompletion:^{
            [weakSelf accessCamera];
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
        [self.presentViewController presentViewController:self.imagePickerVc animated:YES completion:nil];
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
                    if (weakSelf.block) {
                        weakSelf.block(cropImage);
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

                [weakSelf.presentViewController presentViewController:imagePicker animated:YES completion:nil];
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
        _imagePickerVc.navigationBar.barTintColor = self.presentViewController.navigationController.navigationBar.barTintColor;
        _imagePickerVc.navigationBar.tintColor = self.presentViewController.navigationController.navigationBar.tintColor;
        UIBarButtonItem *tzBarItem, *BarItem;
        tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
        BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];

    }
    return _imagePickerVc;
}

@end
