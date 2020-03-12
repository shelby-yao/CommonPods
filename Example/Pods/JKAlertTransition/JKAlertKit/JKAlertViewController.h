//
//  JKAlertViewController.h
//  JKAlertRelated
//
//  Created by zhangjie on 2018/7/17.
//  Copyright © 2018年 zhangjie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKAlertEnum.h"
static NSString *const JKAlertViewControllerViewDidAppear = @"JKAlertViewControllerViewDidAppear";
static NSString *const JKAlertViewControllerviewDidDisappear = @"JKAlertViewControllerviewDidDisappear";

@interface JKAlertViewController : UIViewController
@property(nonatomic,strong)UIView *content;
@property (nonatomic, assign, getter=isAutoFall) BOOL autoFall;//default is YES;
@property (nonatomic, assign) JKAlertAnimationStyle animationStyle;
- (instancetype)initWithAnimationStyle:(JKAlertAnimationStyle)animationStyle;
@end
