//
//  LYPullDownMenu.m
//  Aipai
//
//  Created by zhangjie on 2017/12/4.
//  Copyright © 2017年 www.aipai.com. All rights reserved.
//

#import "LYPullDownMenu.h"
#import <JKUIViewExtension/UIView+JKUIViewExtension.h>
@implementation LYCoverView
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (self.didClickBlock) self.didClickBlock();
}
@end


@interface LYPullDownMenu ()
/**
 *  下拉菜单所有分割线
 */
@property (nonatomic, strong) NSMutableArray *separateLines;
/**
 *  下拉菜单所有按钮
 */
@property (nonatomic, strong) NSMutableArray <UIButton *>*menuButtons;
/**
 *  下拉菜单每列高度
 */
@property (nonatomic, strong) NSMutableArray *colsHeight;
/**
 *  下拉菜单所有控制器
 */
@property (nonatomic, strong) NSMutableArray *controllers;
/**
 *  下拉菜单内容View
 */
@property (nonatomic, strong) UIView *contentView;
/**
 *  下拉菜单蒙版
 */
@property (nonatomic, strong) LYCoverView *coverView;

/**
 当前正在展示的控制器
 */
@property (nonatomic,weak) UIViewController *currentShowVc;
@end

@implementation LYPullDownMenu
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _enterBackground  = _enterForeground  = 0.25;
        [self setupUI];
    }
    return self;
}

- (void)dealloc {
     [self clear];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    // 布局子控件
    NSInteger count = self.menuButtons.count;
    CGFloat btnX = 0;
    CGFloat btnY = 0;
    CGFloat btnW = self.bounds.size.width / count;
    CGFloat btnH = self.bounds.size.height;
    for (NSInteger i = 0; i < count; i++) {
        // 设置按钮位置
        UIButton *btn = self.menuButtons[i];
        btnX = i * btnW;
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        
        // 设置分割线位置
        if (i < count - 1) {
            UIView *separateLine = self.separateLines[i];
            separateLine.backgroundColor = _separateLineColor;
            separateLine.frame = CGRectMake(CGRectGetMaxX(btn.frame), _separateLineTopMargin, 1, btnH - 2 * _separateLineTopMargin);
        }
    }
    
}

- (void)willMoveToWindow:(UIWindow *)newWindow{
    [super willMoveToWindow:newWindow];
    [self reload];
}
#pragma mark - privateMethod
- (void)setupUI {
    self.backgroundColor = [UIColor whiteColor];
    _separateLineTopMargin = 10;
    _separateLineColor =  [UIColor colorWithRed:221 / 255.0 green:221 / 255.0 blue:221 / 255.0 alpha:1];
    _coverColor = [UIColor colorWithRed:221 / 255.0 green:221 / 255.0 blue:221 / 255.0 alpha:.7];
}
// 刷新下拉菜单
- (void)reload{
    // 删除之前所有数据,移除之前所有子控件
    if (self.menuButtons.count) return;
    [self clear];
    if (!self.dataSource) return;
    if (![self.dataSource respondsToSelector:@selector(numberOfColsInMenu:)]) {
        @throw [NSException exceptionWithName:@"error" reason:@"未实现（numberOfColsInMenu:）" userInfo:nil];
    }
    if (![self.dataSource respondsToSelector:@selector(pullDownMenu:buttonForColAtIndex:)]) {
        @throw [NSException exceptionWithName:@"error" reason:@"pullDownMenu:buttonForColAtIndex:）" userInfo:nil];
    }
    if (![self.dataSource respondsToSelector:@selector(pullDownMenu:viewControllerForColAtIndex:)]) {
        @throw [NSException exceptionWithName:@"error" reason:@"pullDownMenu:viewControllerForColAtIndex:这个方法未实现）" userInfo:nil];
        return;
    }
    if (![self.dataSource respondsToSelector:@selector(pullDownMenu:heightForColAtIndex:)]) {
        @throw [NSException exceptionWithName:@"error" reason:@"pullDownMenu:heightForColAtIndex:这个方法未实现）" userInfo:nil];
        return;
    }
    
    // 获取有多少列
    NSInteger cols = [self.dataSource numberOfColsInMenu:self];
    
    // 没有列直接返回
    if (cols == 0) return;
    
    // 添加按钮
    for (NSInteger col = 0; col < cols; col++) {
        
        // 获取按钮
        UIButton *menuButton = [self.dataSource pullDownMenu:self buttonForColAtIndex:col];
        
        menuButton.tag = col;
        
        [menuButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        if (menuButton == nil) {
            @throw [NSException exceptionWithName:@"error" reason:@"pullDownMenu:buttonForColAtIndex:这个方法不能返回空的按钮）" userInfo:nil];
            return;
        }
        
        [self addSubview:menuButton];
        
        // 添加按钮
        [self.menuButtons addObject:menuButton];
        
        // 保存所有列的高度
        CGFloat height = [self.dataSource pullDownMenu:self heightForColAtIndex:col];
        [self.colsHeight addObject:@(height)];
        
        // 保存所有子控制器
        UIViewController *vc = [self.dataSource pullDownMenu:self viewControllerForColAtIndex:col];
        if (vc)[self.controllers addObject:vc];                            
    }
    
    // 添加分割线
    NSInteger count = cols - 1;
    for (NSInteger i = 0; i < count; i++) {
        UIView *separateLine = [[UIView alloc] init];
        separateLine.backgroundColor = [UIColor purpleColor];
        [self addSubview:separateLine];
        [self.separateLines addObject:separateLine];
    }
    // 设置所有子控件的尺寸
    [self setNeedsLayout];
    [self layoutIfNeeded];
}
- (void)clear {
    [self.menuButtons removeAllObjects];
    [self.controllers removeAllObjects];
    [self.colsHeight removeAllObjects];
    _coverView = nil;
    _contentView = nil;
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}
- (void)dismiss {
    [self dismissWithController:self.currentShowVc];
}
- (void)dismissWithoutCallBack {
    // 所有按钮取消选中
    for (UIButton *button in self.menuButtons) {
        button.selected = NO;
    }
    // 移除蒙版
    self.coverView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    [UIView animateWithDuration:_enterBackground  animations:^{
        CGRect frame = self.contentView.frame;
        frame.size.height = 0;
        self.contentView.frame = frame;
    } completion:^(BOOL finished) {
        self.coverView.hidden = YES;
        self.coverView.backgroundColor = self->_coverColor;
    }];
    
}
- (void)dismissWithController:(UIViewController *)controller {
    _isShow = NO;
    if (self.dismissBlock) self.dismissBlock(controller);
    [self dismissWithoutCallBack];
}
- (void)showControllerForBtn:(UIButton *)btn {
    [self btnClick:btn];
}
#pragma mark - actionForButton
- (void)btnClick:(UIButton *)button{
    button.selected = !button.selected;
    // 取消其他按钮选中
    for (UIButton *otherButton in self.menuButtons) {
        if (otherButton == button) continue;
        otherButton.selected = NO;
    }
    if (button.selected == YES) { // 当按钮选中，弹出蒙版
        _isShow = YES;
        if (self.btnDidClick) self.btnDidClick(button.tag, YES);
        // 添加对应蒙版
        self.coverView.hidden = NO;
        
        // 获取角标
        NSInteger i = button.tag;
        // 移除之前子控制器的View
        [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        // 添加对应子控制器的view
        UIViewController *vc = self.controllers[i];
        
        
        vc.view.frame = CGRectMake(0,0, [UIScreen mainScreen].bounds.size.width, 0);
        CGRect rect = [self convertRect:self.bounds toView:self.showOnViewController.view];
        self.coverView.y = rect.size.height+rect.origin.y;
//        self.coverView.y = 0;
        [self.contentView addSubview:vc.view];
        [self.showOnViewController.view bringSubviewToFront:self.coverView];
        self.currentShowVc = vc;
        // 设置内容的高度
        CGFloat height = [self.colsHeight[i] floatValue];
        [UIView animateWithDuration:_enterForeground animations:^{
            self.contentView.h = height;
            vc.view.frame = self.contentView.bounds;
        }];
    } else { // 当按钮未选中，收回蒙版
        if (self.btnDidClick) self.btnDidClick(button.tag,NO);
        [self dismiss];
    }
}

#pragma mark - set/get
- (NSMutableArray *)colsHeight{
    if (!_colsHeight) {
        _colsHeight = [NSMutableArray array];
    }
    return _colsHeight;
}
- (NSMutableArray *)separateLines{
    if (!_separateLines) {
        _separateLines = [NSMutableArray array];
    }
    return _separateLines;
}
- (NSMutableArray <UIButton *>*)menuButtons {
    if (!_menuButtons) {
        _menuButtons = [NSMutableArray array];
    }
    return _menuButtons;
}
- (NSMutableArray *)controllers{
    if (!_controllers) {
        _controllers = [NSMutableArray array];
    }
    return _controllers;
}
- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0);
        _contentView.clipsToBounds = YES;
        [self.coverView addSubview:_contentView];
    }
    return _contentView;
}

- (LYCoverView *)coverView {
    if (!_coverView) {
         CGRect rect = [self convertRect:self.bounds toView:UIApplication.sharedApplication.keyWindow];
        _coverView = [[LYCoverView alloc] initWithFrame:CGRectMake(0, rect.size.height+rect.origin.y, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        _coverView.backgroundColor = _coverColor;
        [self.showOnViewController.view addSubview:_coverView];
        
        __weak typeof(self) wself = self;
        _coverView.didClickBlock = ^{ // 点击蒙版调用
            __strong typeof(self) self = wself;
            if (self.btnDidClick) self.btnDidClick(0, NO);
            //找出当前选中的按钮对应的控制器
            [self dismiss];
        };
    }
    return _coverView;
}


@end
