//
//  TMJSONResponseSerializer.m
//  BusinessPods
//
//  Created by Shelby on 2019/11/30.
//

#import "JJJSONResponseSerializer.h"

@implementation JJJSONResponseSerializer

+ (instancetype)create {
    return [super serializer];
}

- (id)responseObjectForResponse:(NSURLResponse *)response data:(NSData *)data error:(NSError * _Nullable __autoreleasing *)error {
    id jsonObject = [super responseObjectForResponse: response data: data error: error];
    if (*error != nil) {
        NSMutableDictionary *userInfo = [(*error).userInfo mutableCopy];
        [userInfo setValue:[[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding] forKey:JsonResponseSerializerKey];
        [userInfo setValue:[response valueForKey: JsonResponseSerializerBodyKey] forKey:JsonResponseSerializerBodyKey];
        NSError *newError = [NSError errorWithDomain:(*error).domain code: (*error).code userInfo:userInfo];
        *error = newError;
    }
    return jsonObject;
}
@end
