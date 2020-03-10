//
//  UIScrollView+SMEmptyData.m
//  SmartHome
//
//  Created by Jekin on 2018/9/3.
//  Copyright © 2018年 liumaoqiang. All rights reserved.
//

#import "UIScrollView+SMEmptyData.h"
#import <objc/runtime.h>
@implementation UIScrollView (SMEmptyData)
@dynamic smEmptyDataView;
@dynamic smErrorView;
@dynamic smScrollViewDataError;

- (void)setSmErrorView:(UIView *)smErrorView {
    objc_setAssociatedObject(self, @selector(smErrorView), smErrorView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)smErrorView {
    return objc_getAssociatedObject(self, @selector(smErrorView));
}
- (void)setDelegates:(NSHashTable<id<SMEmptyDataSource>> *)delegates {
    objc_setAssociatedObject(self, @selector(delegates), delegates, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSHashTable<id<SMEmptyDataSource>> *)delegates {
    NSHashTable *table = objc_getAssociatedObject(self, @selector(delegates));
    if (!table) {
        table = [NSHashTable hashTableWithOptions:NSPointerFunctionsWeakMemory];
        objc_setAssociatedObject(self, @selector(delegates), table, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return table;
}

- (void)setSmEmptyDataView:(UIView *)smEmptyDataView {
    objc_setAssociatedObject(self, @selector(smEmptyDataView), smEmptyDataView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)smEmptyDataView {
     return objc_getAssociatedObject(self, @selector(smEmptyDataView));
}

- (void)setSmScrollViewDataError:(NSError *)smScrollViewDataError {
    objc_setAssociatedObject(self, @selector(smScrollViewDataError), smScrollViewDataError, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSError *)smScrollViewDataError {
   return objc_getAssociatedObject(self, @selector(smScrollViewDataError));
}


- (void)setIsShowErrorView:(BOOL)isShowErrorView {
    objc_setAssociatedObject(self, @selector(isShowErrorView), @(isShowErrorView), OBJC_ASSOCIATION_ASSIGN);
}
- (BOOL)isShowErrorView {
    NSNumber *numVaue = objc_getAssociatedObject(self, @selector(isShowErrorView));
    return [numVaue boolValue];
}


- (void)smEmptyData_becomeDelegateWithEmptyDataView:(UIView *)emptyDataView andWithErrorView:(UIView *)errorView {
    self.emptyDataSetDelegate = self;
    self.emptyDataSetSource = self;
    self.smEmptyDataView = emptyDataView;
    self.smErrorView = errorView;
    
}

- (void)setEmptyDataDelegate:(id<SMEmptyDataSource>)delegate {
    [self.delegates  addObject:delegate];
}
- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView {
    
    if (self.smScrollViewDataError) {
        self.smErrorView.hidden = NO;
        return self.smErrorView;
    }
    self.smEmptyDataView.hidden = NO;
    return self.smEmptyDataView;
}

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    id <SMEmptyDataSource> delegate = self.delegates.allObjects.firstObject;
    if ([delegate respondsToSelector:@selector(smEmptyData_ShouldDisplay:)]) {
        return [delegate smEmptyData_ShouldDisplay:scrollView];
    }
    return YES;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    id <SMEmptyDataSource> delegate = self.delegates.allObjects.firstObject;
    if ([delegate respondsToSelector:@selector(smEmptyData_ShouldAllowScroll:)]) {
        return [delegate smEmptyData_ShouldAllowScroll:scrollView];
    }
    return NO;
}

- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView {
    return YES;
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    id <SMEmptyDataSource> delegate = self.delegates.allObjects.firstObject;
    if ([delegate respondsToSelector:@selector(smEmptyData_spaceHeightForEmptyDataSet:)]) {
        return [delegate smEmptyData_spaceHeightForEmptyDataSet:scrollView];
    }
    return 11;
}
@end
