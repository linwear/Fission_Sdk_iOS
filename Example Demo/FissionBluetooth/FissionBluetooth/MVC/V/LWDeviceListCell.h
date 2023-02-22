//
//  LWDeviceListCell.h
//  LinWear
//
//  Created by lw on 2020/6/4.
//  Copyright © 2020 lw. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LWDeviceListCell : UITableViewCell

- (void)reloadView:(DeviceListModel *)model;

@end

NS_ASSUME_NONNULL_END
