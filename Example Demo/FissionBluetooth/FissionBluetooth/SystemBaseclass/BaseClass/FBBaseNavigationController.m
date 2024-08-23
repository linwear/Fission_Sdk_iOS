//
//  FBBaseNavigationController.m
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023/1/5.
//

#import "FBBaseNavigationController.h"

@implementation FBBaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSDictionary *titleTextAttributes = @{NSFontAttributeName:FONT(18), NSForegroundColorAttributeName:UIColorWhite};
    
    self.navigationBar.tintColor = UIColorWhite;
    
    self.navigationBar.translucent = YES;
        
    if (@available(iOS 13.0, *)) {
        
        UINavigationBarAppearance *appearance = UINavigationBarAppearance.new;
        appearance.backgroundColor = BlueColor;
        appearance.shadowColor = UIColorClear;
        appearance.titleTextAttributes = titleTextAttributes;
        self.navigationBar.standardAppearance = appearance;
        self.navigationBar.scrollEdgeAppearance = appearance;
        
    } else {
        self.navigationBar.shadowImage = UIImage.new;
        self.navigationBar.titleTextAttributes = titleTextAttributes;
        self.navigationBar.barTintColor = BlueColor;
    }
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    viewController.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [super pushViewController:viewController animated:animated];
}

- (UIViewController *)childViewControllerForStatusBarStyle {
    return self.topViewController;
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
