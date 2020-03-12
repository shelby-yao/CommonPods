//
//  TMJSONResponseSerializer.h
//  BusinessPods
//
//  Created by Shelby on 2019/11/30.
//

#import <Foundation/Foundation.h>
#import "JKNetworking.h"
//NS_ASSUME_NONNULL_BEGIN
static NSString *const JsonResponseSerializerKey = @"body";
static NSString *const JsonResponseSerializerBodyKey = @"statusCode";
@interface JJJSONResponseSerializer: AFJSONResponseSerializer
+ (instancetype)create;
@end

//NS_ASSUME_NONNULL_END
