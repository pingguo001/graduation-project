//
//  NewsDetailViewController.m
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/8/21.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "NewsDetailViewController.h"
#import <WebKit/WebKit.h>
#import "ShareAlertView.h"
#import "BottomCommentView.h"
#import "ShowCommentView.h"
#import "ReadPacketView.h"
#import "NewsReadApi.h"
#import "NewsRelevantApi.h"
#import "NewsCommentListApi.h"
#import "UserManager.h"
#import "ShareTool.h"
#import "LYVideoPlayer.h"
#import "UIDevice+Info.h"
#import "InformListViewController.h"
#import "PublishViewController.h"
#import "NewsRelevantCell.h"
#import "NewsCommentCell.h"
#import "NewsCommentModel.h"
#import "TencentAdCell.h"
#import "TencentAdModel.h"
#import "NativeExpressAdApi.h"
#import "TencentAdManager.h"
//统计相关
#import "NewsStatApi.h"
#import "NewsCommentApi.h"
#import "NewsReadTimeApi.h"
#import "VideoTitleView.h"

#define kHeaderHeight adaptNormalHeight1334(430)

@interface NewsDetailViewController ()<WKUIDelegate, WKNavigationDelegate, ShareAlertViewDelegate, BottomCommentViewDelegate, UIScrollViewDelegate, ResponseDelegate,LYVideoPlayerDelegate, WKScriptMessageHandler, UITableViewDelegate, UITableViewDataSource>
{
    BOOL _isHalfScreen;
}
@property (nonatomic ,strong) LYVideoPlayer *videoPlayer;
@property (nonatomic ,strong) UIView *videoPlayBGView;

@property (strong, nonatomic) UITableView       *tableView;
@property (strong, nonatomic) WKWebView         *webView;
@property (strong, nonatomic) CALayer           *progresslayer;

@property (strong, nonatomic) ShowCommentView   *commentView;
@property (strong, nonatomic) BottomCommentView *bottomCommentView;
@property (strong, nonatomic) VideoTitleView    *videoTitleView;

@property (strong, nonatomic) NewsReadApi        *readApi;
@property (strong, nonatomic) NewsStatApi        *statApi;
@property (strong, nonatomic) NewsCommentApi     *commentApi;
@property (strong, nonatomic) NewsReadTimeApi    *readTimeApi;
@property (strong, nonatomic) NewsRelevantApi    *relevantApi;
@property (strong, nonatomic) NewsCommentListApi *commentListApi;

@property (copy, nonatomic)   NSString  *dateKey;
@property (copy, nonatomic)   NSString  *redMoney;
@property (assign, nonatomic) NSInteger startTime;

@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) NSMutableArray *relevantArray;
@property (strong, nonatomic) NSMutableArray *commentArray;

@end

@implementation NewsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupSubViews];     //初始化子控件
    [self initAllNetWorkApi]; //初始化Api
    [self setupNavigationBar];
    [self getDateKey];
    [self requestDetailInfo];
    [self requestMoneyAndStat];
    
}

#pragma mark - 配置子控件
- (void)setupSubViews
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kTabBarHeight-kNaviBarHeight) style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.sectionHeaderHeight = adaptHeight1334(10);
    self.tableView.sectionFooterHeight = 0;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[NewsRelevantCell class] forCellReuseIdentifier:NewsRelevantCellID];
    [self.tableView registerClass:[NewsCommentCell class] forCellReuseIdentifier:NewsCommentCellID];
    [self.tableView registerClass:[TencentAdCell class] forCellReuseIdentifier:TencentAdCellID];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    if (self.model.type.integerValue == 2) {
        
        [self setupVideoHeadView]; //顶部视频播放控件
        self.tableView.y = self.videoPlayBGView.height;
        self.tableView.height = kScreenHeight - self.videoPlayBGView.height - kTabBarHeight;
        
    } else {
        [self setupArticleHeaderView];
        self.tableView.y = kNaviBarHeight;
        self.tableView.height = kScreenHeight - kNaviBarHeight - kTabBarHeight;
    }
    
    //底部评论view
    BottomCommentView *commentView = [BottomCommentView new];
    commentView.frame = CGRectMake(0, self.view.height - kTabBarHeight, kScreenWidth, kTabBarHeight);
    commentView.delegate = self;
    self.bottomCommentView = commentView;
    [commentView setCommentNumber:self.model.comment_num];
    [self.view addSubview:commentView];
    
    //上拉
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _commentListApi.encryptId = self.model.encryptId;
        _commentListApi.page++;
        [_commentListApi call];
        
    }];
    
}

- (void)setupArticleHeaderView
{
    WKWebViewConfiguration *config = [WKWebViewConfiguration new];
    //初始化偏好设置属性：preferences
    config.preferences = [WKPreferences new];
    WKUserContentController *userContentController = [[WKUserContentController alloc] init];
    
    [userContentController addScriptMessageHandler:self name:@"enterRecommend"];
    config.userContentController = userContentController;
    
    self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:config];
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
    [self.webView sizeToFit];
    [self.view addSubview:self.webView];
    [_webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",URL_BASE_NEWS,detailUrl,self.model.encryptId]]];
    [self.webView loadRequest:request];
    self.webView.scrollView.scrollEnabled = NO;
    self.webView.scrollView.bounces = NO;
    self.webView.userInteractionEnabled = NO;
    self.webView.opaque = NO;
    self.tableView.tableHeaderView = self.webView;
}

- (void)setupVideoHeadView
{
    _isHalfScreen = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.videoPlayBGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kHeaderHeight)];
    self.videoPlayBGView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.videoPlayBGView];
    
    self.videoPlayer = [[LYVideoPlayer alloc] init];
    self.videoPlayer.delegate = self;
    [self.videoPlayer playWithNewsModel:self.model showView:self.videoPlayBGView];
    
    self.navigationController.navigationBar.hidden = YES;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"InterfaceOrientationNotification" object:@"YES"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientChange:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    
    VideoTitleView *videoTitleView = [[VideoTitleView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, adaptHeight1334(180))];
    [videoTitleView confignData:self.model];
    _videoTitleView = videoTitleView;
    self.tableView.tableHeaderView = videoTitleView;
    
}

#pragma mark - 控制器生命周期相关


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.videoPlayer playWithNewsModel:self.model showView:self.videoPlayBGView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self.commentView dimiss];
    if (self.refreshAction) {
        self.refreshAction();
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"InterfaceOrientationNotification" object:@"NO"];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (self.model.type.integerValue == 2) {
        
        [self.videoPlayer stopVideo];
    }
}
//状态栏
- (BOOL)prefersStatusBarHidden
{
    if (self.model.type.integerValue == 2) {
        return YES;
    } else {
        return NO;
    }
}

- (void)dealloc{
    
    [self.webView removeObserver:self forKeyPath:@"title"];
    [self.webView.scrollView removeObserver:self forKeyPath:@"contentSize"];

    
}

#pragma mark - 初始化
//设置navigaitonBar
- (void)setupNavigationBar
{
    if ([UserManager currentUser].applicationMode.integerValue == 1) {
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"more"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonAction)];
    } else {
        
        [self setNavigationBarRightItemButtonTitle:@"转发" image:@"newspage_shareit_tab"];
        @kWeakObj(self);
        self.rightItemAction = ^(UIButton *button) {
            ShareAlertView *shareView = [ShareAlertView new];
            [shareView showShareViewDelegate:selfWeak];
        };
    }
}

//初始化相关Api
- (void)initAllNetWorkApi
{
    //统计api
    _statApi = [[NewsStatApi alloc] initWithDelegate:self articleCategory:self.model.category];
    if (self.model.type.integerValue != 2) {
        _statApi.articleIds = @[self.model.articleId];
    } else {
        _statApi.videoIds = @[self.model.articleId];
    }
    //评论api
    _commentApi = [[NewsCommentApi alloc] initWithDelegate:self articleId:self.model.articleId];
    [self commentResult];  //评论的回调
    
    //相关文章/视频
    _relevantApi = [[NewsRelevantApi alloc] initWithDelegate:self];
    
    //评论列表
    _commentListApi = [[NewsCommentListApi alloc] initWithDelegate:self];
    
}

#pragma mark - 请求详情数据
- (void)requestDetailInfo
{
    [WNLoadingView showLoadingInView:self.tableView];
    self.startTime = time(0);
    
    self.relevantArray = [NSMutableArray array];
    self.commentArray = [NSMutableArray array];
    self.dataArray = @[@[],self.relevantArray, self.commentArray].mutableCopy;
    if ([UserManager currentUser].applicationMode.integerValue == 0 && [TencentAdManager sharedManager].adArray.count != 0) {
        self.dataArray = @[@[[TencentAdManager sharedManager].adArray.firstObject].mutableCopy,self.relevantArray, self.commentArray].mutableCopy;
        [[TencentAdManager sharedManager].adArray removeObjectAtIndex:0];
        if ([TencentAdManager sharedManager].adArray.count == 0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:FetchAdNotifiCation object:nil];
        }
    }
    
    _relevantApi.encryptId = self.model.encryptId;
    _relevantApi.type = self.model.type;
    [_relevantApi call];
    
    _commentListApi.encryptId = self.model.encryptId;
    _commentListApi.page = 1;
    _commentListApi.type = self.model.type;
    [_commentListApi call];
}

- (void)requestMoneyAndStat
{
    //统计
    [self statNews];
    self.startTime = time(0);
    [self giveMoneyWithArticleId:self.model.articleId];
    [self.bottomCommentView setCommentNumber:self.model.comment_num];
}

- (void)rightBarButtonAction
{
    ShareAlertView *shareView = [ShareAlertView new];
    [shareView showShareViewDelegate:self];
}

#pragma mark - 统计相关
- (void)getDateKey
{
    NSDate *now = [NSDate date];
    // 1.创建一个时间格式化对象
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 2.设置时间格式化对象的样式
    formatter.dateFormat = @"yyyy-MM-dd";
    // 3.利用时间格式化对象对时间进行格式化
    NSString *str = [formatter stringFromDate:now];
    self.dateKey = str;
    WNLog(@"%@",str);

}

//根据文章id给钱
- (void)giveMoneyWithArticleId:(NSString *)articleId
{
    
    _readApi = [[NewsReadApi alloc] initWithDelegate:self articleId:articleId];
    
    NSInteger number = [[[NSUserDefaults standardUserDefaults] objectForKey:self.dateKey] integerValue];
    if ([[UserManager currentUser].readCount integerValue] <= 10 || number <= 5) {
        [self requestRedPacket];
    } else {
        
        if (self.model.type.integerValue == 2) {
            return;
        }
        float balance = [[UserManager currentUser].money floatValue];
        int duration;
        if (balance <= 20) {
            duration = arc4random() % 10 + 30;
        } else if (balance > 20 && balance <= 30){
            duration = arc4random() % 20 + 40;
        } else if (balance > 30 && balance <= 45){
            duration = arc4random() % 50 + 40;
        }else {
            return;
        }
        
        [self performSelector:@selector(requestRedPacket) withObject:nil afterDelay:duration];
        
    }
    WNLog(@"文章数==：%@--%ld", [UserManager currentUser].readCount, (long)number);
    
}

//根据视频id给钱
- (void)giveMoneyWithVideoId:(NSString *)videoId
{
    float balance = [[UserManager currentUser].money floatValue];
    int duration;
    if (balance <= 20) {
        duration = 30;
    } else if (balance > 20 && balance <= 30){
        duration = 40;
    } else if (balance > 30 && balance <= 40){
        duration = 50;
    } else if (balance > 40 && balance <= 45){
        duration = 60;
    } else {
        return;
    }
    if ((time(0) - self.startTime) >= duration) {
        [self requestRedPacket];
    } else {
        
        [self performSelector:@selector(requestRedPacket) withObject:nil afterDelay:duration - (time(0) - self.startTime)];

    }
}
//请求是否给钱
- (void)requestRedPacket
{
    if ([[UserManager currentUser].applicationMode integerValue] == 1) {
        return;
    }
    [_readApi call];
}

- (void)statNews
{
    //统计点击文章
    if (self.model.type.integerValue != 2) {
        _statApi.articleIds = @[self.model.articleId];
    } else {
        _statApi.videoIds = @[self.model.articleId];
    }
    _statApi.actionType = STAT_CLICK;
    [_statApi call];
    
    //阅读文章时间
    _readTimeApi = [[NewsReadTimeApi alloc] initWithDelegate:self articleId:self.model.articleId];
    _readTimeApi.type = self.model.type;
    @kWeakObj(self)
    self.refreshAction = ^{
        selfWeak.readTimeApi.duration = [NSString stringWithFormat:@"%ld", time(0) - _startTime];
        [selfWeak.readTimeApi call];
    };
}

#pragma mark - ApiResponseDelegate
- (void)request:(NetworkRequest *)request success:(id)response
{
    if ([request.url containsString:statUrl] || [request.url containsString:commentUrl]  || [request.url containsString:readTimeUrl]) {
        return;
    }
    if ([request.url containsString:finishReadUrl]) {
        
        [self finishReadSuccess:response];
        
    } else if ([request.url containsString:articleRelevantUrl] || [request.url containsString:videoRelevantUrl]){
        
        [self.relevantArray addObjectsFromArray:[NewsArticleModel mj_objectArrayWithKeyValuesArray:response]];
        [self.tableView reloadData];
        if (self.model.type.integerValue == 2) {
            [WNLoadingView hideLoadingForView:self.tableView];
        }
        
    } else if ([request.url containsString:commentListUrl]){
        
        [self commentListSuccess:response];
        
    }
}

- (void)request:(NetworkRequest *)request failure:(NSError *)error
{
    
}

#pragma mark - 各接口成功后处理
//评论列表
- (void)commentListSuccess:(NSDictionary *)response
{
    NSArray *array = [NewsCommentModel mj_objectArrayWithKeyValuesArray:response];
    [self.commentArray addObjectsFromArray:array];
    [self.tableView reloadData];
    if (array.count < 10) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        [(MJRefreshAutoNormalFooter *)self.tableView.mj_footer setTitle:@"已显示全部评论~" forState:MJRefreshStateNoMoreData];
    } else {
        [self.tableView.mj_footer endRefreshing];
    }
    if (self.commentArray.count == 0) {
        [(MJRefreshAutoNormalFooter *)self.tableView.mj_footer setTitle:@"暂无评论，点击抢沙发~" forState:MJRefreshStateNoMoreData];
    }
}
//完成阅读
- (void)finishReadSuccess:(NSDictionary *)response
{
    if ([response[@"money"] floatValue] != 0) {
        //更新本地余额
        float balance = [[UserManager currentUser].money floatValue];
        balance += [response[@"money"] floatValue];
        [[UserManager currentUser] setMoney:[NSString stringWithFormat:@"%.2f", balance]];
        
        if (self.model.type.integerValue != 2) {
            //弹出红包
            ReadPacketView *redView = [ReadPacketView new];
            [redView showPacketViewMoney:response[@"money"] offSet:0];
            
        } else {
            //全屏的时候不弹出红包，这里记下要红包金额，等退出全屏时弹出
            if (!_isHalfScreen) {
                
                self.redMoney = response[@"money"];
                
            } else {
                //弹出红包
                ReadPacketView *redView = [ReadPacketView new];
                [redView showPacketViewMoney:response[@"money"] offSet:kHeaderHeight/2];
            }
        }
        
        if ([[UserManager currentUser].readCount integerValue] <= 10) {
            
            [[UserManager currentUser] setReadCount:[NSString stringWithFormat:@"%ld", [[UserManager currentUser].readCount integerValue] + 1]];
            if ([UserManager currentUser].readCount.integerValue == 1) {
                
                [UserManager currentUser].infoFlowRed = @"0";
            }
            
        } else {
            
            NSInteger number = [[[NSUserDefaults standardUserDefaults] objectForKey:self.dateKey] integerValue];
            number++;
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld", (long)number] forKey:self.dateKey];
        }
    }
}

#pragma mark - BottomCommentViewDelegate

- (void)didClickCommentViewIndex:(NSInteger)index
{
    if (index == 2) {
        
        ShareAlertView *shareView = [ShareAlertView new];
        [shareView showShareViewDelegate:self];
        
    } else if (index == 0){
        
        [self.commentView showCommentView];
        
    } else {
        
        //调用JS方法，滚动至评论区
        if (self.commentArray.count != 0) {
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        } else {
            if (self.relevantArray.count >= 1) {
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.relevantArray.count - 1 inSection:1] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            }
        }

    }
}

#pragma mark - TableViewDelegateAndDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray[section] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsArticleModel *model = self.dataArray[indexPath.section][indexPath.row];
    //腾讯广告cell
    if ([model.source isEqualToString:expressAdType]) {
        
        TencentAdCell *cell = [[TencentAdCell alloc] init];
        if ([((TencentAdModel *)model).expressAdType isEqualToString:adType1] ) {
            cell.frame = CGRectMake(0, 0, kScreenWidth-adaptWidth750(60) - 4, kAd1Height);
        } else {
            cell.frame = CGRectMake(0, 0, kScreenWidth, kAd2Height);
        }
        cell.deleteBlock = ^{
            
            //第一,删除数据源,
            [self.dataArray[indexPath.section] removeAllObjects];
            //第二,删除表格cell
            [tableView reloadData];
            
        };
        ((TencentAdModel *)model).expressAdView.controller = self;
        [cell configModelData:model indexPath:indexPath];
        
        return cell;
    } else {
        
        NewsRelevantCell *cell;
        if (indexPath.section != self.dataArray.count - 1) {
            model.type = self.model.type;
        }
        cell = [tableView dequeueReusableCellWithIdentifier:indexPath.section == (self.dataArray.count - 1) ? NewsCommentCellID : NewsRelevantCellID forIndexPath:indexPath];
        if (indexPath.section == 0) {
            model.type = self.model.type;
        }
        [cell configModelData:model indexPath:indexPath];
        return cell;
    }

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == self.dataArray.count - 1 || indexPath.section == 0) {
        return;
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(requestRedPacket) object:nil];
    
    if (self.model.type.integerValue == 2) {
        [self.tableView setContentOffset:CGPointZero animated:NO];
        self.model = self.relevantArray[indexPath.row];
    }
    
    //存储点击过的文章数
    NSInteger number = [[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@number", self.dateKey]] integerValue];
    number++;
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld", (long)number] forKey:[NSString stringWithFormat:@"%@number", self.dateKey]];
    
    if (self.model.type.integerValue == 2) {
        //延迟执行，解决滚动时，无数据崩溃问题
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.videoPlayer playWithNewsModel:self.model showView:self.videoPlayBGView];
            [self.videoTitleView confignData:self.model];
            
            if (self.refreshAction) {
                self.refreshAction();
            }
            
            [self requestDetailInfo];
            //给钱和统计
            [self requestMoneyAndStat];
        });
        

    } else {
        
        NewsDetailViewController *detailVC = [NewsDetailViewController new];
        detailVC.model = self.relevantArray[indexPath.row];
        [self showViewController:detailVC sender:nil];
        
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsArticleModel *model = self.dataArray[indexPath.section][indexPath.row];
    if ([model.source isEqualToString:expressAdType]) {
        if ([((TencentAdModel *)model).expressAdType isEqualToString:adType1] ) {
            return kAd1Height + 0.5 + adaptHeight1334(34);
        } else {
            return kAd2Height + 0.5 + adaptHeight1334(34);
        }
    } else {
        NSString *keyStr = indexPath.section == (self.dataArray.count - 1) ? [(NewsCommentModel *)model comment_id] : model.encryptId;
        CGFloat height = [tableView fd_heightForCellWithIdentifier:indexPath.section == (self.dataArray.count - 1) ? NewsCommentCellID : NewsRelevantCellID cacheByKey:keyStr configuration:^(NewsRelevantCell *cell) {
            [cell configModelData:model indexPath:indexPath];
        }];
        if (indexPath.section == self.dataArray.count - 1) {
            return height;
        } else {
            return height < adaptHeight1334(214) ? adaptHeight1334(214) : height;
        }
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    if (self.model.type.integerValue == 2) {
        view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    } else {
        view.backgroundColor = [UIColor whiteColor];
    }
    return view;
}

#pragma mark - WebViewDelegate
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    [WNLoadingView hideLoadingForView:self.tableView];
    if (self.model.type.integerValue != 2) {
        
        //修改字体大小 300%
        [webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '110%'" completionHandler:nil];
    }
    [_webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    
    //销毁中间详情页控制器
    [self dismissDetailVC];

}

- (void)dismissDetailVC
{
    if (self.navigationController.viewControllers.count >= 3) {
        NSMutableArray *array = self.navigationController.viewControllers.mutableCopy;
        NSMutableArray *detaiArray = [NSMutableArray array];
        for (UIViewController *vc in array) {
            if ([vc isKindOfClass:[self class]]) {
                [detaiArray addObject:vc];
            }
        }
        if (detaiArray.count > 1) {
            [array removeObject:detaiArray.firstObject];
        }
        [self.navigationController setViewControllers:array animated:NO];
    }
}

// 在收到响应开始加载后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
{
    
    WKNavigationResponsePolicy actionPolicy = WKNavigationResponsePolicyAllow;
    //这句是必须加上的，不然会异常
    decisionHandler(actionPolicy);
}

#pragma mark - js调用OC方法

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    return;
    //H5页面进入相关推荐详情
    WNLog(@"JS 调用了 %@ 方法，传回参数 %@",message.name,message.body);
    if ([message.name isEqualToString:@"enterRecommend"]) {
        
        
        NewsArticleModel *model = [NewsArticleModel mj_objectWithKeyValues:message.body];
        [[UIImageView new] sd_setImageWithURL:[NSURL URLWithString:model.cover.firstObject]]; //缓存下图片，方便分享时使用
        
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(requestRedPacket) object:nil];
        
        if (model.type.integerValue == 2 && ![model.articleId isEqualToString:self.model.articleId]) {
            
            [self.videoPlayer playWithNewsModel:model showView:self.videoPlayBGView];
        }
    }
    
}

- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView
{
    [self.webView reload];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.commentView dimiss];
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return nil;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"title"]) {
        if (object == self.webView) {
            //self.title = self.webView.title;
        } else {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    } else if([keyPath isEqualToString:@"contentSize"]){

        if (object == self.webView.scrollView) {
            
            WNLog(@"Height is changed! new=%@", [change valueForKey:NSKeyValueChangeNewKey]);
            WNLog(@"tianxia :%@",NSStringFromCGSize(self.webView.scrollView.contentSize));
            CGFloat newHeight = self.webView.scrollView.contentSize.height;
            if (self.webView.frame.size.height == newHeight) {
                return;
            }
            _webView.frame = CGRectMake(0, 0, kScreenWidth, newHeight);
            [self.tableView beginUpdates];
            self.tableView.tableHeaderView = _webView;
            [self.tableView endUpdates];
        }
        
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - LYVideoPlayerDelegate

- (void)videoPlayerDidBackButtonClick{
    
    _isHalfScreen = !_isHalfScreen;
     [[NSNotificationCenter defaultCenter] postNotificationName:@"InterfaceOrientationNotification" object:@"YES"];
    
    if (_isHalfScreen) {
        [[UIDevice currentDevice]setValue:[NSNumber numberWithInteger:UIDeviceOrientationLandscapeLeft]  forKey:@"orientation"];
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
        [UIView animateWithDuration:0.5 animations:^{
            self.videoPlayBGView.frame = CGRectMake(0, 0, self.view.frame.size.width, kHeaderHeight);
        } completion:^(BOOL finished) {
            //开启
            ((WNNavigationController *)self.navigationController). enableRightGesture = YES;

            if (self.redMoney.floatValue != 0) {
                //弹出红包
                ReadPacketView *redView = [ReadPacketView new];
                [redView showPacketViewMoney:self.redMoney offSet:kHeaderHeight/2];
                
            }
        }];
        self.webView.hidden = NO;
        [self.videoPlayer fullScreenChanged:!_isHalfScreen];
    }else{
        [self.videoPlayer stopVideo];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)videoPlayerDidFullScreenButtonClick{
    
    _isHalfScreen = !_isHalfScreen;
    self.webView.hidden = !_isHalfScreen;
     [[NSNotificationCenter defaultCenter] postNotificationName:@"InterfaceOrientationNotification" object:@"YES"];

    if (_isHalfScreen) {
        [[UIDevice currentDevice]setValue:[NSNumber numberWithInteger:UIDeviceOrientationLandscapeLeft]  forKey:@"orientation"];
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
        [UIView animateWithDuration:0.5 animations:^{
            self.videoPlayBGView.frame = CGRectMake(0, 0, self.view.frame.size.width, kHeaderHeight);
        } completion:^(BOOL finished) {
            
            //开启
            ((WNNavigationController *)self.navigationController). enableRightGesture = YES;

            
            if (self.redMoney.floatValue != 0) {
                //弹出红包
                ReadPacketView *redView = [ReadPacketView new];
                [redView showPacketViewMoney:self.redMoney offSet:kHeaderHeight/2];
                
            }
        }];
    }else{
        
        [[UIDevice currentDevice]setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait]  forKey:@"orientation"];
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationLandscapeLeft] forKey:@"orientation"];
        [UIView animateWithDuration:0.5 animations:^{
            self.videoPlayBGView.frame=self.view.bounds;
        } completion:^(BOOL finished) {
            
            //禁用屏幕左滑返回手势
            
            if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]){
                
                ((WNNavigationController *)self.navigationController). enableRightGesture = NO;
            }
            
        }];
    }
    
    [self.videoPlayer fullScreenChanged:!_isHalfScreen];
}

- (void)videoPlayerDidShareViewClick:(NSInteger)index
{
    [self didSelectShareIndex:index];
}

- (void)videoPlayerDidShareButtonClick
{
    ShareAlertView *shareView = [ShareAlertView new];
    [shareView showShareViewDelegate:self];
}

- (void)videoPlayerDidPalyFinish
{
    [self giveMoneyWithVideoId:self.model.articleId];
}

- (BOOL)shouldAutorotate{
    
    return YES;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    if (_isHalfScreen) { //如果是iPhone,且为竖屏的时候, 只支持竖屏
        return UIInterfaceOrientationMaskPortrait;
    }else{
        return UIInterfaceOrientationMaskLandscape; //否者只支持横屏
    }
}

//进入后台
- (void)appDidEnterBackground
{
    if (!_isHalfScreen) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"InterfaceOrientationNotification" object:@"NO"];
    }
}

//进入前台
- (void)appDidEnterForeground
{
    
}
//方向改变通知
- (void)orientChange:(NSNotification *)notification{
    
    UIInterfaceOrientation interfaceOritation = [[UIApplication sharedApplication] statusBarOrientation];
    if (interfaceOritation == UIInterfaceOrientationLandscapeLeft || interfaceOritation == UIInterfaceOrientationLandscapeRight) {
        _isHalfScreen = NO;
    } else {
        _isHalfScreen = YES;
    }
    self.webView.hidden = !_isHalfScreen;
    
    if (_isHalfScreen) {
        
        [UIView animateWithDuration:0.5 animations:^{
            self.videoPlayBGView.frame = CGRectMake(0, 0, self.view.frame.size.width, kHeaderHeight);
        } completion:^(BOOL finished) {
            
            //开启
            ((WNNavigationController *)self.navigationController). enableRightGesture = YES;
            
            
            if (self.redMoney.floatValue != 0) {
                //弹出红包
                ReadPacketView *redView = [ReadPacketView new];
                [redView showPacketViewMoney:self.redMoney offSet:kHeaderHeight/2];
                
            }
        }];
    }else{
        
        [UIView animateWithDuration:0.5 animations:^{
            self.videoPlayBGView.frame=self.view.bounds;
        } completion:^(BOOL finished) {
            
            //禁用屏幕左滑返回手势
            
            if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]){
                
                ((WNNavigationController *)self.navigationController). enableRightGesture = NO;
            }
            
        }];
    }
    
    [self.videoPlayer fullScreenChanged:!_isHalfScreen];
}

#pragma mark - 分享&评论
- (void)didSelectShareIndex:(NSInteger)index
{
    //0，1 微信，朋友圈
    //2，3 QQ空间，QQ
    switch (index) {
        case 0:
        case 1:{
            _statApi.actionType = index == 0 ? STAT_SHARE_WECHAT : STAT_SHARE_MOMENTS;
            [[WechatApi sharedInstance] shareNewsArticle:self.model to: index == 0 ? WechatSceneSession : WechatSceneTimeline];
            
            break;
        }
        case 2:
        case 3:{
            _statApi.actionType = index == 2 ? STAT_SHARE_QZONE : STAT_SHARE_QQ;
            if ([UserManager currentUser].applicationMode.integerValue == 1) {
                if (index == 3) {
                    InformListViewController *informVC = [InformListViewController new];
                    [self showViewController:informVC sender:nil];
                } else {
                    
                    if ([UserManager currentUser].isLogin.integerValue == 0) {
                        [MBProgressHUD showError:@"请登录后操作"];
                        return;
                    }
                    [self pushPublishViewControllerOnlyText:YES imageArray:[NSMutableArray array]];
                }
                
                break;
            }
            [[TencentQQApi sharedInstance] shareNewsArticle:self.model to:index == 2 ? QQSceneQzone : QQSceneSession callback:^(int code, NSString * _Nullable description) {
                if (code == 0) {
                    [MBProgressHUD showSuccess:@"分享成功"];
                    _statApi.actionType = index == 2 ? STAT_SHARE_QZONE_SUCCESS : STAT_SHARE_QQ_SUCCESS;
                    [_statApi call];
                } else {
                    
                    if (code == -4) {
                        [MBProgressHUD showError:@"分享取消"];
                    } else {
                        [MBProgressHUD showError:description];
                    }
                }
                
            }];
            break;
        }
            
    }
    [_statApi call];
}

- (void)commentResult
{
    @kWeakObj(self)
    self.commentView.backResult = ^(NSInteger index) {
        
        AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
        [manager startMonitoring];
        @kWeakObj(manager)
        [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            if (status == -1 ||  status == 0) {
                [MBProgressHUD showError:@"发布失败"];
            } else {
                
                [MBProgressHUD showSuccess:@"您的评论将在审核通过后发布"];
                selfWeak.commentView.commentTextView.text = @"";
                
                selfWeak.commentApi.content = selfWeak.commentView.commentTextView.text;
                [selfWeak.commentApi call];
                
                [selfWeak.commentView dimiss];
                
            }
            [managerWeak stopMonitoring];
        }];
    };
    
}

#pragma mark - 懒加载
- (ShowCommentView *)commentView
{
    if (!_commentView) {
        _commentView = [ShowCommentView new];
    }
    return _commentView;
}

#pragma mark - 审核模式圈子发布功能
/**
 跳转发布界面
 
 @param isOnlyText 是否只是文本
 @param imageArray 图片数组
 */
- (void)pushPublishViewControllerOnlyText:(BOOL)isOnlyText imageArray:(NSMutableArray *)imageArray
{
    PublishViewController *publishVC = [[PublishViewController alloc] init];
    if (!isOnlyText) {
        publishVC.imageArray = imageArray;
    }
    publishVC.isOnlyText = isOnlyText;
    
    UserModel *userModel = [UserModel mj_objectWithKeyValues:[UserManager currentUser].userInfo];
    
    TimelineModel *timelineModel = [TimelineModel new];
    timelineModel.tag = self.model.encryptId;
    timelineModel.title = self.model.title;
    timelineModel.category = self.model.articleId;
    timelineModel.content = [NSString stringWithFormat:@"https://xigua.lingyongqian.cn/article/detail?id=%@",self.model.articleId];
    timelineModel.cover = self.model.cover.firstObject;
    timelineModel.channel = userModel.avatar;
    timelineModel.source_detail = userModel.nickName;
    timelineModel.status = @"0";
    timelineModel.read_num = @"0";
    timelineModel.is_myself = YES;
    
    publishVC.timelineModel = timelineModel;
    WNNavigationController *navc = [[WNNavigationController alloc] initWithRootViewController:publishVC];
    [self presentViewController:navc animated:YES completion:nil];
}

@end
