//
//  TimelineDetailViewController.m
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/11/6.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "TimelineDetailViewController.h"
#import "MyContentCell.h"
#import "CommentCell.h"
#import "HttpRequest.h"
#import "CommentModel.h"
#import "PersonalViewController.h"
#import "InformListViewController.h"
#import "TimelineCommentView.h"
#import "ShowCommentView.h"

@interface TimelineDetailViewController ()<TimelineCellDelegate, TimelineCommentViewDelegate>

@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) TimelineCommentView *commentView;
@property (strong, nonatomic) ShowCommentView *showCommentView;
@property (strong, nonatomic) UILabel *praiseLabel;


@end

@implementation TimelineDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[MyContentCell class] forCellReuseIdentifier:MyContentCellID];
    [self.tableView registerClass:[CommentCell class] forCellReuseIdentifier:CommentCellID];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.sectionFooterHeight = adaptHeight1334(10);
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.01f)];
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self requestCommentData];
    
//    if (@available(iOS 11.0, *)) {
//        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//    } else {
//        self.automaticallyAdjustsScrollViewInsets = NO;
//    }
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    if (!self.userModel.is_myself) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"more"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonAction)];
    }
    
    
    //上拉
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                
    }];
    [(MJRefreshAutoNormalFooter *)self.tableView.mj_footer setTitle:@"没有更多评论了" forState:MJRefreshStateNoMoreData];
    [self.tableView.mj_footer endRefreshingWithNoMoreData];
    
    [self.view addSubview:self.commentView];
    [self.view bringSubviewToFront:self.commentView];
    [self commentResult];
    self.commentView.praiseButton.selected = self.userModel.is_praise;
    
}

- (void)didClickCommentViewIndex:(NSInteger)index
{
    if (index == 0){
        
        [self.showCommentView showCommentView];
        
    } else {
        
        if (index == 1) {
            self.userModel.praise_num = [NSString stringWithFormat:@"%ld", (self.userModel.praise_num.integerValue)+1];
            self.userModel.is_praise = YES;
        } else {
            self.userModel.praise_num = [NSString stringWithFormat:@"%ld", (self.userModel.praise_num.integerValue)-1];
            self.userModel.is_praise = NO;
        }
        self.praiseLabel.text = [NSString stringWithFormat:@"%@ 赞",self.userModel.praise_num];
        if (self.refreshBlock) {
            self.refreshBlock();
        }
    }
}

- (void)commentResult
{
    @kWeakObj(self)
    self.showCommentView.backResult = ^(NSInteger index) {
        
        AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
        [manager startMonitoring];
        @kWeakObj(manager)
        [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            if (status == -1 ||  status == 0) {
                [MBProgressHUD showError:@"发布失败"];
            } else {
                
                [MBProgressHUD showSuccess:@"您的评论将在审核通过后发布"];
                selfWeak.showCommentView.commentTextView.text = @"";
                [selfWeak.showCommentView dimiss];
            }
            [managerWeak stopMonitoring];
        }];
    };
    
}

- (void)rightBarButtonAction
{
    [AlertControllerTool sheetControllerWithViewController:self title:@"" otherTilte:@"投诉" titleAction:nil otherTilteAction:^{
        InformListViewController *informVC = [InformListViewController new];
        [self showViewController:informVC sender:nil];
    }];
}

- (void)personalClickAction:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        PersonalViewController *personalVC = [[PersonalViewController alloc] initWithStyle:UITableViewStylePlain];
        personalVC.userInfo = self.userModel.source;
        personalVC.avatar = self.userModel.channel;
        personalVC.nickName = self.userModel.source_detail;
        personalVC.isMyself = self.userModel.is_myself;
        [self showViewController:personalVC sender:nil];
    } else {
        
        PersonalViewController *personalVC = [[PersonalViewController alloc] initWithStyle:UITableViewStylePlain];
        CommentModel *model = self.dataArray[indexPath.row];
        personalVC.userInfo = model.status;
        personalVC.avatar = model.avatar;
        personalVC.nickName = model.nickname;
        [self showViewController:personalVC sender:nil];
    }
    
}

- (void)requestCommentData
{
    if (self.userModel.comment_url == nil) {
        return;
    }
    [HttpRequest timelineGet:self.userModel.comment_url params:nil success:^(id responseObj) {
        
        self.dataArray = [CommentModel mj_objectArrayWithKeyValuesArray:responseObj[@"data"]];
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];

        
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return self.dataArray.count;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.showCommentView dimiss];
    self.commentView.y = self.tableView.contentOffset.y + kScreenHeight - 49;
    [self.tableView bringSubviewToFront:self.commentView];

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        
        MyContentCell *cell = [tableView dequeueReusableCellWithIdentifier:MyContentCellID forIndexPath:indexPath];
        cell.headView.backgroundColor = [UIColor whiteColor];
        cell.delegate = self;
        [cell configModelData:self.userModel indexPath:indexPath];

        return cell;
    } else {
        
        CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:CommentCellID forIndexPath:indexPath];
        cell.delegate = self;
        [cell configModelData:self.dataArray[indexPath.row] indexPath:indexPath];
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return [tableView fd_heightForCellWithIdentifier:MyContentCellID cacheByKey:self.userModel.content configuration:^(MyContentCell *cell) {
            
            [cell configModelData:self.userModel indexPath:indexPath];
            
        }];
        
    } else {
        
        CommentModel *model = self.dataArray[indexPath.row];
        return [tableView fd_heightForCellWithIdentifier:CommentCellID cacheByKey:model.content configuration:^(CommentCell *cell) {
            
            [cell configModelData:model indexPath:indexPath];
            
        }];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, adaptHeight1334(80))];
        headerView.backgroundColor = [UIColor whiteColor];
        
        UILabel *commentLabel = [UILabel labWithText:[NSString stringWithFormat:@"评论 %@",self.userModel.comment_num] fontSize:adaptFontSize(26) textColorString:COLOR060606];
        [headerView addSubview:commentLabel];
        
        UILabel *praiseLabel = [UILabel labWithText:[NSString stringWithFormat:@"%@ 赞",self.userModel.praise_num] fontSize:adaptFontSize(26) textColorString:COLOR060606];
        [headerView addSubview:praiseLabel];
        _praiseLabel = praiseLabel;
        
        UIView *lineView = [UIView new];
        lineView.backgroundColor = [UIColor colorWithString:COLORE1E1DF];
        [headerView addSubview:lineView];

        [commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(headerView);
            make.left.equalTo(headerView).offset(adaptWidth750(30));
            
        }];
        
        [praiseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(headerView);
            make.right.equalTo(headerView).offset(-adaptWidth750(30));

        }];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.right.equalTo(headerView);
            make.height.mas_equalTo(0.5);
            make.bottom.equalTo(headerView);
            
        }];
        return headerView;
        
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return adaptHeight1334(80);
    }
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, adaptHeight1334(10))];
        view.backgroundColor = [UIColor groupTableViewBackgroundColor];
        return view;
    }
    return nil;
}

- (TimelineCommentView *)commentView
{
    if (!_commentView) {
        _commentView = [TimelineCommentView new];
        _commentView.frame = CGRectMake(0, kScreenHeight - 64 - 49, kScreenWidth, 49);
        _commentView.delegate = self;
    }
    return _commentView;
}

- (ShowCommentView *)showCommentView
{
    if (!_showCommentView) {
        _showCommentView = [ShowCommentView new];
    }
    return _showCommentView;
}

@end
