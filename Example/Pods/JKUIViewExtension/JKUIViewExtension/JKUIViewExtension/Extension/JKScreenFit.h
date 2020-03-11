//
//  JKScreenFit.h
//  JKUIViewExtension
//
//  Created by zhangjie on 2018/5/3.
//  Copyright © 2018年 zhangjie. All rights reserved.
//

#ifndef JKScreenFit_h
#define JKScreenFit_h
#import <Foundation/Foundation.h>
NS_INLINE CGSize ScreenSize() {
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    return CGSizeMake(screenWidth, screenHeight);
}

NS_INLINE CGFloat ViewScale() {
    CGFloat screenSizeHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenSizeWidth = [UIScreen mainScreen].bounds.size.width;
    
    if (screenSizeWidth > screenSizeHeight) { //全屏时
        if (screenSizeWidth <= 480.0f) { //iPhone4
            return  0.8;
        }else if (screenSizeWidth <= 568.0f) { //iPhone5
            return  0.9;
        }
        else if (screenSizeWidth <= 667.0f) { //iPhone6和iPhone7
            return  1.0; //设计以iPhone6屏幕为标准
        }
        else//6p、7p、iPhone X
        {
            return 1.1;
        }
    }else{
        //竖屏时
        if (screenSizeHeight <= 480.0f) { //iPhone4
            return  0.8;
        }else if (screenSizeHeight <= 568.0f) { //iPhone5
            return  0.9;
        }
        else if (screenSizeHeight <= 667.0f) { //iPhone6和iPhone7
            return  1.0; //设计以iPhone6屏幕为标准
        }
        else//6p、7p、iPhone X
        {
            return 1.1;
        }
    }
}


#endif /* JKScreenFit_h */
