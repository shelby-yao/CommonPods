//  UITextView+Placeholder.h
//  TextViewPlaceHolderDemo
//
//  Created by zhangjie on 2017/8/16.
//  Copyright © 2017年 zhangjie. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface UITextView (JKPlaceholder)
@property (nonatomic, readonly)UILabel *placeholderLabel;
@property (nonatomic, strong)NSString *placeholder;
@property (nonatomic, strong)NSAttributedString *attributedPlaceholder;
@property (nonatomic, strong)UIColor *placeholderColor;

+ (UIColor *)defaultPlaceholderColor;

@end
