//
//  FBDropDownMenu.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023-10-25.
//

#import <Foundation/Foundation.h>
#import "FFDropDownMenuView.h"

NS_ASSUME_NONNULL_BEGIN

@class FBDropDownMenuModel;
@class FBDropDownMenuCell;

@interface FBDropDownMenu : NSObject

+ (void)showDropDownMenuWithModel:(NSArray <FBDropDownMenuModel *> *)modelArray menuWidth:(CGFloat)menuWidth itemHeight:(CGFloat)itemHeight menuBlock:(FFMenuBlock _Nullable)menuBlock;

@end



@interface FBDropDownMenuModel : FFDropDownMenuBasedModel

@property (nonatomic, copy) NSString *mainTitle;    //首行文字
@property (nonatomic, copy) NSString *subTitle;     //第二行文字
@property (nonatomic, assign) BOOL mark;            //✅
@property (nonatomic, assign) NSTextAlignment textAlignment; //文字对齐方式

+ (instancetype)fb_DropDownMenuModelWithTitle:(NSString *)mainTitle subTitle:(NSString * _Nullable)subTitle mark:(BOOL)mark textAlignment:(NSTextAlignment)textAlignment;

@end



@interface FBDropDownMenuCell : FFDropDownMenuBasedCell

@property (nonatomic, strong) QMUILabel *mainTitleLabel;    //文字
@property (nonatomic, strong) UIImageView *markImage;       //✅

@end

NS_ASSUME_NONNULL_END
