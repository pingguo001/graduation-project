//
//  CashRecordViewController.m
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/11/25.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "CashRecordViewController.h"
#import "CashRecordCell.h"
#import "RewardHistoryApi.h"
#import "RewardHistoryModel.h"
#import "ExchangeCell.h"

@interface CashRecordViewController ()<ResponseDelegate>

@property (strong, nonatomic) RewardHistoryApi *rewardApi;
@property (strong, nonatomic) NSMutableArray *dataArray;

@property (strong, nonatomic) NSArray *titleArray;
@property (strong, nonatomic) NSArray *moneyArray;

@end

@implementation CashRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"收入详情";
    self.navigationController.navigationBar.translucent = NO;
    [self.tableView registerClass:[CashRecordCell class] forCellReuseIdentifier:CashRecordCellID];
    [self.tableView registerClass:[ExchangeCell class] forCellReuseIdentifier:ExchangeCellID];
    [self setupRefreshContol];
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, adaptHeight1334(20))];
    self.tableView.sectionHeaderHeight = adaptHeight1334(20);
    self.tableView.sectionFooterHeight = 0;
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    self.titleArray = @[@"余额", @"今日收入", @"总收入"].mutableCopy;
    self.moneyArray = @[self.moneyInfoModel.remainingMoney, self.moneyInfoModel.todayMoney, self.moneyInfoModel.totalMoney].mutableCopy;
    
    _rewardApi = [RewardHistoryApi new];
    _rewardApi.delegate = self;
    
}

- (void)setupRefreshContol
{
    //下拉
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        self.dataArray = [NSMutableArray array];
        _rewardApi.page = 1;
        [_rewardApi call];

    }];
    
    //上拉
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        _rewardApi.page ++;
        [_rewardApi call];
        
    }];
    
    [self.tableView.mj_header beginRefreshing];
    
}

#pragma mark - ResponseDelegate
- (void)request:(NetworkRequest *)request success:(id)response
{
    NSArray *array = [RewardHistoryModel mj_objectArrayWithKeyValuesArray:response[@"history"]];
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
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    }
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        ExchangeCell *cell = [tableView dequeueReusableCellWithIdentifier:ExchangeCellID forIndexPath:indexPath];
        cell.titleLabel.text = self.titleArray[indexPath.row];
        cell.moneyLabel.text = [NSString stringWithFormat:@"%@元", self.moneyArray[indexPath.row]];
        [cell configModelData:@"" indexPath:indexPath];
        return cell;
    } else {
        CashRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:CashRecordCellID forIndexPath:indexPath];
        [cell configModelData:self.dataArray[indexPath.row] indexPath:indexPath];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return adaptHeight1334(92);
    }
    return adaptHeight1334(140);
}

@end
