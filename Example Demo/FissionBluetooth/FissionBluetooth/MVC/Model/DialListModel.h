//
//  DialListModel.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2021/4/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DialListModel : NSObject

@property (nonatomic, copy) NSString *downloads;
@property (nonatomic, copy) NSString *dpiType;
@property (nonatomic, copy) NSString *plateClassify;
@property (nonatomic, assign) NSInteger plateId;
@property (nonatomic, copy) NSString *plateName;
@property (nonatomic, copy) NSString *plateUrl;
@property (nonatomic, copy) NSString *plateZip;
@property (nonatomic, copy) NSString *remarks;
@property (nonatomic, copy) NSString *sdkType;
@property (nonatomic, copy) NSString *shape;

@end

NS_ASSUME_NONNULL_END
