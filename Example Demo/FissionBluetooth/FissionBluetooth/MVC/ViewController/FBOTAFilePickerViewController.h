//
//  FBOTAFilePickerViewController.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023-11-04.
//

#import "LWBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class FBOTAFilePickerModel;

typedef void(^FBOTAFilePickerBlock)(NSArray <FBOTAFilePickerModel *> *array);

@interface FBOTAFilePickerViewController : LWBaseViewController

- (instancetype)initWithArray:(NSArray <FBOTAFilePickerModel *> *)selectArray block:(FBOTAFilePickerBlock)pickerBlock;

@end

@interface FBOTAFilePickerModel : NSObject

@property (nonatomic, assign) BOOL select;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, strong) NSData *data;

@end

NS_ASSUME_NONNULL_END
