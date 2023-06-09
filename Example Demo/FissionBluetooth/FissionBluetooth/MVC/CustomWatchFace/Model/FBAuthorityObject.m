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

- (void)presentViewControllerGetPictures:(FBAuthorityObjectBlock)block {
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

    [QMUIHelper.visibleViewController presentViewController:alertVC animated:YES completion:nil];
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

        UIAlertController *alert = [UIAlertController alertControllerWithTitle:LWLocalizbleString(@"Can't access album") message:[NSString stringWithFormat:LWLocalizbleString(@"Please allow %@ to access the album in \"Settings-Privacy-Album\" of the iPhone"), Tools.appName] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:LWLocalizbleString(@"Cancel") style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:LWLocalizbleString(@"Set") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //进入系统设置页面，APP本身的权限管理页面
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
        }];
        [alert addAction:cancelAction];
        [alert addAction:okAction];
        [QMUIHelper.visibleViewController presentViewController:alert animated:YES completion:nil];

    } else if ([PHPhotoLibrary authorizationStatus] == 0) { // 未请求过相册权限
        [[TZImageManager manager] requestAuthorizationWithCompletion:^{
            [self accessPhotoAlbum];
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
        UIImage *selectImage = photos.firstObject;
        // 将选择的照片刷新UI表盘预览
        if (weakSelf.block) {
            weakSelf.block(selectImage);
        }
    }];

    [QMUIHelper.visibleViewController presentViewController:imagePC animated:YES completion:nil];
}

#pragma mark - 访问相机
- (void)accessCamera {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
        // 无相机权限 做一个友好的提示
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:LWLocalizbleString(@"Can't use camera") message:[NSString stringWithFormat:LWLocalizbleString(@"Please allow %@ to access the camera in \"Settings-Privacy-Camera\" of the iPhone"), Tools.appName] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:LWLocalizbleString(@"Cancel") style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:LWLocalizbleString(@"Set") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //进入系统设置页面，APP本身的权限管理页面
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
        }];
        [alert addAction:cancelAction];
        [alert addAction:okAction];
        [QMUIHelper.visibleViewController presentViewController:alert animated:YES completion:nil];

    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
        // fix issue 466, 防止用户首次拍照拒绝授权时相机页黑屏
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self accessCamera];
                });
            }
        }];
        // 拍照之前还需要检查相册权限
    } else if ([PHPhotoLibrary authorizationStatus] == 2) { // 已被拒绝，没有相册权限，将无法保存拍的照片

        UIAlertController *alert = [UIAlertController alertControllerWithTitle:LWLocalizbleString(@"Can't access album") message:[NSString stringWithFormat:LWLocalizbleString(@"The photo after taking the photo needs to be added to the album, please allow %@ to access the album in \"Settings-Privacy-Album\" of the iPhone"), Tools.appName] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:LWLocalizbleString(@"Cancel") style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:LWLocalizbleString(@"Set") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //进入系统设置页面，APP本身的权限管理页面
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
        }];
        [alert addAction:cancelAction];
        [alert addAction:okAction];
        [QMUIHelper.visibleViewController presentViewController:alert animated:YES completion:nil];

    } else if ([PHPhotoLibrary authorizationStatus] == 0) { // 未请求过相册权限
        [[TZImageManager manager] requestAuthorizationWithCompletion:^{
            [self accessCamera];
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
        [QMUIHelper.visibleViewController presentViewController:self.imagePickerVc animated:YES completion:nil];
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

                [QMUIHelper.visibleViewController presentViewController:imagePicker animated:YES completion:nil];
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
        _imagePickerVc.navigationBar.barTintColor = QMUIHelper.visibleViewController.navigationController.navigationBar.barTintColor;
        _imagePickerVc.navigationBar.tintColor = QMUIHelper.visibleViewController.navigationController.navigationBar.tintColor;
        UIBarButtonItem *tzBarItem, *BarItem;
        tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
        BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];

    }
    return _imagePickerVc;
}

@end
