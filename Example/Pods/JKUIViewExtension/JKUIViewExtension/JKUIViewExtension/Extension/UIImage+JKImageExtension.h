//
//  UIImage+JKImageExtension.h
//  JKUIViewExtension
//
//  Created by zhangjie on 2018/4/14.
//  Copyright © 2018年 zhangjie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (JKImageExtension)

//create with Color
+ (UIImage *)imageWithTintColor:(UIColor *)color withSize:(CGSize)size;
//The color of a point in the image
- (UIColor *)imageColorAtPoint:(CGPoint)point;
@end
