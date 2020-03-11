//
//  JKAlertEnum.h
//  JKAlertRelated
//
//  Created by zhangjie on 2018/7/17.
//  Copyright © 2018年 zhangjie. All rights reserved.
//

#ifndef JKAlertEnum_h
#define JKAlertEnum_h


typedef NS_ENUM(NSInteger, JKAlertAnimationStyle) {
    JKAlertAnimationStylePresentFromTop,      // 顶部弹出
    JKAlertAnimationStylePresentFromBottom,   // 底部弹出
    JKAlertAnimationStylePresentFromLeft,     // 左边弹出
    JKAlertAnimationStylePresentFromRight,    // 右边弹出
    JKAlertAnimationStylePopup                // 中间弹出
};

typedef NS_ENUM(NSInteger, JKAlertAnimationMode) {
    JKAlertAnimationModePresent,              // 弹出
    JKAlertAnimationModeDismiss               // 消失
};

#endif /* JKAlertEnum_h */
