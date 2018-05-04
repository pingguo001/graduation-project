//
//  PersonalViewController.m
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/11/6.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "PersonalViewController.h"
#import "MyContentCell.h"
#import "TranspondContentCell.h"
#import "PersionalView.h"
#import "HttpRequest.h"
#import "TimelineModel.h"
#import "TimelineDetailViewController.h"
#import "NewsDetailViewController.h"
#import "InformListViewController.h"
#import "InformationTableViewController.h"
#import "UserTimelineManager.h"
#import "ConversationViewController.h"

@interface PersonalViewController ()<TimelineCellDelegate>

@property (strong, nonatomic) PersionalView *headerView;
@property (strong, nonatomic) NSMutableArray *dataArray;

@end

@implementation PersonalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[MyContentCell class] forCellReuseIdentifier:MyContentCellID];
    [self.tableView registerClass:[TranspondContentCell class] forCellReuseIdentifier:TranspondContentCellID];
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.sectionFooterHeight = adaptHeight1334(10);
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView.contentInset = UIEdgeInsetsMake(kPersionalHeight, 0, 0, 0);
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;

    self.headerView = [[PersionalView alloc] initWithFrame:CGRectMake(0, -kPersionalHeight, kScreenWidth, kPersionalHeight)];
    [self.tableView addSubview:self.headerView];
//    self.headerView.editButton.hidden = !self.isMyself;
    if (self.isMyself) {
        [self.headerView.editButton setTitle:@"编辑资料" forState:UIControlStateNormal];
    } else {
        [self.headerView.editButton setTitle:@"发起聊天" forState:UIControlStateNormal];
    }
    [self.headerView.editButton addTarget:self action:@selector(editAction) forControlEvents:UIControlEventTouchUpInside];
    if (self.isMyself) {
        UserModel *model = [UserModel mj_objectWithKeyValues:[UserManager currentUser].userInfo];
        [self.headerView configNickname:model.nickName];
        [self.headerView configHeadImage:model.avatar];
    } else {
        [self.headerView configHeadImage:self.avatar];
        [self.headerView configNickname:self.nickName];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"more"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonAction)];

    }
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    
    [self requsetMyData];
    
    //上拉
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
    }];
    [(MJRefreshAutoNormalFooter *)self.tableView.mj_footer setTitle:@"没有更多内容了" forState:MJRefreshStateNoMoreData];
    [self.tableView.mj_footer endRefreshingWithNoMoreData];

}

- (void)rightBarButtonAction
{
    [AlertControllerTool sheetControllerWithViewController:self title:@"" otherTilte:@"投诉" titleAction:nil otherTilteAction:^{
        InformListViewController *informVC = [InformListViewController new];
        [self showViewController:informVC sender:nil];
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.isMyself) {
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            // 拿本地存储的数据
            self.dataArray = [[[TimelineModel mj_objectArrayWithKeyValuesArray:[UserTimelineManager readUserTimelineFromDocument]] reverseObjectEnumerator] allObjects].mutableCopy;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                
            });
        });
    }
}

- (void)requsetMyData
{
    if (self.isMyself) {
        
//        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//            // 拿本地存储的数据
//            self.dataArray = [[[TimelineModel mj_objectArrayWithKeyValuesArray:[UserTimelineManager readUserTimelineFromDocument]] reverseObjectEnumerator] allObjects].mutableCopy;
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [self.tableView reloadData];
//
//            });
//        });
        return;
    }
    [HttpRequest timelineGet:self.userInfo params:nil success:^(id responseObj) {
        
        self.dataArray = [TimelineModel mj_objectArrayWithKeyValuesArray:responseObj[@"data"]];
        [self.tableView reloadData];

        
    } failure:^(NSError *error) {
        [WNLoadingView hideLoadingForView:self.view];
    }];
}

- (void)editAction
{
    if (self.isMyself) {
        [self showViewController:[[InformationTableViewController alloc] initWithStyle:UITableViewStyleGrouped] sender:nil];
    } else {
        
        if ([UserManager currentUser].isLogin.integerValue == 0) {
            [MBProgressHUD showError:@"请登录后操作"];
            return;
        }
        ConversationViewController *conversationVC = [[ConversationViewController alloc]init];
        conversationVC.conversationType = ConversationType_PRIVATE;
        conversationVC.targetId = [self.userInfo componentsSeparatedByString:@"&uid="].lastObject;
        conversationVC.avatar = self.avatar;
        conversationVC.title = self.nickName;
        conversationVC.nickName = self.nickName;

        [self.navigationController pushViewController:conversationVC animated:YES];

    }

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (@available(iOS 11.0, *)) {
        
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [self navigationBarAppear];
    
    CGFloat offsetY = scrollView.contentOffset.y;
    WNLog(@"%f",offsetY);
    CGFloat offsetH = kPersionalHeight + offsetY;
    if (offsetH < 0) {//下拉偏移为负数
        CGRect frame = self.headerView.frame;
        frame.size.height = kPersionalHeight - offsetH;//下拉后图片的高度应变大
        frame.origin.y = -kPersionalHeight + offsetH;// 下边界是一定的  高度变大了  起始的Y应该上移
        self.headerView.frame = frame;

    }
}

- (void)navigationBarAppear
{
    CGFloat contentOffset = self.tableView.contentOffset.y;
    
    if ((contentOffset + kPersionalHeight) >= adaptHeight1334(400)) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(SCREEN_WIDTH, 64)] forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:[UIColor groupTableViewBackgroundColor] size:CGSizeMake(SCREEN_WIDTH, 0)]];
        self.title = self.nickName;
    } else {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:255 green:255 blue:255 alpha: (contentOffset + kPersionalHeight)/adaptHeight1334(400)] size:CGSizeMake(SCREEN_WIDTH, 64)] forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setShadowImage:[UIImage new]];
        self.title = @"";
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    if (model.is_myself) {
        model.praise_num = @"0";
    }
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
        newsModel.encryptId = model.tag;
        newsModel.category = @"hot";
        newsModel.articleId = model.category;
        newsModel.url = model.content;
        newsModel.cover = [model.cover componentsSeparatedByString:@","];
        newsModel.type = @"1";
        
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

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, adaptHeight1334(80))];
//    sectionView.backgroundColor = [UIColor whiteColor];
//
//    UILabel *titleLabel = [UILabel labWithText:@"动态" fontSize:adaptFontSize(26) textColorString:COLOR060606];
//    titleLabel.textColor = [UIColor redColor];
//    [sectionView addSubview:titleLabel];
//
//    UIView *lineView = [UIView new];
//    lineView.backgroundColor = [UIColor redColor];
//    [sectionView addSubview:lineView];
//
//    UIView *line = [UIView new];
//    line.backgroundColor = [UIColor colorWithString:COLORE1E1DF];
//    [sectionView addSubview:line];
//
//    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.centerY.equalTo(sectionView);
//        make.left.equalTo(sectionView).offset(adaptWidth750(30));
//
//    }];
//
//    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.left.right.equalTo(titleLabel);
//        make.bottom.equalTo(sectionView).offset(-0.5);
//        make.height.mas_equalTo(2);
//
//    }];
//
//    [line mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.left.right.equalTo(sectionView);
//        make.height.mas_equalTo(0.5);
//        make.bottom.equalTo(sectionView);
//
//    }];
//
//    return sectionView;
//
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return adaptHeight1334(80);
//}

- (void)personalClickAction:(NSIndexPath *)indexPath {
    
}

- (void)reportAction
{
    [AlertControllerTool sheetControllerWithViewController:self title:@"" otherTilte:@"举报此内容" titleAction:nil otherTilteAction:^{
        InformListViewController *informVC = [InformListViewController new];
        [self showViewController:informVC sender:nil];
    }];
}


@end
