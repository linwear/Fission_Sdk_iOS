//
//  FBWebViewController.m
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023/1/6.
//

#import "FBWebViewController.h"
#import <WebKit/WebKit.h>

@interface FBWebViewController () <WKNavigationDelegate, WKUIDelegate>

@property (nonatomic, strong) WKWebView *webView;

@property (nonatomic, strong) UIProgressView *progressView;

@end

@implementation FBWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 创建WKWebview
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    configuration.userContentController = [WKUserContentController new];
    WKPreferences *preferences = [WKPreferences new];
    preferences.javaScriptCanOpenWindowsAutomatically = YES;
    preferences.minimumFontSize = 14.0;
    configuration.preferences = preferences;
    self.webView = ({
        WKWebView * webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, NavigationContentTop, SCREEN_WIDTH, SCREEN_HEIGHT-NavigationContentTop) configuration:configuration];
        webView.UIDelegate = self;
        webView.navigationDelegate = self;
        [self.view addSubview:webView];
        webView;
    });
    
    // 加载提示进度条
    self.progressView = ({
        UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, NavigationContentTop, SCREEN_WIDTH, 1)];
        progressView.tintColor = UIColor.redColor;
        progressView.trackTintColor = UIColorGray;
        [self.view addSubview:progressView];
        progressView;
    });
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:self.url];
    [self.webView loadRequest:request];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - KVO 计算wkWebView进度条
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self.webView && [keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        if (newprogress == 1) {
            [self.progressView setProgress:1.0 animated:YES];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.progressView.hidden = YES;
                [self.progressView setProgress:0 animated:NO];
            });
            
        }else {
            self.progressView.hidden = NO;
            [self.progressView setProgress:newprogress animated:YES];
        }
    }
}

#pragma mark - WKUIDelegate
//服务器开始请求的时候调用
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [webView evaluateJavaScript:@"document.getElementById('mobile').value"completionHandler:^(id result,NSError *_Nullable error) {
        //获取页面高度，并重置webview的frame
        
    }];
    
    if (StringIsEmpty(self.navigationItem.title)) {
        self.navigationItem.title = self.webView.title;
    }
}

// 内容加载失败时候调用
-(void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    error = [LWNetworkingManager timeError:error];
    [NSObject showHUDText:error.localizedDescription];
}
//跳转失败的时候调用
-(void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    error = [LWNetworkingManager timeError:error];
    [NSObject showHUDText:error.localizedDescription];
}

//开始加载
-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    //开始加载的时候，让加载进度条显示
    self.progressView.hidden = NO;
}

//内容返回时调用
-(void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    
}

//服务器请求跳转的时候调用
-(void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    
}
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    [NSObject showHUDText:message];
}

#pragma mark ==================移除监听网页加载进度条===================
- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

@end
