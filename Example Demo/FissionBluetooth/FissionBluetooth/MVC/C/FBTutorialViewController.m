//
//  FBTutorialViewController.m
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023/3/10.
//

#import "FBTutorialViewController.h"

@interface FBTutorialViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation FBTutorialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = LWLocalizbleString(@"Tutorial");
    
    FBTutorialItemModel *model_1 = FBTutorialItemModel.new;
    model_1.imageName = @"tutorial_0";
    model_1.title = LWLocalizbleString(@"1. Open the website https://www.i4.cn/ on the computer, download and install [i4]");
    
    FBTutorialItemModel *model_2 = FBTutorialItemModel.new;
    model_2.imageName = @"tutorial_1";
    model_2.title = LWLocalizbleString(@"2. Use a data cable to connect your iPhone to the computer\n①. Click [My Devices]\n②. Click [Application Management]\n③. Click FissionBluetooth APP [Browse] to open the file management");
    
    FBTutorialItemModel *model_3 = FBTutorialItemModel.new;
    model_3.imageName = @"tutorial_2";
    model_3.title = LWLocalizbleString(@"3. FissionBluetooth APP file management\n①. Click [Documents]\n②. Double-click to open [firmwares]");
    
    FBTutorialItemModel *model_4 = FBTutorialItemModel.new;
    model_4.imageName = @"tutorial_3";
    model_4.title = LWLocalizbleString(@"4. There are two ways to import files:\n①. Click [Import] - [Select File] and select the bin file you want to import locally\n②. Drag the bin file you want to import locally to this list");
    
    FBTutorialItemModel *model_5 = FBTutorialItemModel.new;
    model_5.imageName = @"tutorial_4";
    model_5.title = LWLocalizbleString(@"5. After the import is successful, refresh the APP page, you can see the file you just imported, click to select it for OTA");
    
    NSArray *items = @[model_1, model_2, model_3, model_4, model_5];

    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NavigationContentTop, SCREEN_WIDTH, SCREEN_HEIGHT-NavigationContentTop)];
    scrollView.backgroundColor = UIColorBlack;
    scrollView.pagingEnabled = YES;
    scrollView.contentSize = CGSizeMake(scrollView.width * items.count, scrollView.height);
    [self.view addSubview:scrollView];
    
    for (int k = 0; k < items.count; k++) {
        FBTutorialItemModel *model = items[k];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(k*scrollView.width, 0, scrollView.width, scrollView.height)];
        imageView.image = UIImageMake(model.imageName);
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [scrollView addSubview:imageView];
        
        QMUILabel *titleLab = [[QMUILabel alloc] qmui_initWithFont:FONT(15) textColor:UIColorWhite];
        titleLab.numberOfLines = 0;
        titleLab.text = model.title;
        [imageView addSubview:titleLab];
        titleLab.sd_layout.leftSpaceToView(imageView, 10).rightSpaceToView(imageView, 10).topSpaceToView(imageView, 5).autoHeightRatio(0);
        
        if ([model.title containsString:@"https://www.i4.cn/"]) {
            [Tools setUILabel:titleLab setDataArr:@[@"https://www.i4.cn/"] setColorArr:@[UIColorRed] setFontArr:@[FONT(15)]];
        }
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end


@implementation FBTutorialItemModel

@end
