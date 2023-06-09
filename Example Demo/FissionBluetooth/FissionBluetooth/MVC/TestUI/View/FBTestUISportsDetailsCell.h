//
//  FBTestUISportsDetailsCell.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023-06-02.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class FBTestUISportsDetailsModel;

@interface FBTestUISportsDetailsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *tit;
@property (weak, nonatomic) IBOutlet UILabel *dei;

@property (nonatomic, strong) FBTestUISportsDetailsModel *detailsModel;

@end


@interface FBTestUISportsDetailsModel : NSObject
@property (nonatomic, copy) NSString *img;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *details;
@end

NS_ASSUME_NONNULL_END
