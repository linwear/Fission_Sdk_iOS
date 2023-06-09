//
//  FBCameraViewController.m
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023/1/5.
//

#import "FBCameraViewController.h"

@interface FBCameraViewController () <AVCapturePhotoCaptureDelegate>

//捕获设备, 通常是前置摄像头, 后置摄像头, 麦克风
@property (nonatomic, retain) AVCaptureDevice *device;
//输入设备
@property (nonatomic, retain) AVCaptureDeviceInput *input;
//输出设备
@property (nonatomic, retain) AVCapturePhotoOutput *photoOutput;
//捕捉会话
@property (nonatomic, retain) AVCaptureSession *session;
//图像预览层, 实时显示捕获的图像
@property (nonatomic, retain) AVCaptureVideoPreviewLayer *previewLayer;

@property (nonatomic, retain) UIImageView *imageView;

@end

@implementation FBCameraViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self fbUpTakePhotoStatusData:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self fbUpTakePhotoStatusData:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = LWLocalizbleString(@"Camera");
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(watchClickTakePhoto) name:FISSION_SDK_WATCHCLICKTAKEPHOTO object:nil];

    
    UIBarButtonItem *turnOver = [[UIBarButtonItem alloc] initWithImage:IMAGE_NAME(@"ic_linear_refresh") style:UIBarButtonItemStylePlain target:self action:@selector(turnOver)];
    self.navigationItem.rightBarButtonItem = turnOver;
    
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    self.input = [[AVCaptureDeviceInput alloc] initWithDevice:self.device error:nil];
    
    self.photoOutput = [[AVCapturePhotoOutput alloc] init];

    self.session = [[AVCaptureSession alloc] init];
    
    if ([self.session canAddInput:self.input]) {
        [self.session addInput:self.input];
    } else { // 初始化失败
        self.device = nil;
        self.input = nil;
        self.photoOutput = nil;
        self.session = nil;
        return;
    }
    
    if ([self.session canAddOutput:self.photoOutput]) {
        [self.session addOutput:self.photoOutput];
    }
   
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    self.previewLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer insertSublayer:self.previewLayer atIndex:0];
    
    //开始启动
    [self.session startRunning];
    
    UIView *itemView = UIView.new;
    itemView.backgroundColor = COLOR_HEX(0x000000, 0.5);
    [self.view addSubview:itemView];
    itemView.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).bottomEqualToView(self.view).heightIs(120);
    
    UIView *borderView = UIView.new;
    borderView.backgroundColor = UIColorClear;
    borderView.sd_cornerRadius = @(40);
    borderView.layer.borderWidth = 2;
    borderView.layer.borderColor = UIColorWhite.CGColor;
    [itemView addSubview:borderView];
    borderView.sd_layout.centerXEqualToView(itemView).centerYEqualToView(itemView).widthIs(80).heightIs(80);
    
    UIButton *take = [UIButton buttonWithType:UIButtonTypeCustom];
    take.backgroundColor = UIColorWhite;
    take.sd_cornerRadius = @(32);
    [itemView addSubview:take];
    take.sd_layout.centerXEqualToView(itemView).centerYEqualToView(itemView).widthIs(64).heightIs(64);
    [take addTarget:self action:@selector(takePhoto) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *imageView = UIImageView.new;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    imageView.backgroundColor = UIColorClear;
    [itemView addSubview:imageView];
    imageView.sd_layout.leftSpaceToView(itemView, 15).centerYEqualToView(itemView).widthIs(90).heightIs(90);
    self.imageView = imageView;
}

// 捕获设备
- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position {
    
    AVCaptureDeviceDiscoverySession *deviceDiscovery = [AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:@[AVCaptureDeviceTypeBuiltInWideAngleCamera] mediaType:AVMediaTypeVideo position:position];

    NSArray *devices  = deviceDiscovery.devices;
    AVCaptureDevice *avcDevice = nil;
    for (AVCaptureDevice *device in devices) {
        if ([device position] == position) {
            avcDevice = device;
            break;
        }
    }
    return avcDevice;
}

// 翻转摄像头
- (void)turnOver {
    
    AVCaptureDevicePosition position = self.input.device.position;
    
    AVCaptureDevice *newDevice = nil;
    AVCaptureDeviceInput *newInput = nil;
    if (position == AVCaptureDevicePositionFront) {
        newDevice = [self cameraWithPosition:AVCaptureDevicePositionBack];
    } else if (position == AVCaptureDevicePositionBack){
        newDevice = [self cameraWithPosition:AVCaptureDevicePositionFront];
    }
    
    // 设置input
    newInput = [AVCaptureDeviceInput deviceInputWithDevice:newDevice error:nil];
    if (newInput != nil) {
        [self.session beginConfiguration];
        // 先移除原来的input
        [self.session removeInput:self.input];
        if ([self.session canAddInput:newInput]) {
            [self.session addInput:newInput];
            self.input = newInput;
        } else {
            [self.session addInput:self.input];
        }
        [self.session commitConfiguration];
    }
}

- (void)watchClickTakePhoto {
    [self takePhoto];
}

// 拍照
- (void)takePhoto {
    
    if (NSObject.accessCamera) {
        
        WeakSelf(self);
        GCD_MAIN_QUEUE(^{
            AVCapturePhotoSettings *settings = [AVCapturePhotoSettings photoSettings];
            if ([weakSelf.photoOutput.availablePhotoCodecTypes containsObject:AVVideoCodecJPEG]) {
                settings = [AVCapturePhotoSettings photoSettingsWithFormat: @{AVVideoCodecKey: AVVideoCodecJPEG}];
            }
            
            [weakSelf.photoOutput capturePhotoWithSettings:settings delegate:weakSelf];
        });
    }
}

- (void)fbUpTakePhotoStatusData:(BOOL)enter {
    
    [FBAtCommand.sharedInstance fbUpTakePhotoStatusData:enter withBlock:^(NSError * _Nullable error) {
        if (error) {
            [NSObject showHUDText:[NSString stringWithFormat:@"%@", error]];
        }
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - AVCapturePhotoCaptureDelegate
- (void)captureOutput:(AVCapturePhotoOutput *)output didFinishProcessingPhotoSampleBuffer:(nullable CMSampleBufferRef)photoSampleBuffer previewPhotoSampleBuffer:(nullable CMSampleBufferRef)previewPhotoSampleBuffer resolvedSettings:(nonnull AVCaptureResolvedPhotoSettings *)resolvedSettings bracketSettings:(nullable AVCaptureBracketedStillImageSettings *)bracketSettings error:(nullable NSError *)error {
    
    if (error) {
        [NSObject showHUDText:error.localizedDescription];
        
    } else {
        NSData *data = [AVCapturePhotoOutput JPEGPhotoDataRepresentationForJPEGSampleBuffer:photoSampleBuffer previewPhotoSampleBuffer:previewPhotoSampleBuffer];
        UIImage *image = [UIImage imageWithData:data];
        
        self.imageView.image = image;
    }
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

@end
