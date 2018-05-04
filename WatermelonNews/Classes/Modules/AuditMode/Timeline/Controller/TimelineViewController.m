//
//  TimelineViewController.m
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/11/3.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "TimelineViewController.h"
#import "PublishHeadView.h"
#import "MyContentCell.h"
#import "TranspondContentCell.h"
#import "SelectAlertView.h"
#import "ShootViewController.h"
#import "CameraRollViewController.h"
#import "PublishViewController.h"
#import "TimelineDetailViewController.h"
#import "PersonalViewController.h"
#import "HttpRequest.h"
#import "TimelineModel.h"
#import "NewsDetailViewController.h"
#import "NewsArticleModel.h"

@interface TimelineViewController ()<UITableViewDelegate,UITableViewDataSource, TimelineCellDelegate>

@property (strong, nonatomic) NSMutableArray *freshImages;
@property (strong, nonatomic) PublishHeadView *headView;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArray;

@end

@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubViews];
    [self publishAction];

}

- (void)setupSubViews
{
    [self.view addSubview: self.headView];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kViewHeight+64, kScreenWidth, kScreenHeight - kViewHeight - 64  - 49) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[MyContentCell class] forCellReuseIdentifier:MyContentCellID];
    [self.tableView registerClass:[TranspondContentCell class] forCellReuseIdentifier:TranspondContentCellID];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    [self setupRefreshControl];
    [WNLoadingView showLoadingInView:self.view];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateAction:) name:TimelineNotifiCation object:nil];

}

- (void)updateAction:(NSNotification *)notification
{
    TimelineModel *model = [TimelineModel mj_objectWithKeyValues:notification.userInfo];
    model.praise_num = @"0";
    [self.dataArray insertObject:model atIndex:0];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
    
}

#pragma mark - SetupViews

- (void)setupRefreshControl
{
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //下拉
    MJRefreshGifHeader *gifHeader = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        
        self.dataArray = [NSMutableArray array];
        [self requestData];
    }];
    [self confignHeaderView:gifHeader];
    //上拉
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self requestData];
    }];
    [(MJRefreshAutoNormalFooter *)self.tableView.mj_footer setTitle:@"没有更多内容了" forState:MJRefreshStateNoMoreData];
    [self.tableView.mj_header beginRefreshing];
}

- (void)requestData
{
    [HttpRequest timelineGet:@"http://121.42.10.73/APP/api.php?method=get_dongtai" params:nil success:^(id responseObj) {
        
        [self.dataArray addObjectsFromArray:[TimelineModel mj_objectArrayWithKeyValuesArray:responseObj[@"data"]]];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
        [WNLoadingView hideLoadingForView:self.view];
        
    } failure:^(NSError *error) {
        [WNLoadingView hideLoadingForView:self.view];
        [self.tableView.mj_header endRefreshing];
    }];
}

//配置headerView
- (void)confignHeaderView:(MJRefreshGifHeader *)gifHeader
{
    
    gifHeader.lastUpdatedTimeLabel.hidden = YES;
    
    [gifHeader setImages:self.freshImages.mutableCopy forState:MJRefreshStateRefreshing];
    [gifHeader setImages:self.freshImages.mutableCopy forState:MJRefreshStateIdle];
    
    [gifHeader setTitle:@"推荐中..." forState:MJRefreshStateRefreshing];
    [gifHeader setTitle:@"松开推荐" forState:MJRefreshStatePulling];
    [gifHeader setTitle:@"下拉推荐" forState:MJRefreshStateIdle];
    self.tableView.mj_header = gifHeader;
    
}

- (NSMutableArray *)freshImages
{
    if (!_freshImages) {
        
        _freshImages = [NSMutableArray array];
        
        for (int i = 1; i < 5; i++) {
            
            [_freshImages addObject:[UIImage imageNamed:[NSString stringWithFormat:@"news_%d", i]]];
        }
    }
    return _freshImages;
}

- (void)publishAction
{
    @kWeakObj(self)
    self.headView.backResult = ^(NSInteger index) {
        if ([UserManager currentUser].isLogin.integerValue == 0) {
            [MBProgressHUD showError:@"请登录后操作"];
            return;
        }
        if (index == 0) {
            
            [selfWeak pushPublishViewControllerOnlyText:NO imageArray:[NSMutableArray array]];
            
        } else {
            
            WNLog(@"相册");
            CameraRollViewController *rollVC = [CameraRollViewController new];
            rollVC.currentNumber = 0;
            WNNavigationController *navc = [[WNNavigationController alloc] initWithRootViewController:rollVC];
            rollVC.blcokResult = ^(NSMutableArray *array) {
                [selfWeak pushPublishViewControllerOnlyText:NO imageArray:array];
            };
            [selfWeak presentViewController:navc animated:YES completion:nil];
        }
    };
    
}

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
    WNNavigationController *navc = [[WNNavigationController alloc] initWithRootViewController:publishVC];
    [self presentViewController:navc animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)personalClickAction:(NSIndexPath *)indexPath
{
    PersonalViewController *personalVC = [[PersonalViewController alloc] initWithStyle:UITableViewStylePlain];
    TimelineModel *model =  self.dataArray[indexPath.row];
    personalVC.userInfo = model.source;
    personalVC.avatar = model.channel;
    personalVC.nickName = model.source_detail;
    personalVC.isMyself = model.is_myself;
    [self showViewController:personalVC sender:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TimelineModel *model = self.dataArray[indexPath.row];
    if (model.status.integerValue == 0) {
        
        TranspondContentCell *cell = [tableView dequeueReusableCellWithIdentifier:TranspondContentCellID forIndexPath:indexPath];
        cell.delegate = self;
        [cell configModelData:model indexPath:indexPath];
        return cell;
    }
    MyContentCell *cell = [tableView dequeueReusableCellWithIdentifier:MyContentCellID forIndexPath:indexPath];
    cell.delegate = self;
    [cell configModelData:model indexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TimelineModel *model = self.dataArray[indexPath.row];
    if (model.status.integerValue == 0) {
        
        NewsDetailViewController *detailVC = [NewsDetailViewController new];
        NewsArticleModel *newsModel = [NewsArticleModel new];
        newsModel.category = @"hot";
        newsModel.articleId = model.category;
        newsModel.encryptId = model.tag;
        newsModel.url = model.content;
        newsModel.cover = [model.cover componentsSeparatedByString:@","];
        newsModel.type = @"1";
        newsModel.title = model.title;
        
        detailVC.model = newsModel;
        
        [self showViewController:detailVC sender:nil];
        
    } else {
        
        TimelineDetailViewController *detailVC = [[TimelineDetailViewController alloc] initWithStyle:UITableViewStyleGrouped];
        detailVC.userModel = model;
        detailVC.refreshBlock = ^{
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        };
        [self showViewController:detailVC sender:nil];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TimelineModel *model = self.dataArray[indexPath.row];

    if (model.status.integerValue == 0) {
        return [tableView fd_heightForCellWithIdentifier:TranspondContentCellID cacheByKey:model.tag configuration:^(TranspondContentCell *cell) {
            
            [cell configModelData:model indexPath:indexPath];
            
        }];
    }
    
    return [tableView fd_heightForCellWithIdentifier:MyContentCellID cacheByKey:model.content  configuration:^(MyContentCell *cell) {
        
        [cell configModelData:model indexPath:indexPath];
        
    }];
    
}


- (PublishHeadView *)headView
{
    if (!_headView) {
        self.headView = [[PublishHeadView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kViewHeight + adaptHeight1334(10))];
    }
    return _headView;
}

@end
