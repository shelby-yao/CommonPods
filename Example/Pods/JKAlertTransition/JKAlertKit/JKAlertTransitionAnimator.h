//
//  JKAlertTransitionAnimator.h
//  JKAlertRelated
//
//  Created by zhangjie on 2018/7/17.
//  Copyright © 2018年 zhangjie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKAlertEnum.h"
NS_ASSUME_NONNULL_BEGIN
@interface JKAlertTransitionAnimator : NSObject<UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) JKAlertAnimationMode animationMode;

@property (nonatomic, assign) JKAlertAnimationStyle animationStyle;

//设置遮罩 defalut is 黑色 layer
@property(nonatomic,strong)UIView *_Nullable content;

+ (instancetype)animatorWithMode:(JKAlertAnimationMode)animationMode animationStyle:(JKAlertAnimationStyle)animationStyle;
NS_ASSUME_NONNULL_END
@end
