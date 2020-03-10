
//
//  NSURLProtocol+WebKitSupport.h
//  NSURLProtocol+WebKitSupport
//
//  Created by Jekin on 2019/2/26.
//  Copyright © 2018年 liumaoqiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURLProtocol (WebKitSupport)

+ (BOOL)wk_registerClass:(Class)protocolClass;

+ (void)wk_unregisterClass:(Class)protocolClass;

@end
