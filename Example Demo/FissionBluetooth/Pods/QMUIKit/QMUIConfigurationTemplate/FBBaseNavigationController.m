//
//  FBBaseNavigationController.m
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023/1/5.
//

#import "FBBaseNavigationController.h"

@interface FBBaseNavigationController ()

@end

@implementation FBBaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSDictionary *titleTextAttributes = @{NSFontAttributeName:[NSObject themePingFangSCMediumFont:18], NSForegroundColorAttributeName:UIColorWhite};
    
    self.navigationBar.tintColor = UIColorWhite;
        
    if (@available(iOS 13.0, *)) {
        
        UINavigationBarAppearance *standardAppearance = UINavigationBarAppearance.new;
        standardAppearance.backgroundColor = BlueColor;
        standardAppearance.titleTextAttributes = titleTextAttributes;
        self.navigationBar.standardAppearance = standardAppearance;
        self.navigationBar.scrollEdgeAppearance = standardAppearance;
        
    } else {
        
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
