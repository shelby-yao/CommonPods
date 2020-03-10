//
//  SMWebViewController.h
//  SmartHome
//
//  Created by Jekin on 2018/7/25.
//  Copyright © 2018年 liumaoqiang. All rights reserved.
//
#import <WebKit/WebKit.h>
#import <UIKit/UIKit.h>
#import "JJURLHelper.h"
@class JJWebViewController;
typedef NS_ENUM(NSInteger, IHWebViewNavigationType) {
    IHWebViewNavigationTypeLinkActivated,   // 跳转链接
    IHWebViewNavigationTypeFormSubmitted,   // 提交表单
    IHWebViewNavigationTypeBackForward,     // 后退或前进
    IHWebViewNavigationTypeReload,          // 重新加载
    IHWebViewNavigationTypeFormResubmitted, // 重新提交表单
    IHWebViewNavigationTypeOther = -1       // 其它
};
@protocol JJWebBridgeModuleProtocol <NSObject>
@required
///协议对应  httpss://home/data({bid:123})
//协议跳转类型
- (void)webBridgeWithScheme:(NSString *)scheme bridge:(NSString *)bridge data:(JJURLHelper *)data navigationType:(IHWebViewNavigationType)navigationType webViewController:(JJWebViewController *)webViewController;

@end




@protocol IHWebViewControllerDelegate <NSObject>
- (void)webViewDidStartLoad:(JJWebViewController *)webViewController;
- (void)webViewDidCommitNavigation:(JJWebViewController *)webViewController;
- (void)webViewLoad:(JJWebViewController *)webViewController progress:(double)progress;
- (void)webViewDidFinishLoad:(JJWebViewController *)webViewController action:(WKNavigationAction *)action;
- (void)webViewController:(JJWebViewController *)webViewController didFailLoadWithError:(NSError *)error;
- (BOOL)webViewController:(JJWebViewController *)webViewController shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(IHWebViewNavigationType)navigationType action:(WKNavigationAction *)action;
@end

@interface JJWebViewController : UIViewController<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler>

/**
 注册桥接
 
 @param scheme 协议名
 @param clazz 回调遵守 IHWebBridgeModuleProtocol 协议
 */
+ (void)registerBridge:(NSString *)scheme withClass:(Class)clazz;

@property (nonatomic, copy) BOOL(^canCloseCallback)(void); ///能否关闭回调，返回YES关闭
@property (nonatomic, weak) id<IHWebViewControllerDelegate> delegate;
@property (nonatomic, readonly) NSString *documentTitle;            ///<网页标题
@property (nonatomic, strong) NSString *cookie;                     ///<可读取当前请求的cookie或者设置
@property (nonatomic, readonly) UIScrollView *scrollView;           ///<页面滑动器
@property (nonatomic, strong,readonly) NSURLRequest *currentUrlRequest;
@property (nonatomic, strong, readonly) WKWebView *webView;
@property (nonatomic, strong,readonly) UIProgressView *progressView;


/** http请求或者是本地html路径 */
- (void)loadWithUrl:(NSString *)urlString;
- (void)loadWithRequest:(NSURLRequest *)request;
- (void)closeOrBack;

/**
 web回调
 
 @param event 事件名
 @param param 回调参数
 @param cbparam 原样回调参数
 */
- (void)webCallbackWithEvent:(NSString *)event param:(id)param cbparam:(id)cbparam;

/**
 执行JS
 @param javaScriptString 脚本字符串
 @param completionHandler 执行完后回调
 */
- (void)evaluateJavaScript:(NSString *)javaScriptString completionHandler:(void (^)(id obj, NSError *error))completionHandler;

/**
 注册方法，以供JS调用
 observer 接收对象
 aSelector 方法选择器，方法名与调用的JS名相同，只带一个参数（id)
 注意：相同的方法即使不同的对象会被覆盖
 */
- (void)javaScriptObserver:(id)observer selector:(SEL)aSelector;
@end

@interface WeakScriptMessageDelegate : NSObject<WKScriptMessageHandler>

@property (nonatomic, weak) id<WKScriptMessageHandler> scriptDelegate;

- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate;

@end
