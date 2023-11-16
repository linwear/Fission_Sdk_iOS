//
//  FBTutorialViewController.m
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023/3/10.
//

#import "FBTutorialViewController.h"

@interface FBTutorialViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) CHIPageControlFresno *pageControl;

@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation FBTutorialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = LWLocalizbleString(@"Tutorial");
    
    FBTutorialItemModel *model_1 = FBTutorialItemModel.new;
    model_1.imageName = @"tutorial_0";
    model_1.title = [NSString stringWithFormat:@"%@\n%@", LWLocalizbleString(@"Take [i4 Assistant] as an example"), LWLocalizbleString(@"1. Open the website https://www.i4.cn/ on the computer, download and install [i4]")];
    
    FBTutorialItemModel *model_2 = FBTutorialItemModel.new;
    model_2.imageName = @"tutorial_1";
    model_2.title = LWLocalizbleString(@"2. Use a data cable to connect your iPhone to the computer\n①. Click [My Devices]\n②. Click [Application Management]\n③. Click FissionBluetooth APP [Browse] to open the file management");
    
    FBTutorialItemModel *model_3 = FBTutorialItemModel.new;
    model_3.imageName = self.isFirmware ? @"tutorial_2_1" : @"tutorial_2_2";
    model_3.title = self.isFirmware ? LWLocalizbleString(@"3. FissionBluetooth APP file management\n①. Click [Documents]\n②. Double-click to open [FBFirmwareFile]") : LWLocalizbleString(@"3. FissionBluetooth APP file management\n①. Click [Documents]\n②. Double-click to open [FBAutomaticOTAFile]");
    
    FBTutorialItemModel *model_4 = FBTutorialItemModel.new;
    model_4.imageName = self.isFirmware ? @"tutorial_3_1" : @"tutorial_3_2";
    model_4.title = LWLocalizbleString(@"4. There are two ways to import files:\n①. Click [Import] - [Select File] and select the bin file you want to import locally\n②. Drag the bin file you want to import locally to this list");
    
    FBTutorialItemModel *model_5 = FBTutorialItemModel.new;
    model_5.imageName = self.isFirmware ? @"tutorial_4_1" : @"tutorial_4_2";
    model_5.title = LWLocalizbleString(@"5. After the import is successful, refresh the APP page, you can see the file you just imported, click to select it for OTA");
    
    NSArray *items = @[model_1, model_2, model_3, model_4, model_5];

    // scrollView
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NavigationContentTop, SCREEN_WIDTH, SCREEN_HEIGHT-NavigationContentTop)];
    scrollView.backgroundColor = UIColorBlack;
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
    scrollView.contentSize = CGSizeMake(scrollView.width * items.count, scrollView.height);
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    self.currentPage = 0;
    
    for (int k = 0; k < items.count; k++) {
        FBTutorialItemModel *model = items[k];
        
        UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(k*scrollView.width, 0, scrollView.width, scrollView.height)];
        scroll.backgroundColor = UIColorClear;
        scroll.delegate = self;
        scroll.contentSize = CGSizeMake(scrollView.width, scrollView.height);
        scroll.minimumZoomScale = 1.0;
        scroll.maximumZoomScale = 2.0;
        [scrollView addSubview:scroll];
        
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:scroll.bounds];
        imageView.image = UIImageMake(model.imageName);
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [scroll addSubview:imageView];
        
        
        QMUILabel *titleLab = [[QMUILabel alloc] qmui_initWithFont:FONT(15) textColor:UIColorWhite];
        titleLab.numberOfLines = 0;
        titleLab.text = model.title;
        [scroll addSubview:titleLab];
        titleLab.sd_layout.leftSpaceToView(scroll, 10).rightSpaceToView(scroll, 10).topSpaceToView(scroll, 5).autoHeightRatio(0);
        
        if ([model.title containsString:@"https://www.i4.cn/"]) {
            [Tools setUILabel:titleLab setDataArr:@[@"https://www.i4.cn/"] setColorArr:@[UIColorRed] setFontArr:@[FONT(15)]];
        }
    }
    
    // page
    CHIPageControlFresno *pageControl = [[CHIPageControlFresno alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-30-20, SCREEN_WIDTH, 30)];
    pageControl.numberOfPages = items.count;
    pageControl.radius = 6;
    pageControl.borderWidth = 1;
    pageControl.currentPageTintColor = BlueColor;
    pageControl.tintColor = GreenColor;
    [self.view addSubview:pageControl];
    self.pageControl = pageControl;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView == self.scrollView) {
        double progress = scrollView.contentOffset.x/scrollView.width;
        [self.pageControl setProgress:progress];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (scrollView == self.scrollView) {
        NSInteger currentPage = scrollView.contentOffset.x/scrollView.width;
        
        if (currentPage != self.currentPage) {
            self.currentPage = currentPage;
            
            for (id view in scrollView.subviews) {
                
                if ([view isKindOfClass:UIScrollView.class]) {
                    UIScrollView *scroll = (UIScrollView *)view;
                    if (scroll.zoomScale != 1.0) {
                        [scroll setZoomScale:1.0];
                    }
                }
            }
        }
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{

    if (scrollView != self.scrollView) {
        for (id view in scrollView.subviews){
            
            if ([view isKindOfClass:UIImageView.class]) {
                UIImageView *imageView = (UIImageView *)view;
                return imageView;
                break;
            }
        }
    }
    
    return nil;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    
    if (scrollView != self.scrollView) {
        for (id view in scrollView.subviews){
            
            if ([view isKindOfClass:UIImageView.class]) {
                UIImageView *imageView = (UIImageView *)view;
                CGFloat offsetX = MAX((scrollView.bounds.size.width - scrollView.contentInset.left - scrollView.contentInset.right - scrollView.contentSize.width) * 0.5, 0.0);
                CGFloat offsetY = MAX((scrollView.bounds.size.height - scrollView.contentInset.top - scrollView.contentInset.bottom - scrollView.contentSize.height) * 0.5, 0.0);
                
                imageView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                               scrollView.contentSize.height * 0.5 + offsetY);
                break;
            }
        }
    }
}

@end


@implementation FBTutorialItemModel

@end
