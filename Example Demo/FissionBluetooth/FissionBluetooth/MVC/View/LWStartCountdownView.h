//
//  LWStartCountdownView.h
//  SmartWatch
//
//  Created by 裂变智能 on 2021/7/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
 
typedef void(^CompletionBlock)(void);

@interface LWStartCountdownView : UIView

@property (nonatomic, copy) CompletionBlock block;

+ (LWStartCountdownView *)initialization;

- (void)showWithBlock:(CompletionBlock)completionBlock;

@end

NS_ASSUME_NONNULL_END
