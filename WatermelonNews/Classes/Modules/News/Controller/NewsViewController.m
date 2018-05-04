//
//  NewsViewController.m
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/8/21.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "NewsViewController.h"
#import "NewsDetailViewController.h"
#import "TabHeaderView.h"
#import "NewsListViewController.h"
#import "NewsCategoryModel.h"
#import "NewsCategoryApi.h"
#import "UserManager.h"
#import "NativeExpressAdApi.h"
#import "TencentAdManager.h"
#import "GoogleAdManager.h"
#import "TaskAdManager.h"

@interface NewsViewController ()<TabHeaderViewDelegate, UIScrollViewDelegate,NativeExpressAdApiDelegate>

@property (strong, nonatomic) TabHeaderView *navigationTabView;
@property (strong, nonatomic) UIScrollView *containerView;
@property (assign, nonatomic) NSInteger tempIndex; //记住当前index
@property (strong, nonatomic) NativeExpressAdApi *adApi;

@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //配置navigationBar
    [self setNavigationBar];
    //添加子控制器
    [self confignChildViewController];
    [self switchChildViewControllerIndex:0];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newsRefreshAction) name:NewsRefeshNotifiCation object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchAdAction) name:FetchAdNotifiCation object:nil];

    _adApi   = [[NativeExpressAdApi alloc] initTencentAdWithDelegate:self];
    [self fetchAdAction];
    
    [[GoogleAdManager sharedManager] initWihtRootViewController:self];
    [[GoogleAdManager sharedManager] fetchGoogleAd];
    
    [[TaskAdManager sharedManager] fetchTaskAd];
}

//拉取腾讯广告
- (void)fetchAdAction
{
    [_adApi fetchNativeExpressAd]; //请求广告数据
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar addSubview:self.navigationTabView];
}

- (void)viewDidAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = NO;
}

#pragma mark - NativeExpressAdApiDelegate
- (void)nativeExpressAdDidFetchSuccess:(NSArray *)dataArray
{
    [TencentAdManager sharedManager].adArray = dataArray.mutableCopy;
}

- (void)nativeExpressAdDidFetchFailure:(NSError *)error
{
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NewsRefeshNotifiCation object:nil];
}

- (void)setNavigationBar
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor] size:CGSizeMake(kScreenWidth, 64)] forBarMetrics:UIBarMetricsDefault];
    self.title = @"返回";
    NSInteger mode = [UserManager currentUser].applicationMode.integerValue;
    NSString *str;
    if (mode == 1) {
        str = @"阅读";
    } else {
        str = @"阅读赚钱";
    }
    self.tabBarItem.title = str;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.navigationController.navigationBar addSubview:self.navigationTabView];
    [self.view addSubview:self.containerView];

}

- (void)confignChildViewController
{
    [self.dataArray enumerateObjectsUsingBlock:^(NewsCategoryModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NewsListViewController *listVC = [NewsListViewController new];
        listVC.categoryModel = model;
        [self addChildViewController:listVC];
        
    }];
}

-(void)switchChildViewControllerIndex:(NSInteger)index
{
    NewsListViewController *listVC = self.childViewControllers[index];
    //已经添加了，不必重复操作
    if(!listVC.view.window){
        [WNLoadingView hideLoadingForView:self.view];
        [WNLoadingView showLoadingInView:self.view];
        listVC.view.frame = CGRectMake(kScreenWidth * index, 0, kScreenWidth, _containerView.height);
        listVC.loadingView = self.view;
        [_containerView addSubview:listVC.view];
    }
}

#pragma mark - TabHeaderViewDelegate

- (void)didSelectTabIndex:(NSInteger)index
{
    self.tempIndex = index;
    [self.containerView setContentOffset:CGPointMake(index * kScreenWidth, 0) animated:YES];
    [self switchChildViewControllerIndex:index];

}

//点击当前tab刷新
- (void)didRefreshClickIndex:(NSInteger)index
{
    NewsListViewController *listVC = self.childViewControllers[index];
    [listVC.tableView.mj_header beginRefreshing];
}

#pragma mark - NewsRefreshNotification

- (void)newsRefreshAction
{
    CGFloat myFloat = self.containerView.contentOffset.x;
    NSInteger index = myFloat / self.view.frame.size.width;
    [self didRefreshClickIndex:index];
    
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    CGFloat myFloat = scrollView.contentOffset.x;
    
    NSInteger index = myFloat / self.view.frame.size.width;
    if (self.tempIndex == index) {
        return;
    }
    
    [self.navigationTabView selectTabIndex:index];
    self.tempIndex = index;
    
}

#pragma mark - 懒加载

- (TabHeaderView *)navigationTabView
{
    if (!_navigationTabView) {
        
        _navigationTabView = [[TabHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
        [_navigationTabView cofigureDelegate:self dataArray:self.dataArray withMultiple:1];
    }
    return _navigationTabView;
}

- (UIScrollView *)containerView
{
    if (!_containerView) {
        
        _containerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 49 - 64)];
        _containerView.backgroundColor = [UIColor colorWithString:COLORF6F6F6];
        _containerView.contentSize = CGSizeMake(kScreenWidth * self.dataArray.count, kScreenHeight - 49 - 64);
        _containerView.pagingEnabled = YES;
        _containerView.delegate = self;
        _containerView.showsHorizontalScrollIndicator = NO;
        _containerView.showsVerticalScrollIndicator = NO;
    }
    return _containerView;
}

@end
