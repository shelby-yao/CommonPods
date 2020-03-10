//
//  SMWebViewController.m
//  SmartHome
//
//  Created by Jekin on 2018/7/25.
//  Copyright © 2018年 liumaoqiang. All rights reserved.
//

#import "JJWebViewController.h"

#import <JKUIViewExtension/UIColor+hex.h>
#import "JJURLProtocol.h"
#import "NSURLProtocol+WebKitSupport.h"
#import "NSString+JJExtension.h"
#import "JJURLHelper.h"
#import "JJWeakProxy.h"
@class IHWebViewBridgeItem;
static NSMutableDictionary<NSString *, NSArray<IHWebViewBridgeItem *> *> *_webBridgeItemDictionary;
@interface IHWebViewBridgeItem : NSObject
@property (nonatomic, strong) Class regClass;
@property (nonatomic, strong) id<JJWebBridgeModuleProtocol> regInstance;
@end
@implementation IHWebViewBridgeItem
- (id<JJWebBridgeModuleProtocol>)regInstance {
    if (!_regInstance) {
        if ([_regClass conformsToProtocol:@protocol(JJWebBridgeModuleProtocol)]) {
            _regInstance = [[_regClass alloc] init];
        }
    }
    return _regInstance;
}
@end


@implementation WeakScriptMessageDelegate

- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate {
    self = [super init];
    if (self) {
        _scriptDelegate = scriptDelegate;
    }
    return self;
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    [self.scriptDelegate userContentController:userContentController didReceiveScriptMessage:message];
}

@end

@interface JJWebViewController ()

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, assign) double estimatedProgress;
@property (nonatomic, strong) NSMutableDictionary<NSString *,id> *jsDictionary;
@property (nonatomic, strong) NSURLRequest *currentUrlRequest;
@property (nonatomic, strong) UIProgressView *progressView;
@end

@implementation JJWebViewController
- (void)dealloc {
    [_webView stopLoading];
    [_webView.configuration.userContentController removeAllUserScripts];
    [_jsDictionary removeAllObjects];
    @try {
        [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
        [_webView removeObserver:self forKeyPath:@"title"];
    } @catch(NSException *e) { }
    // TODO:
    //    [NSURLProtocol wk_unregisterClass:[IHURLProtocol class]];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    // TODO:
    //    [NSURLProtocol wk_registerClass:[IHURLProtocol class]];
    return [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.tintColor  = [UIColor colorFromHexValue:0x333333];
    [self.view addSubview:self.webView];
    [self.view addSubview:self.progressView];
    self.webView.scrollView.backgroundColor = [UIColor colorFromHexValue:0xF5F5F5];
    self.webView.scrollView.decelerationRate = 0.998f;
    self.automaticallyAdjustsScrollViewInsets = YES;
    [self.view setNeedsUpdateConstraints];
    [self.view updateConstraintsIfNeeded];
    [self loadWithRequest:self.currentUrlRequest];
}
- (void)loadWithRequest:(NSURLRequest *)request {
    self.currentUrlRequest = request;
    if (self.isViewLoaded) {
        [self.webView loadRequest:request];
    }
}
- (void)loadWithUrl:(NSString *)urlString {
    NSURL *url = [NSURL URLWithString:urlString];
    if (!url) {
        return;
    }
    
    NSString *scheme = [url scheme];
    if (scheme && ([scheme caseInsensitiveCompare:@"http"] == NSOrderedSame ||
                   [scheme caseInsensitiveCompare:@"https"] == NSOrderedSame)) {
        NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
        [self loadWithRequest:[req copy]];
    } else {
        NSURL *fileUrl = [NSURL fileURLWithPath:url.absoluteString];
        NSError *error = nil;
        NSString *htmlString = [[NSString alloc] initWithContentsOfURL:fileUrl encoding:NSUTF8StringEncoding error:&error];
        if (!error) {
            [self.webView loadHTMLString:htmlString baseURL:fileUrl];
        }
    }
}
+ (void) registerBridge:(NSString *)scheme withClass:(Class)clazz {
    if (scheme.length == 0) {
        return;
    }
    
    if (![clazz conformsToProtocol:@protocol(JJWebBridgeModuleProtocol)]) {
        return;
    }
    
    if (_webBridgeItemDictionary == nil) {
        _webBridgeItemDictionary = [NSMutableDictionary dictionary];
    }
    
    NSMutableArray<IHWebViewBridgeItem *> *bridgeItems = [[_webBridgeItemDictionary objectForKey:scheme] mutableCopy];
    if (bridgeItems == nil) {
        bridgeItems = [NSMutableArray array];
    }
    
    IHWebViewBridgeItem *bridgeItem = [[IHWebViewBridgeItem alloc] init];
    bridgeItem.regClass = clazz;
    [bridgeItems addObject:bridgeItem];
    
    _webBridgeItemDictionary[scheme] = [bridgeItems copy];
}
- (void)updateViewConstraints {
    [super updateViewConstraints];
    self.webView.frame = self.view.bounds;
    CGRect proRect = CGRectMake(0, self.webView.frame.origin.y, self.view.bounds.size.width, 2);
    self.progressView.frame = proRect;
}


#pragma mark KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.estimatedProgress = [change[NSKeyValueChangeNewKey] doubleValue];
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self.delegate respondsToSelector:@selector(webViewLoad:progress:)]) {
                [self.delegate webViewLoad:self progress:self.estimatedProgress];
            }
        });
    }
    if ([object isEqual:self.webView]) {
        if ([keyPath isEqualToString:@"title"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.title = self.webView.title;
            });
        }
    }
}
- (void)closeOrBack {
    if (self.webView.canGoBack) {
        [self.webView goBack];
    } else {
        if (self.navigationController.childViewControllers.firstObject == self) {
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}
#pragma mark JS
- (void)webCallbackWithEvent:(NSString *)event param:(id)param cbparam:(id)cbparam {
    
    if (event.length == 0) {
        return;
    }
    
    if (!param) {
        param = @{};
    }
    
    if (!cbparam) {
        cbparam = @{};
    }
    
    NSString *paramJson = [self objectToJson:param];
    NSString *cbparamJson = [self objectToJson:cbparam];
    
    NSString *js = [NSString stringWithFormat:@"(function(){var evt = new window.Event('%@'); evt.param = %@; evt.cbparam= %@; window.document.dispatchEvent(evt);})();",event, paramJson ,cbparamJson];
    [self evaluateJavaScript:js completionHandler:nil];
}

- (void)evaluateJavaScript:(NSString *)javaScriptString completionHandler:(void (^)(id, NSError *))completionHandler {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.webView evaluateJavaScript:javaScriptString completionHandler:completionHandler];
    });
}

- (void)javaScriptObserver:(id)observer selector:(SEL)aSelector {
    NSString *selectorString = NSStringFromSelector(aSelector);
    NSString *funName = [selectorString componentsSeparatedByString:@":"].firstObject;
    JJWeakProxy *ob = [JJWeakProxy proxyWithTarget:observer];
    [self.jsDictionary setObject:ob forKey:funName];
    [self.webView.configuration.userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc]initWithDelegate:self] name:funName];
}
// message: 收到的脚本信息.
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    id observer = [self.jsDictionary objectForKey:message.name];
    if (observer) {
        SEL aSelector = NSSelectorFromString(message.name);
        if ([observer respondsToSelector:aSelector]) {
            IMP imp = [observer methodForSelector:aSelector];
            void (*func)(id, SEL) = (void *)imp;
            func(observer, aSelector);
        } else {
            aSelector = NSSelectorFromString([message.name stringByAppendingString:@":"]);
            if ([observer respondsToSelector:aSelector]) {
                IMP imp = [observer methodForSelector:aSelector];
                void (*func)(id, SEL, id) = (void *)imp;
                func(observer, aSelector, message.body);
            }
        }
    }
}

#pragma mark - PRIVATEMETHOD
- (NSString *)objectToJson:(id)object{
    NSData *data = [NSJSONSerialization dataWithJSONObject:object options:0 error:NULL];
    if (data.length == 0)return  nil;
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
}
#pragma mark - WKNavigationDelegate
#pragma mark - WKNavigationDelegate

// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    if ([self.delegate respondsToSelector:@selector(webViewDidStartLoad:)]) {
        [self.delegate webViewDidStartLoad:self];
    }
}

// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    if ([self.delegate respondsToSelector:@selector(webViewDidCommitNavigation:)]) {
        [self.delegate webViewDidCommitNavigation:self];
    }
}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    if ([self.delegate respondsToSelector:@selector(webViewDidFinishLoad:action:)]) {
        [self.delegate webViewDidFinishLoad:self action:navigation];
    }
}

// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(nonnull NSError *)error {
    
    if ([self.delegate respondsToSelector:@selector(webView:didFailLoadWithError:)]) {
        [self.delegate webViewController:self didFailLoadWithError:error];
    }
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    if ([self.delegate respondsToSelector:@selector(webView:didFailLoadWithError:)]) {
        [self.delegate webViewController:self didFailLoadWithError:error];
    }
}

-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSURL *crtUrl = navigationAction.request.URL;
    
    
    if (navigationAction.navigationType == WKNavigationTypeLinkActivated) {
        dispatch_async(dispatch_get_main_queue(), ^{
            JJWebViewController *webVC = [[JJWebViewController alloc] init];
            [webVC loadWithUrl:navigationAction.request.URL.absoluteString];
            [self.navigationController pushViewController:webVC animated:YES];
        });
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    
    
    WKNavigationActionPolicy actionPolicy = WKNavigationActionPolicyAllow; // default
    NSArray<IHWebViewBridgeItem *> *bridgeItems = [_webBridgeItemDictionary objectForKey:crtUrl.scheme];
    actionPolicy = bridgeItems.count ? WKNavigationActionPolicyCancel : WKNavigationActionPolicyAllow;
    
    for (IHWebViewBridgeItem *bridgeItem in bridgeItems) {
        JJURLHelper *data = [JJURLHelper URLWithString:[crtUrl.absoluteString URLDecodedString]];
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([bridgeItem.regInstance respondsToSelector:@selector(webBridgeWithScheme:bridge:data:navigationType:webViewController:)]) {
                [bridgeItem.regInstance webBridgeWithScheme:crtUrl.scheme bridge:data.host data:data navigationType:(IHWebViewNavigationType)navigationAction.navigationType webViewController:self];
                
            }
        });
    }
    
    if ([self.delegate respondsToSelector:@selector(webViewController:shouldStartLoadWithRequest:navigationType:action:)]) {
        actionPolicy = [self.delegate webViewController:self shouldStartLoadWithRequest:navigationAction.request navigationType:(IHWebViewNavigationType)navigationAction.navigationType action:navigationAction]? WKNavigationActionPolicyAllow : WKNavigationActionPolicyCancel;;
        
    }
    if(actionPolicy == WKNavigationActionPolicyAllow) {
        if(navigationAction.targetFrame == nil) {
            [webView loadRequest:navigationAction.request];
        }
    }
    decisionHandler(actionPolicy);
}



#pragma mark set/get


- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandle {
    NSHTTPURLResponse *response = (NSHTTPURLResponse *)navigationResponse.response;
    NSArray *cookies =[NSHTTPCookie cookiesWithResponseHeaderFields:[response allHeaderFields] forURL:response.URL];
    self.cookie = [cookies componentsJoinedByString:@";"];
    decisionHandle(WKNavigationResponsePolicyAllow);
}

/**
 iOS8系统下，自建证书的HTTPS链接，不调用此代理方法; 9.0以上正常，除非是认证证书
 */
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler {
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        if ([challenge previousFailureCount] == 0) {
            NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
            completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
        } else {
            completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
        }
    } else {
        completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
    }
}

#pragma mark - WKUIDelegate

// 弹出警告框
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定",nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if(completionHandler)
            completionHandler();
    }];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:alertAction];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
}

// 弹出确认框
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(nonnull NSString *)message initiatedByFrame:(nonnull WKFrameInfo *)frame completionHandler:(nonnull void (^)(BOOL))completionHandler {
    UIAlertAction *alertActionCancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消",nil)style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }];
    UIAlertAction *alertActionOK = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:alertActionCancel];
    [alertController addAction:alertActionOK];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
}

// 弹出输入框
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(nonnull NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(nonnull WKFrameInfo *)frame completionHandler:(nonnull void (^)(NSString * _Nullable))completionHandler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = defaultText;
    }];
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"确定",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *textField = alertController.textFields.firstObject;
        completionHandler(textField.text);
    }]];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
}
#pragma mark - setter

- (void)setEstimatedProgress:(double)estimatedProgress {
    _estimatedProgress = MIN(MAX(0, estimatedProgress), 1.0);
    if (_estimatedProgress == 1) {
        self.progressView.progress = 1;
        CGFloat delayTime = 1.2;
        if([self.webView.URL.absoluteString hasPrefix:@"file://"]) {
            delayTime = 1.5;
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.progressView.hidden = YES;
            self.progressView.progress = 0;
        });
    } else if (_estimatedProgress == 0) {
        self.progressView.progress = 0;
        self.progressView.hidden = YES;
    } else {
        self.progressView.hidden = NO;
        self.progressView.progress = _estimatedProgress;
    }
}

#pragma mark - getter
- (void)setCookie:(NSString *)cookie {
    WKUserScript * cookieScript = [[WKUserScript alloc] initWithSource:cookie injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
    [self.webView.configuration.userContentController addUserScript:cookieScript];
}

- (UIScrollView *)scrollView {
    return self.webView.scrollView;
}
- (NSMutableDictionary<NSString *,id> *)jsDictionary {
    if (!_jsDictionary) {
        _jsDictionary = [[NSMutableDictionary alloc] init];
    }
    return _jsDictionary;
}

- (WKWebView *)webView {
    if (!_webView) {
        WKUserContentController *userContentController = [[WKUserContentController alloc] init];
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc]init];
        config.preferences.minimumFontSize = 10.0;
        config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
        config.userContentController = userContentController;
        config.allowsInlineMediaPlayback = YES; // 允许内嵌视频播放
        
        _webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:config];
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
        
        _webView.backgroundColor = [UIColor clearColor];
        _webView.opaque = NO;
        _webView.multipleTouchEnabled = YES;
        _webView.allowsBackForwardNavigationGestures = YES;
        _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
        [_webView addObserver:self forKeyPath:@"title" options:(NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew) context:NULL];
    }
    return _webView;
}

- (UIProgressView *)progressView {
    if (_progressView == nil) {
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectZero];
        _progressView.transform = CGAffineTransformMakeScale(1, 1);
        _progressView.tintColor = [UIColor colorFromHexValue:0x28C995];
        _progressView.trackTintColor = [UIColor clearColor];
    }
    return _progressView;
}
@end
