//
//  LWBaseViewController.m
//  FissionBluetooth
//
//  Created by 裂变智能 on 2022/12/7.
//

#import "LWBaseViewController.h"

@interface LWBaseViewController ()

@end

@implementation LWBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = UIColorWhite;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)dealloc {
    FBLog(@"🔥%@ - - - dealloc", NSStringFromClass(self.class));
}

@end
