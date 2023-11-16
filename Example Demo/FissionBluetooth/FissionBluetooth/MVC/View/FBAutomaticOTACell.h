//
//  FBAutomaticOTACell.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023-11-01.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class FBAutomaticOTAModel;
@class FBAutomaticOTAHeaderView;

@interface FBAutomaticOTACell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLab;

- (void)text:(NSString *)text;

@end


@interface FBAutomaticOTAModel : NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, strong) NSMutableArray <NSString *> * rowArray;

@end


@interface FBAutomaticOTAHeaderView : UITableViewHeaderFooterView

@property (nonatomic, strong) UILabel *titleLab;

@end

NS_ASSUME_NONNULL_END
