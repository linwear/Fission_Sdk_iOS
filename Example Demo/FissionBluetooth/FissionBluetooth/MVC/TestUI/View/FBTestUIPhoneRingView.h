//
//  FBTestUIPhoneRingView.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023-07-05.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FBTestUIPhoneRingView : UIView

/// 单例
+ (FBTestUIPhoneRingView *)sharedInstance;

- (void)phoneRing;

- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
