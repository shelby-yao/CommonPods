//
//  UIImage+JKImageExtension.m
//  JKUIViewExtension
//
//  Created by zhangjie on 2018/4/14.
//  Copyright © 2018年 zhangjie. All rights reserved.
//

#import "UIImage+JKImageExtension.h"

@implementation UIImage (JKImageExtension)

+(UIImage *)imageWithTintColor:(UIColor *)color withSize:(CGSize)size {
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
    [color setFill];
    CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, size.width, size.height));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


- (UIColor *)imageColorAtPoint:(CGPoint)point {
    if (!CGRectContainsPoint(CGRectMake(0.0f, 0.0f, self.size.width, self.size.height), point)) {
        return nil;
    }
    NSInteger pointX = trunc(point.x);
    
    NSInteger pointY = trunc(point.y);
    
    CGImageRef cgImage = self.CGImage;
    
    NSUInteger width = self.size.width;
    
    NSUInteger height = self.size.height;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    int bytesPerPixel = 4;
    
    int bytesPerRow = bytesPerPixel * 1;
    
    NSUInteger bitsPerComponent = 8;
    
    unsigned char pixelData[4] = { 0, 0, 0, 0 };
    
    CGContextRef context = CGBitmapContextCreate(pixelData, 1, 1, bitsPerComponent, bytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    
    CGColorSpaceRelease(colorSpace);
    
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    
    
    // Draw the pixel we are interested in onto the bitmap context
    
    CGContextTranslateCTM(context, -pointX, pointY-(CGFloat)height);
    
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, (CGFloat)width, (CGFloat)height), cgImage);
    
    CGContextRelease(context);
    
    // Convert color values [0..255] to floats [0.0..1.0]
    
    CGFloat red = (CGFloat)pixelData[0] / 255.0f;
    
    CGFloat green = (CGFloat)pixelData[1] / 255.0f;
    
    CGFloat blue = (CGFloat)pixelData[2] / 255.0f;
    
    CGFloat alpha = (CGFloat)pixelData[3] / 255.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}
@end
