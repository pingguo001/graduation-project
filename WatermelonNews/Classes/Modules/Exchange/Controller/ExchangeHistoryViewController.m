//
//  ExchangeHistoryViewController.m
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/11/29.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "ExchangeHistoryViewController.h"
#import "CashRecordCell.h"
#import "PaymentHistoryApi.h"
#import "ExchangeHistoryModel.h"

@interface ExchangeHistoryViewController ()<ResponseDelegate>

@property (strong, nonatomic) NSMutableArray *dataArray;

@property (strong, nonatomic) PaymentHistoryApi *historyApi;

@end

@implementation ExchangeHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"提现历史";
    [self.tableView registerClass:[CashRecordCell class] forCellReuseIdentifier:CashRecordCellID];
    
    _historyApi = [PaymentHistoryApi new];
    _historyApi.delegate = self;
    
    [self setupRefreshContol];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
}

- (void)setupRefreshContol
{
    //下拉
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        self.dataArray = [NSMutableArray array];
        _historyApi.page = 1;
        [_historyApi call];
        
    }];
    
    //上拉
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        _historyApi.page++;
        [_historyApi call];
        
    }];
    
    self.tableView.tableFooterView = [UIView new];
    [self.tableView.mj_header beginRefreshing];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    //去除上下导航半透明效果（不设置会渗透tableView内容）
    self.navigationController.navigationBar.translucent = NO;
    self.tabBarController.tabBar.translucent = NO;
}

#pragma mark - ResponseDelegate
- (void)request:(NetworkRequest *)request success:(id)response
{
    NSArray *array = [ExchangeHistoryModel mj_objectArrayWithKeyValuesArray:response[@"history"]];
    [self.dataArray addObjectsFromArray:array];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    
    if (array.count < 10 ) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
    
    [self.tableView reloadData];
}
- (void)request:(NetworkRequest *)request failure:(NSError *)error
{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CashRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:CashRecordCellID forIndexPath:indexPath];
    [cell configModelData:self.dataArray[indexPath.row] indexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return adaptHeight1334(140);
}

@end
