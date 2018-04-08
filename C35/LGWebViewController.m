//
//  WebViewController.m
//  JianGuo
//
//  Created by apple on 16/3/23.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import "LGWebViewController.h"
#import "NetWorkStatusManager.h"

@interface LGWebViewController ()<WKNavigationDelegate,WKUIDelegate,UINavigationControllerDelegate,UIGestureRecognizerDelegate>

@property (nonatomic,strong) WKWebView *webView;
@property (nonatomic,strong) UIProgressView *progressView;
@property (nonatomic,strong) UIView *line;

@end

@implementation LGWebViewController

-(UIStatusBarStyle)preferredStatusBarStyle
{
    
    return UIStatusBarStyleDefault;
}

-(WKWebView *)webView
{
    if (!_webView) {
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, LGScreenWidth, LGScreenHeight)];
        _webView.navigationDelegate = self;
        _webView.UIDelegate = self;
    }
    return _webView;
}

-(void)reloadData
{
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NetWorkStatusManager *netManager = [NetWorkStatusManager manager];
    if (netManager.currentStatus == NotReachable) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"No NetWork!" message:nil preferredStyle:UIAlertControllerStyleAlert] ;
        UIAlertAction *actin = [UIAlertAction actionWithTitle:@"Sure" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        }];
        [alert addAction:actin];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self.view.window.rootViewController presentViewController:alert animated:YES completion:nil];
        });
    }
    
    self.navigationItem.title = @"用户协议";
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    
    [self.view addSubview:self.webView];
    
    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    
    self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    self.progressView.frame = CGRectMake(0, 0, LGScreenWidth, 10);
    self.progressView.backgroundColor = [UIColor whiteColor];
    self.progressView.progressTintColor = [UIColor blueColor];
    [self.view addSubview:self.progressView];
    
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    NSDictionary *attributeDic = @{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:LGTextMainColor};
//    [self.navigationController.navigationBar setTitleTextAttributes:attributeDic];
//
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:WhiteColor] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController setNavigationBarHidden:NO animated:NO];
//    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.xql_height-1, LGScreenWidth, 1)];
//    line.backgroundColor = LGMainBackGroundColor;
//    [self.navigationController.navigationBar addSubview:line];
//    self.line = line;
//
//    UIButton *backButton = self.navigationItem.leftBarButtonItem.customView;
//    [backButton setImage:[UIImage imageNamed:@"return_dark_icon"] forState:UIControlStateNormal];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    NSDictionary *attributeDic = @{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:WhiteColor};
//    [self.navigationController.navigationBar setTitleTextAttributes:attributeDic];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"background"] forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.tintColor = WhiteColor;
//    [self.line removeFromSuperview];
    
}


-(void)collect:(UIButton *)sender
{
    
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"title"]) {
//        self.title = self.webView.title;
    }else if( [keyPath isEqualToString: @"estimatedProgress"]) {
        [self.progressView setProgress:self.webView.estimatedProgress animated:YES];
        if (self.webView.estimatedProgress == 1) {
            self.progressView.hidden = YES;
        }
    }
}
// 允许多个手势并发,不然 webview 会导致导航右滑返回手势失效
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return NO;
}

//MARK: -  WKNavigationDelegate
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    
    
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation
{
    
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation
{
    
}
//- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(nonnull WKNavigationAction *)navigationAction decisionHandler:(nonnull void (^)(WKNavigationActionPolicy))decisionHandler {
//    if ([[SensorsAnalyticsSDK sharedInstance] showUpWebView:webView WithRequest:navigationAction.request]) {
//        decisionHandler(WKNavigationActionPolicyCancel);
//        return;
//    }
//    // 在这里添加您的逻辑代码
//    
//    decisionHandler(WKNavigationActionPolicyAllow);
//}

//MARK: - WKUIDelegate
- (nullable WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures
{
    return [[WKWebView alloc] init];
}

-(void)dealloc
{
    [self.webView removeObserver:self forKeyPath:@"title"];
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}


@end
