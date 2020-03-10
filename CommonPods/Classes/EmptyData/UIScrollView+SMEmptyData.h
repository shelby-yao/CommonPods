//
//  UIScrollView+SMEmptyData.h
//  SmartHome
//
//  Created by Jekin on 2018/9/3.
//  Copyright © 2018年 liumaoqiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIScrollView+EmptyDataSet.h"
@protocol SMEmptyDataSource <NSObject>
@optional
/**
 什么时候展示空数据视图
 
 @param scrollView scrollview
 @return defalut is YES 常态展示,不做条件判断显示
 */
- (BOOL)smEmptyData_ShouldDisplay:(UIScrollView *)scrollView;

/**
 是否允许滚动
 
 @param scrollView 下拉滚动通常会响应刷新控件方法
 @return defalut is NO
 */
- (BOOL)smEmptyData_ShouldAllowScroll:(UIScrollView *)scrollView;

/**
 视图垂直间距
 
 @param scrollView scrollView description
 @return return value defalut is 11
 */
- (CGFloat)smEmptyData_spaceHeightForEmptyDataSet:(UIScrollView *)scrollView;
@end
@interface UIScrollView (SMEmptyData)<DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>

@property (nonatomic,strong,readonly) NSHashTable<id<SMEmptyDataSource>> *delegates;

//空数据视图,暴露出来为了设置某写空数据视图的值可能会改变
@property(nonatomic,strong,readonly)UIView *smEmptyDataView;
//错误数据视图,同理
@property(nonatomic,strong,readonly)UIView *smErrorView;
//错误数据是否存在,有值就显示错误视图,没值显示空数据视图,在数据返回时进行赋值操作
@property(nonatomic,strong,nullable)NSError *smScrollViewDataError;

- (void)setEmptyDataDelegate:(id<SMEmptyDataSource>)delegate;
/**
 初始化两个视图用于显示空数据or错误数据视图
 
 @param emptyDataView 空数据视图
 @param errorView 错误数据视图
 */
- (void)smEmptyData_becomeDelegateWithEmptyDataView:(UIView *)emptyDataView andWithErrorView:(UIView *)errorView;
@end
