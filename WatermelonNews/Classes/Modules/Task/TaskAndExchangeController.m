//
//  TaskViewController.m
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/8/21.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "TaskAndExchangeController.h"
#import <WebKit/WebKit.h>
#import "UIDevice+Info.h"
#import "PackageManager.h"
#import "ProcessManager.h"
#import "BackgroundTask.h"
#import "LocalHTTPServer.h"
#import "TaskMonitor.h"
#import "UserManager.h"
#import "LoginManager.h"
#import "InviteAlertView.h"

@interface TaskAndExchangeController ()<WKUIDelegate, WKNavigationDelegate, UIScrollViewDelegate, WKScriptMessageHandler, LoginResponseDelegate>

@property (nonatomic, strong)   PackageManager      *packageManager;    /**< 安装包管理的实例对象 */
@property (nonatomic, strong)   ProcessManager      *processManager;    /**< 进程管理的实例对象 */
@property (nonatomic, strong)   BackgroundTask      *backgroundTask;    /**< 后台长时间任务 */
@property (nonatomic, strong)   ErrorResolver       *resolver;          /**< 网络错误处理者 */
@property (nonatomic, strong)   HTTPServer          *server;            /**< 本地HTTP服务器 */
@property (strong, nonatomic)   LoginManager *loginManager;

@property (strong, nonatomic) WKWebView *webView;
@property (strong, nonatomic) NSMutableURLRequest *request;
@property (strong, nonatomic) CALayer *progresslayer;
@property (strong, nonatomic) TaskMonitor *taskMonitor;
@property (copy, nonatomic) NSURL *taskUrl;

@end

@implementation TaskAndExchangeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self generateOriginUrl];
    [self initErrorResolver];
    [self initLoginManager];
    [self initPackageManager];
    [self initProcessManager];
    [self initBackgroundTask];
    
    [self verifyHttpServer];
    
    [self setupSubViews];
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self.webView loadRequest:_request];
}

- (void)initLoginManager {
    
    _loginManager = [[LoginManager alloc] init];
    _loginManager.delegate = self;
}

/**
 *  初始化安装包管理
 */
- (void)initPackageManager {
    _packageManager = [[PackageManager alloc] init];
    _packageManager.resolver = _resolver;
}

/**
 *  初始化进程管理
 */
- (void)initProcessManager {
    _processManager = [ProcessManager sharedInstance];
    _processManager.resolver = _resolver;
}

/**
 *  初始化后台任务
 */
- (void)initBackgroundTask {
    _backgroundTask = [[BackgroundTask alloc] init];
}

/**
 *  初始化错误处理器
 */
- (void)initErrorResolver {
    _resolver = [[ErrorResolver alloc] init];
}

- (void)dealloc{
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.webView removeObserver:self forKeyPath:@"title"];
}

- (void)setupSubViews
{
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    WKUserContentController *userContentController = [[WKUserContentController alloc] init];
    
    [userContentController addScriptMessageHandler:self name:@"enterAppStore"];
    [userContentController addScriptMessageHandler:self name:@"tokenInvalid"];
    [userContentController addScriptMessageHandler:self name:@"inviteFriends"];
    
    configuration.userContentController = userContentController;
    WKPreferences *preferences = [WKPreferences new];
    preferences.javaScriptCanOpenWindowsAutomatically = YES;
    configuration.preferences = preferences;
    
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64 - 49) configuration:configuration];
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
    self.webView.scrollView.delegate = self;
    [self.view addSubview:self.webView];
    _request = [NSMutableURLRequest requestWithURL:_taskUrl cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5.0];
    [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [_webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
    
    [self.webView loadRequest:_request];
    
    UIView *progress = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 3)];
    progress.backgroundColor = [UIColor clearColor];
    [self.webView addSubview:progress];
    
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, 0, 0, 3);
    layer.backgroundColor = [UIColor colorWithString:COLOR39AF34].CGColor;
    [progress.layer addSublayer:layer];
    self.progresslayer = layer;
    
    [WNLoadingView showLoadingInView:self.view];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"刷新" style:UIBarButtonItemStylePlain target:self action:@selector(freshAction)];
    
    if (self.pageType != PageTypeDetail) {
        
        [self setNavigationBarLeftItemButtonTitle:@"返回" image:@"Back"];
        @kWeakObj(self)
        self.leftItemAction = ^(UIButton *button) {
            
            if ([selfWeak.webView canGoBack]) {
                [selfWeak.webView goBack];
            } else {
                
                [selfWeak.navigationController popViewControllerAnimated:YES];
            }
        };
        self.leftButton.hidden = YES;
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(backAction:)];
        [self.navigationController.view addGestureRecognizer:pan];
    }
    

}

- (void)backAction:(UIPanGestureRecognizer *)pan
{
    if (pan.state == UIGestureRecognizerStateChanged) {
        [self commitTranslation:[pan translationInView:self.navigationController.view]];
    }
}

/**
 *   判断手势方向
 *
 *  @param translation translation description
 */
- (void)commitTranslation:(CGPoint)translation
{
    
    CGFloat absX = fabs(translation.x);
    CGFloat absY = fabs(translation.y);
    
    // 设置滑动有效距离
    if (MAX(absX, absY) < 50)
        return;
    
    if (absX > absY ) {
        
        if (translation.x<0) {
            //向左滑动
        }else{
            self.leftItemAction(nil);
            //向右滑动
        }
    }
}


- (void)freshAction
{
    [self.webView reload];
}

/**
 *  生成任务URL
 *
 */
- (void)generateOriginUrl{
    
    NSMutableString *url;
    switch (self.pageType) {
        case PageTypeTask:{
            
            url = [[NSMutableString alloc] initWithString:[UserManager currentUser].taskUrl];
            break;
        }
        case PageTypeExchange:{
            
            url = [[NSMutableString alloc] initWithString:[UserManager currentUser].exchangeUrl];
            break;
        }
        case PageTypeDetail:{
            url = [[NSMutableString alloc] initWithString: @"http://xigua.lingyongqian.cn//task/detail"];
            break;
        }
    }
    [url appendString:@"?"];
    [url appendString:@"device_id="];
    [url appendString:[[UserManager currentUser] deviceId]];
    [url appendString:@"&"];
    [url appendString:@"idfa="];
    [url appendString:[[UIDevice currentDevice] oidfa]];
    [url appendString:@"&"];
    [url appendString:@"account="];
    [url appendString:[[UIDevice currentDevice] account]];
    if (self.pageType == PageTypeDetail) {
        [url appendString:@"&"];
        [url appendString:@"id="];
        [url appendString:self.taskModel.taskId];
        [url appendString:@"&"];
        [url appendString:@"type=0"];
    }
    
    _taskUrl = [NSURL URLWithString:url];
}

//// 当内容开始返回时调用
//- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation
//{
//    [WNLoadingView hideLoadingForView:self.view];
//
//}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    //传递参数给H5页面
    NSString * jsStr = [NSString stringWithFormat:@"setInviteMoney('%@')",[NSString stringWithFormat:@"%.2f",[[UserManager currentUser].inviteReward floatValue]]];
    [webView evaluateJavaScript:jsStr completionHandler:nil];

    [WNLoadingView hideLoadingForView:self.view];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    [WNLoadingView hideLoadingForView:self.view];
}

- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView
{
    [self.webView reload];
}

// 在收到响应开始加载后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
{
    
    NSString *urlStr = [navigationResponse.response.URL.absoluteString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if ([urlStr containsString:@"share?"]) {
        // 不允许跳转
        decisionHandler(WKNavigationResponsePolicyCancel);
        return;
    }
    if ([urlStr containsString:@"task?"] || [urlStr containsString:@"cash?"]) {

        [self setNaviAndTabBar:YES];
        if (self.pageType == PageTypeDetail) {
            [self.navigationController popViewControllerAnimated:YES];
        }

    } else {
        
        [self setNaviAndTabBar:NO];

    }
    WKNavigationResponsePolicy actionPolicy = WKNavigationResponsePolicyAllow;
    //这句是必须加上的，不然会异常
    decisionHandler(actionPolicy);
}

- (void)setNaviAndTabBar:(BOOL)hidden
{
    self.leftButton.hidden = hidden;
    [UIView animateWithDuration:0.2 animations:^{
        self.tabBarController.tabBar.hidden = !hidden;
    } completion:^(BOOL finished) {
        if (hidden) {
            self.webView.height = kScreenHeight - 64 - 49;
        } else {
            self.webView.height = kScreenHeight - 64;
        }
    }];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    WKNavigationActionPolicy actionPolicy = WKNavigationActionPolicyAllow;
    //这句是必须加上的，不然会异常
    decisionHandler(actionPolicy);
}

#pragma mark - js调用OC方法

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    WNLog(@"JS 调用了 %@ 方法，传回参数 %@",message.name,message.body);
    if ([message.name isEqualToString:@"enterAppStore"]) {
        
        if ([message.body[@"type"] isEqualToString:@"DOWNLOAD"]) {
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:message.body[@"download_url"]]];

        } else {
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://"]];
        }
        [self.taskMonitor startWithBundleId:message.body[@"bundle_id"]];
        
    } else if ([message.name isEqualToString:@"tokenInvalid"]){
        
        [_loginManager login];
        // Do any additional setup after loading the view.
    } else if ([message.name isEqualToString:@"inviteFriends"]){
        
        [[InviteAlertView new] show];
        [TalkingDataApi trackEvent:TD_CLICK_TASK_INVITE];

    }
    
}

- (void)loginFailure:(NSError *)error
{
    
}

- (void)loginSuccess:(NSDictionary *)result
{
    [self.webView reload];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progresslayer.opacity = 1;
        //不要让进度条倒着走...有时候goback会出现这种情况
        if ([change[@"new"] floatValue] < [change[@"old"] floatValue]) {
            return;
        }
        self.progresslayer.frame = CGRectMake(0, 0, self.view.bounds.size.width * [change[@"new"] floatValue], 3);
        if ([change[@"new"] floatValue] == 1) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.progresslayer.opacity = 0;
            });
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.progresslayer.frame = CGRectMake(0, 0, 0, 3);
            });
        }
    }else if ([keyPath isEqualToString:@"title"]) {
        if (object == self.webView) {
            self.navigationItem.title = self.webView.title;
        } else {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    } else {
        
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma -
#pragma HTTP Server

#define WEB_ROOT [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Web"]

- (void)initHttpServer {
    _server = [[LocalHTTPServer alloc] init];
    NSError *error;
    if([_server start:&error]) {
        // 成功什么也不做
    } else {
        [self uploadError:error];
    }
}

- (void)verifyHttpServer {
    if (_server == nil ||
        ![_server isRunning] ||
        [_server listeningPort] != 9527) {
        [self initHttpServer];
    }
}

#pragma -
#pragma ApplicationSwitchDelegate Protocol Implementation

/**
 *  应用从后台转入前台时调用
 */
- (void)applicationDidEnterForeground {
    
    [self stopBackgroundTask];
}

/**
 *  应用从前台转入后台时调用
 */
- (void)applicationDidEnterBackground {
    
    [self startBackgroundTask];
}

#pragma -
#pragma Background Methods

/**
 *  开启后台任务
 */
- (void)startBackgroundTask {
    // 立即调用一次，因为后台任务第一次调用会在设置的时间之后
    [self backgroundTaskCallback];
    [_backgroundTask startBackgroundTasks:30
                                   target:self
                                 selector:@selector(backgroundTaskCallback)];
}

/**
 *  停止后台任务
 */
- (void)stopBackgroundTask {
    [_backgroundTask stopBackgroundTask];
}

/**
 *  后台任务的回调
 */
- (void)backgroundTaskCallback {
    [_packageManager uploadDevicePackage];
}

#pragma -
#pragma Upload Error & Event

/**
 *  上传错误信息到Talking Data
 *
 *  @param error 错误信息
 */
- (void)uploadError:(NSError *_Nonnull)error {
    [self uploadEvent:[error domain]
                label:[NSString stringWithFormat:@"%ld", (long)[error code]]
                param:@{
                        @"description":[error description]
                        }];
}

/**
 *  上传事件到Talking Data
 *
 *  @param event 事件
 *  @param label 标签
 */
- (void)uploadEvent:(NSString *_Nonnull)event
              label:(NSString *_Nonnull)label {
    [TalkingDataApi trackEvent:event label:label];
}

/**
 *  上传事件到Talking Data
 *
 *  @param event 事件
 *  @param label 标签
 *  @param param 参数
 */
- (void)uploadEvent:(NSString *_Nonnull)event
              label:(NSString *_Nonnull)label
              param:(NSDictionary *_Nonnull)param {
    [TalkingDataApi trackEvent:event label:label param:param];
}

- (TaskMonitor *)taskMonitor
{
    if (!_taskMonitor) {
        _taskMonitor = [TaskMonitor new];
    }
    return _taskMonitor;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
