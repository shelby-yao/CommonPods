//
//  JKAlertViewController.m
//  JKAlertRelated
//
//  Created by zhangjie on 2018/7/17.
//  Copyright © 2018年 zhangjie. All rights reserved.
//

#import "JKAlertViewController.h"
#import "JKAlertTransitionAnimator.h"
@interface JKAlertViewController()<UIViewControllerTransitioningDelegate>
@property (nonatomic, strong) UIControl *panel;
@property (nonatomic, strong) UIView *backgroundView;
@property(nonatomic,strong)JKAlertTransitionAnimator *transitionAnimator;
@end
@implementation JKAlertViewController{
    UIInterfaceOrientationMask _presentingViewControllerSupportedInterfaceOrientations;
    BOOL _viewWillAppear;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self initDatas];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initDatas];
    }
    return self;
}

- (void)loadView {
    self.view = self.panel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return _presentingViewControllerSupportedInterfaceOrientations;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!_viewWillAppear) {
        UIViewController *presentingVC = self.presentingViewController;
        _presentingViewControllerSupportedInterfaceOrientations = [presentingVC supportedInterfaceOrientations];
        _viewWillAppear = YES;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:JKAlertViewControllerViewDidAppear object:self];
    if (self.isBeingPresented) {
        self.backgroundView.frame = self.presentationController.containerView.bounds;
        [self.presentationController.containerView insertSubview:self.backgroundView belowSubview:self.view];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionForTapGes:)];
        [self.backgroundView addGestureRecognizer:tap];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:JKAlertViewControllerviewDidDisappear object:self];
    if (self.isBeingDismissed) {
        [self.backgroundView removeFromSuperview];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return [UIApplication sharedApplication].statusBarStyle;
}

- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {
    [super presentViewController:viewControllerToPresent animated:flag completion:completion];
}

#pragma mark - private method
- (void)initDatas {
    self.autoFall = YES;
    self.modalPresentationStyle = UIModalPresentationCustom;
    self.transitioningDelegate = self;
}

#pragma mark - public method
- (instancetype)initWithAnimationStyle:(JKAlertAnimationStyle)animationStyle {
    if (self = [super init]) {
        self.animationStyle = animationStyle;
    }
    return self;
}

#pragma mark - UIViewControllerTransitioningDelegate
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    self.transitionAnimator = [JKAlertTransitionAnimator animatorWithMode:JKAlertAnimationModePresent animationStyle:self.animationStyle];
    self.transitionAnimator.content = self.content;
    return self.transitionAnimator;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    self.transitionAnimator.animationMode = JKAlertAnimationModeDismiss;
    self.transitionAnimator.animationStyle = self.animationStyle;
    return self.transitionAnimator;
}

#pragma mark - action method
- (void)actionForTapGes:(UITapGestureRecognizer *)tapGes {
    CGPoint pt = [tapGes locationInView:self.view];
    UIView *v = [self.view hitTest:pt withEvent:nil];
    if (v != self.view) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)dismiss {
    if (self.isAutoFall) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - setter & getter method
- (UIControl *)panel {
    if (!_panel) {
        _panel = [[UIControl alloc] init];
        [_panel addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _panel;
}

- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] init];
    }
    return _backgroundView;
}


@end
