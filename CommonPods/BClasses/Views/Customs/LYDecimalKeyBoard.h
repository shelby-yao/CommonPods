//
//  LYDecimalKeyBoard.h
//  Aipai
//
//  Created by zhangjie on 2018/3/22.
//  Copyright © 2018年 www.aipai.com. All rights reserved.
//

#import <UIKit/UIKit.h>


/*
 Your textfile.inputView = [LYDecimalKeyBoard new];
 //实现代理
 - (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    [textField.text stringByReplacingCharactersInRange:range withString:string]);
    return YES;
 }
 */

@interface LYDecimalKeyBoard : UIView
@property (nonatomic,copy) void(^done)(void);//点击确定
@property (nonatomic,strong) UIColor *tintColor;//确定按钮颜色


@property (nonatomic,assign) BOOL isPw6Code;
- (instancetype)initWithHideDot:(BOOL)hide;
@end
