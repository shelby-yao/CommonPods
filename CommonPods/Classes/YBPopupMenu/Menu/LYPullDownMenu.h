//
//  LYPullDownMenu.h
//  Aipai
//
//  Created by zhangjie on 2017/12/4.
//  Copyright © 2017年 www.aipai.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface LYCoverView : UIView
//点击回调
@property (nonatomic, strong) os_block_t didClickBlock;
@end
@class LYPullDownMenu;
@protocol LYPullDownMenuDataSource <NSObject>
/**
 *  下拉菜单有多少列
 *
 *  @param pullDownMenu 下拉菜单
 *
 *  @return 下拉菜单有多少列
 */
- (NSInteger)numberOfColsInMenu:(LYPullDownMenu *)pullDownMenu;

/**
 *  下拉菜单每列按钮外观
 *
 *  @param pullDownMenu 下拉菜单
 *  @param index        第几列
 *
 *  @return 下拉菜单每列按钮外观
 */
- (UIButton *)pullDownMenu:(LYPullDownMenu *)pullDownMenu buttonForColAtIndex:(NSInteger)index;

/**
 *  下拉菜单每列对应的控制器
 *
 *  @param pullDownMenu 下拉菜单
 *  @param index        第几列
 *
 *  @return 下拉菜单每列对应的控制器
 */
- (UIViewController *)pullDownMenu:(LYPullDownMenu *)pullDownMenu viewControllerForColAtIndex:(NSInteger)index;

/**
 *  下拉菜单每列对应的高度
 *
 *  @param pullDownMenu 下拉菜单
 *  @param index        第几列
 *
 *  @return 下拉菜单每列对应的高度
 */
- (CGFloat)pullDownMenu:(LYPullDownMenu *)pullDownMenu heightForColAtIndex:(NSInteger)index;

@end
@interface LYPullDownMenu : UIView
/**
 *  下拉菜单数据源
 */
@property (nonatomic, weak) id<LYPullDownMenuDataSource> dataSource;

/**
 消失和出现时间 默认0.25
 */


@property (nonatomic,assign) CGFloat enterBackground;
@property (nonatomic,assign) CGFloat enterForeground;
/**
 *  蒙版颜色
 */
@property (nonatomic, strong) UIColor *coverColor;
/**
 *  分割线颜色
 */
@property (nonatomic, strong) UIColor *separateLineColor;
/**
 *  分割线距离顶部间距，默认10
 */
@property (nonatomic, assign) NSInteger separateLineTopMargin;

/**
 按钮点击的回调
 */
@property (nonatomic,copy) void(^btnDidClick)(NSInteger btnIndex,BOOL isShow);

/**
 对应控制器消失的回调
 */
@property (nonatomic,copy) void(^dismissBlock)(UIViewController *controller) ;

/**
 展示在哪个控制器上
 */
@property (nonatomic,weak) UIViewController *showOnViewController;

/**
 是否展示
 */
@property (nonatomic,assign,readonly) BOOL isShow;
/**
 *  下拉菜单内容View
 */
@property (nonatomic, strong,readonly) UIView *contentView;
/**
 *  下拉菜单蒙版
 */
@property (nonatomic, strong,readonly) LYCoverView *coverView;
/**
 *  下拉菜单所有按钮
 */
@property (nonatomic, strong,readonly) NSMutableArray <UIButton *>*menuButtons;
//展示对应按钮控制器
- (void)showControllerForBtn:(UIButton *)btn;

//消失
- (void)dismiss;

- (void)dismissWithoutCallBack;
@end
