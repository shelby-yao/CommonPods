//
//  NSURLProtocol+WebKitSupport.h
//  NSURLProtocol+WebKitSupport
//
//  Created by Jekin on 2019/2/26.
//  Copyright © 2018年 liumaoqiang. All rights reserved.
//

#import "JJURLProtocol.h"

@interface JJURLProtocol ()<NSURLConnectionDelegate>
@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) NSMutableData *data;
@end

static NSString* const URLProtocolHandledKey = @"handelKey";

@implementation JJURLProtocol

+ (BOOL)canInitWithRequest:(NSURLRequest *)request{
    //只处理http和https请求
    NSString *scheme = [[request URL] scheme];
    NSLog(@"222%@",request.URL.absoluteString);
    if ( ([scheme caseInsensitiveCompare:@"http"] == NSOrderedSame ||
          [scheme caseInsensitiveCompare:@"https"] == NSOrderedSame))
    {
        //看看是否已经处理过了，防止无限循环
        if ([NSURLProtocol propertyForKey:URLProtocolHandledKey inRequest:request]) {
            return NO;
        }
        return YES;
    }
    return NO;
}

/**
 这里可以修改request，比如添加header，修改host等，并返回一个新的request

 @param request request
 @return request
 */
+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    NSLog(@"request: %@",request.URL.absoluteString);
    return request;
}

/**
 主要判断两个request是否相同，如果相同的话可以使用缓存数据

 @param a a
 @param b b
 @return bool
 */
+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)a toRequest:(NSURLRequest *)b
{
//    return NO;
    return [super requestIsCacheEquivalent:a toRequest:b];
}


- (void)startLoading
{
    NSMutableURLRequest *mutableReqeust = [[self request] mutableCopy];
    //打标签，防止无限循环
    [NSURLProtocol setProperty:@YES forKey:URLProtocolHandledKey inRequest:mutableReqeust];
    self.connection = [NSURLConnection connectionWithRequest:mutableReqeust delegate:self];
    
}



- (void)stopLoading
{
    [self.connection cancel];
}

#pragma mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSHTTPURLResponse *httpresponse = (NSHTTPURLResponse *)response;
    if([httpresponse respondsToSelector:@selector(allHeaderFields)]){
        NSLog(@"didReceiveResponse: header %@",[httpresponse allHeaderFields]);
    }
    
    NSLog(@"suggestedFilename : %@",httpresponse.suggestedFilename);
    
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
    
    self.data = [[NSMutableData alloc] init];
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    [self.data appendData:data];
    
    [self.client URLProtocol:self didLoadData:data];
}



- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
    
    NSString *jsonStr = [[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding];
    [self.client URLProtocolDidFinishLoading:self];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [self.client URLProtocol:self didFailWithError:error];
}

+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString *)host{
    return YES;
}
@end
