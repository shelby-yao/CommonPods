//
//  IHURLHelper.h
//  CommonPods
//
//  Created by Jekin on 2019/6/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JJURLHelper : NSObject

/**
 *  scheme
 */
@property (strong, nonatomic, readonly) NSString *scheme;

/**
 *  host
 */
@property (strong, nonatomic, readonly) NSString *host;

/**
 *  path
 */
@property (strong, nonatomic, readonly) NSString *path;

/**
 *  URL 中的参数列表
 */
@property (strong, nonatomic, readonly) NSDictionary *params;

/**
 *  URL String
 */
@property (strong, nonatomic, readonly) NSString *absoluteString;

/**
 *  从 URL 字符串创建 URLEntity
 *
 *  @param urlString url
 *
 *  @return 对应的 URLEntity
 */
+ (instancetype)URLWithString:(NSString *)urlString;



@end

NS_ASSUME_NONNULL_END
