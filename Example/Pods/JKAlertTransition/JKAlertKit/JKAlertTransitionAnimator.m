//
//  JKAlertTransitionAnimator.m
//  JKAlertRelated
//
//  Created by zhangjie on 2018/7/17.
//  Copyright © 2018年 zhangjie. All rights reserved.
//

#import "JKAlertTransitionAnimator.h"

static const NSInteger dimmingViewTag = 0x888888;

static const CGFloat transitionDuration = 0.25f;

@interface JKAlertTransitionAnimator ()
@property(nonatomic,weak)UIView *backgroundView;
@end

@implementation JKAlertTransitionAnimator

#pragma mark - life cycle
- (instancetype)initWithMode:(JKAlertAnimationMode)animationMode animationStyle:(JKAlertAnimationStyle)animationStyle {
    if (self = [super init]) {
        self.animationMode = animationMode;
        self.animationStyle = animationStyle;
    }
    return self;
}

#pragma mark - public method
+ (instancetype)animatorWithMode:(JKAlertAnimationMode)animationMode animationStyle:(JKAlertAnimationStyle)animationStyle {
    return [[self alloc] initWithMode:animationMode animationStyle:animationStyle];
}

#pragma mark - UIViewControllerAnimatedTransitioning
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return transitionDuration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    if (self.animationMode == JKAlertAnimationModePresent) {
        [self presentTransition:transitionContext];
    } else if (self.animationMode == JKAlertAnimationModeDismiss) {
        [self dismissTransition:transitionContext];
    }
}

#pragma mark - private method
- (void)presentTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    UIView *containerView = transitionContext.containerView;
    UIView *fromView = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view;
    fromView.tintAdjustmentMode = UIViewTintAdjustmentModeNormal;
    fromView.userInteractionEnabled = NO;
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *toView = toViewController.view;
    UIView *dimmingView = [[UIView alloc] initWithFrame:containerView.bounds];
    dimmingView.tag = dimmingViewTag;
    dimmingView.userInteractionEnabled = NO;
    dimmingView.backgroundColor = [UIColor clearColor];
    dimmingView.alpha = 0;
    [containerView addSubview:dimmingView];
    [containerView addSubview:toView];
    UIView *backGroundView = [[UIView alloc]init];
    backGroundView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    if (self.content) {
        backGroundView = self.content;
    }
    backGroundView.frame = fromView.bounds;
    [fromView addSubview:backGroundView];
    
    self.backgroundView = backGroundView;
    CABasicAnimation *opacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacity.fromValue = @(0);
    opacity.duration = 0.2;
    [self.backgroundView.layer addAnimation:opacity forKey:nil];
    switch (self.animationStyle) {
        case JKAlertAnimationStylePresentFromTop: {
            toView.frame = CGRectMake(0, -CGRectGetHeight(containerView.bounds), containerView.bounds.size.width, containerView.bounds.size.height);
        }
            break;
        case JKAlertAnimationStylePresentFromBottom: {
            toView.frame = CGRectMake(0, CGRectGetHeight(containerView.bounds), containerView.bounds.size.width, containerView.bounds.size.height);
        }
            break;
        case JKAlertAnimationStylePresentFromLeft: {
            toView.frame = CGRectMake(-CGRectGetWidth(containerView.bounds), 0, containerView.bounds.size.width, containerView.bounds.size.height);
        }
            break;
        case JKAlertAnimationStylePresentFromRight: {
            toView.frame = CGRectMake(CGRectGetWidth(containerView.bounds), 0, containerView.bounds.size.width, containerView.bounds.size.height);
        }
            break;
        case JKAlertAnimationStylePopup: {
            toView.frame = CGRectMake(0,0, CGRectGetWidth(containerView.bounds), CGRectGetHeight(containerView.bounds));
            toView.transform = CGAffineTransformMakeScale(1.2, 1.2);
            toView.alpha = 0;
        }
            break;
        default:
            break;
    }
    
    [UIView animateWithDuration:duration animations:^{
        dimmingView.alpha = 1;
        
        switch (self.animationStyle) {
            case JKAlertAnimationStylePresentFromTop:
            case JKAlertAnimationStylePresentFromBottom:
            case JKAlertAnimationStylePresentFromLeft:
            case JKAlertAnimationStylePresentFromRight: {
                toView.frame = CGRectMake(0, 0, containerView.bounds.size.width, containerView.bounds.size.height);
            }
                break;
            case JKAlertAnimationStylePopup: {
                toView.transform = CGAffineTransformIdentity;
                toView.alpha = 1;
            }
                break;
            default:
                break;
        }
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
}

- (void)dismissTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    UIView *containerView = transitionContext.containerView;
    UIView *fromView = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view;
    UIView *toView = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view;
    toView.tintAdjustmentMode = UIViewTintAdjustmentModeNormal;
    toView.userInteractionEnabled = YES;
    UIView *dimmingView = [containerView viewWithTag:dimmingViewTag];
    [UIView animateWithDuration:0.2 animations:^{
        self.backgroundView.alpha = 0;
    }];
    [UIView animateWithDuration:duration animations:^{
        dimmingView.alpha = 0;
        switch (self.animationStyle) {
            case JKAlertAnimationStylePresentFromTop: {
                fromView.frame = CGRectMake(0, -CGRectGetHeight(containerView.bounds), CGRectGetWidth(containerView.frame), CGRectGetHeight(containerView.frame));
            }
                break;
            case JKAlertAnimationStylePresentFromBottom: {
                fromView.frame = CGRectMake(0, CGRectGetHeight(containerView.bounds), CGRectGetWidth(containerView.frame), CGRectGetHeight(containerView.frame));
            }
                break;
            case JKAlertAnimationStylePresentFromLeft: {
                fromView.frame = CGRectMake(-CGRectGetWidth(containerView.frame), 0, CGRectGetWidth(containerView.frame), CGRectGetHeight(containerView.frame));
            }
                break;
            case JKAlertAnimationStylePresentFromRight: {
                fromView.frame = CGRectMake(CGRectGetWidth(containerView.frame), 0, CGRectGetWidth(containerView.frame), CGRectGetHeight(containerView.frame));
            }
                break;
            case JKAlertAnimationStylePopup:{
                
                fromView.alpha = 0;
            }
                break;
            default:
                break;
        }
    } completion:^(BOOL finished) {
        [self.backgroundView removeFromSuperview];
        [dimmingView removeFromSuperview];
        [fromView removeFromSuperview];
        [transitionContext completeTransition:YES];
    }];
}



@end
