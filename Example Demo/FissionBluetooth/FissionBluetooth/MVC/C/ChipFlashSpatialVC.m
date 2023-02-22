//
//  ChipFlashSpatialVC.m
//  FissionBluetooth
//
//  Created by 裂变智能 on 2021/1/20.
//

#import "ChipFlashSpatialVC.h"

@interface ChipFlashSpatialVC ()
@property (weak, nonatomic) IBOutlet UIButton *setCFS;
@property (weak, nonatomic) IBOutlet UIButton *getCFS;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation ChipFlashSpatialVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = [NSString stringWithFormat:@"%@flash空间数据",self.isOff?@"片外":@"片内"];
    [self.setCFS setTitle:self.isOff?@"设置片外flash空间数据":@"设置片内flash空间数据" forState:UIControlStateNormal];
    [self.getCFS setTitle:self.isOff?@"获取片外flash空间数据":@"获取片内flash空间数据" forState:UIControlStateNormal];
    
//    WeakSelf(self);
//    [[FBBluetoothManager sharedInstance] setReceivedBlock:^(id  _Nonnull object) {
//        weakSelf.textView.text = @"";
//        self.textView.text = (NSString *)object;
//        
//    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)setCFSclick:(id)sender {
    if (self.isOff) {
//        [[FBBluetoothManager sharedInstance] setOffChipFlashSpecialData];
    }else{
//        [[FBBluetoothManager sharedInstance] setInChipFlashSpecialData];
    }
}
- (IBAction)getCFSclick:(id)sender {
    if (self.isOff) {
//        [[FBBluetoothManager sharedInstance] getOffChipFlashSpecialData];
    }else{
//        [[FBBluetoothManager sharedInstance] getInChipFlashSpecialData];
    }
}

@end
