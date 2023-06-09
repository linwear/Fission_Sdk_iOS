//
//  FBTestUIOverviewCell.m
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023-06-05.
//

#import "FBTestUIOverviewCell.h"

@interface FBTestUIOverviewCell ()

@property (weak, nonatomic) IBOutlet UILabel *title_1;
@property (weak, nonatomic) IBOutlet UILabel *value_1;

@property (weak, nonatomic) IBOutlet UILabel *title_2;
@property (weak, nonatomic) IBOutlet UILabel *value_2;

@property (weak, nonatomic) IBOutlet UILabel *title_3;
@property (weak, nonatomic) IBOutlet UILabel *value_3;

@end

@implementation FBTestUIOverviewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)reloadOverviewModel:(NSArray <FBTestUIOverviewModel *> *)overviewArray {
    
    if (overviewArray.count == 3) {
        
        self.title_1.text = overviewArray[0].title;
        self.value_1.text = overviewArray[0].value;
        
        self.title_2.text = overviewArray[1].title;
        self.value_2.text = overviewArray[1].value;
        
        self.title_3.text = overviewArray[2].title;
        self.value_3.text = overviewArray[2].value;
    }
}

@end
