//
//  LWBaseViewController.m
//  FissionBluetooth
//
//  Created by θ£εζΊθ½ on 2022/12/7.
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)dealloc {
    FBLog(@"π₯%@ - - - dealloc", NSStringFromClass(self.class));
}

@end
