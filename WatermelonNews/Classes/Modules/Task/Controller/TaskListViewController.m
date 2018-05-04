//
//  TaskListViewController.m
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/11/25.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "TaskListViewController.h"
#import "TaskListCell.h"
#import "TaskHeaderView.h"
#import "CashRecordViewController.h"
#import "FeedbackViewController.h"
#import "InviteAlertView.h"
#import "TaskListApi.h"
#import "TaskAdModel.h"
#import "SignTaskListApi.h"
#import "MoneyInfoApi.h"
#import "MoneyInfoApi.h"
#import "TaskDetailViewController.h"
#import "TaskAdManager.h"
#import "StartSignTaskApi.h"
#import "PackageManager.h"
#import "ProcessManager.h"
#import "TaskRatioApi.h"

@interface TaskListViewController ()<UITableViewDelegate, UITableViewDataSource, ResponseDelegate>

@property (strong, nonatomic) UITableView       *tableView;
@property (strong, nonatomic) TaskHeaderView    *taskHeaderView;

@property (strong, nonatomic) TaskListApi       *listApi;
@property (strong, nonatomic) MoneyInfoApi      *moneyInfoApi;
@property (strong, nonatomic) TaskRatioApi      *ratioApi;

@property (strong, nonatomic) SignTaskListApi   *signTasksApi;
@property (strong, nonatomic) StartSignTaskApi  *startSignApi;
@property (strong, nonatomic) TaskAdModel       *signingModel;

@property (strong, nonatomic) NSMutableArray    *dataArray;
@property (strong, nonatomic) NSMutableArray    *availableArray;
@property (strong, nonatomic) NSMutableArray    *pendingArray;
@property (strong, nonatomic) NSMutableArray    *unavailaeblArray;
@property (strong, nonatomic) NSMutableArray    *signArray;

@property (strong, nonatomic) MoneyInfoModel    *moneyModel;
@property (strong, nonatomic) TaskAdModel       *inviteModel;
@property (assign, nonatomic) BOOL              isDoingTask;

@end

@implementation TaskListViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self requestNetworkData];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViews];
    [self createHeaderView];
    [self initNetworkApi];

}

- (void)setupViews
{
    //去除上下导航半透明效果（不设置会渗透tableView内容）
    self.navigationController.navigationBar.translucent = NO;
    self.tabBarController.tabBar.translucent = NO;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"刷新" style:UIBarButtonItemStylePlain target:self action:@selector(freshAction)];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kHeaderHeight, kScreenWidth, kScreenHeight - kTabBarHeight - kNaviBarHeight - kHeaderHeight) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.sectionFooterHeight = adaptHeight1334(10);
    [self.tableView registerClass:[TaskListCell class] forCellReuseIdentifier:TaskListCellID];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.01f)];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, adaptHeight1334(40))];
    //下拉
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requestNetworkData];
    }];
    
    self.dataArray = @[@[self.inviteModel]].mutableCopy;
}

- (void)freshAction{
    [self.tableView.mj_header beginRefreshing];
}

- (void)createHeaderView
{
    self.taskHeaderView = [[TaskHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kHeaderHeight)];
    [self.view addSubview: self.taskHeaderView];
    WS(weakSelf)
    self.taskHeaderView.backResult = ^(NSInteger index) {
        
        CashRecordViewController *recordVC = [[CashRecordViewController alloc] initWithStyle:UITableViewStyleGrouped];
        if (weakSelf.moneyModel == nil) {
            return;
        }
        recordVC.moneyInfoModel = weakSelf.moneyModel;
        [weakSelf showViewController:recordVC sender:nil];
        
    };
}

#pragma mark - NetworkData
- (void)initNetworkApi
{
    _listApi = [[TaskListApi alloc] init];
    _listApi.delegate = self;
    
    _signTasksApi = [[SignTaskListApi alloc] init];
    _signTasksApi.delegate = self;
    
    _moneyInfoApi = [MoneyInfoApi new];
    _moneyInfoApi.delegate = self;
    
    _startSignApi = [StartSignTaskApi new];
    _startSignApi.delegate = self;
    
    _ratioApi = [TaskRatioApi new];
    _ratioApi.delegate = self;
}

- (void)requestNetworkData
{
    [_listApi call];
    [_signTasksApi call];
    [_moneyInfoApi call];
    [_ratioApi call];
    self.isDoingTask = NO;
}

- (void)dealwithListData:(id)response
{
    NSMutableArray *array = [TaskAdModel mj_objectArrayWithKeyValuesArray:response].mutableCopy;
    self.availableArray = [NSMutableArray array];
    self.pendingArray = [NSMutableArray array];
    self.unavailaeblArray = [NSMutableArray array];
    [array enumerateObjectsUsingBlock:^(TaskAdModel *taskModel, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([taskModel.status isEqualToString:@"UNAVAILABLE"]) {
            [self.unavailaeblArray addObject:taskModel];
        } else if ([taskModel.status isEqualToString:@"PENDING"]){
            [self.pendingArray addObject:taskModel];
        } else if ([taskModel.status isEqualToString:@"AVAILABLE"]){
            [self.availableArray addObject:taskModel];
            if (![taskModel.step isEqualToString:@"NONE"]) {
                [TaskAdManager sharedManager].doingTask = taskModel;
                self.isDoingTask = YES;
                [self.availableArray exchangeObjectAtIndex:0 withObjectAtIndex:self.availableArray.count - 1];  //正在做的任务移至最顶端
            }
        }
    }];
    if (self.isDoingTask == NO) {
        [TaskAdManager sharedManager].doingTask = nil;  //任务做完的时候置空当前任务
    }
    self.dataArray = @[@[self.inviteModel],self.availableArray, self.pendingArray, self.unavailaeblArray].mutableCopy;
    [self.tableView reloadData];
    WNLog(@"%@", array);
    [self.tableView.mj_header endRefreshing];
}

- (void)dealWihtSignData:(id)response
{
    self.signArray = [NSMutableArray array];
    NSMutableArray *array = [TaskAdModel mj_objectArrayWithKeyValuesArray:response].mutableCopy;
    [array enumerateObjectsUsingBlock:^(TaskAdModel *taskModel, NSUInteger idx, BOOL * _Nonnull stop) {
        taskModel.status = @"SIGN";
        [self.signArray addObject:taskModel];
    }];
    self.dataArray = @[@[self.inviteModel],self.availableArray,self.signArray, self.pendingArray, self.unavailaeblArray].mutableCopy;
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];

}

#pragma mark - ResponseDelegate
- (void)request:(NetworkRequest *)request success:(id)response
{
    if ([request.url containsString:taskListUrl]) {
        [self dealwithListData:response];
    } else if ([request.url containsString:SignTasksUrl]){
        [self dealWihtSignData:response];
    } else if ([request.url containsString:getMoneyInfoUrl]){
        self.moneyModel = [MoneyInfoModel mj_objectWithKeyValues:response];
        [[UserManager currentUser] setMoney:self.moneyModel.remainingMoney];
        [self.taskHeaderView configModelData:self.moneyModel];
    } else if ([request.url containsString:startSignUrl]) {
        if ([PackageManager openApp:self.signingModel.bundle_id]) {
            [[ProcessManager sharedInstance] uploadProcess:self.signingModel.bundle_id]; //上传进程
        }
    } else if ([request.url containsString:syncTaskUrl]){
        [[UserManager currentUser] setTaskRatio:[NSString stringWithFormat:@"%.2f", [response[@"coefficientConfig"][@"downloadCoefficient"][@"ICC"] floatValue]]];
        [[UserManager currentUser] setSignRatio:[NSString stringWithFormat:@"%.2f", [response[@"coefficientConfig"][@"signCoefficient"][@"ICC"] floatValue]]];
    }
}

- (void)request:(NetworkRequest *)request failure:(NSError *)error
{
    [self.tableView.mj_header endRefreshing];
    if ([request.url containsString:taskListUrl]) {
        [self.listApi call];
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, adaptHeight1334(64))];
    backView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    NSString *titleStr;
    if ([self.dataArray[section] count] != 0) {
        
        TaskAdModel *model = [self.dataArray[section] firstObject];
        if ([model.status isEqualToString:@"AVAILABLE"]) {
            titleStr = @"正在进行";
        } else if ([model.status isEqualToString:@"UNAVAILABLE"]){
            titleStr = @"已抢光";
        } else if ([model.status isEqualToString:@"PENDING"]){
            titleStr = @"即将开始";
        } else if ([model.status isEqualToString:@"SIGN"]){
            titleStr = @"签到任务";
        }
    }
    UILabel *label = [UILabel labWithText:titleStr fontSize:adaptFontSize(26) textColorString:COLORAEAEAE];
    label.frame = CGRectMake(adaptWidth750(kSpecWidth), 0, kScreenWidth - adaptWidth750(kScreenWidth), adaptHeight1334(64));
    [backView addSubview:label];
    return backView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([self.dataArray[section] count] == 0 || [[[self.dataArray[section] firstObject] status] isEqualToString:@"INVITE"]) {
        return 0;
    }
    return adaptHeight1334(64);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TaskListCell *cell = [tableView dequeueReusableCellWithIdentifier:TaskListCellID forIndexPath:indexPath];
    TaskAdModel *model = self.dataArray[indexPath.section][indexPath.row];
    [cell configModelData:model indexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return adaptHeight1334(130);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TaskAdModel *model = self.dataArray[indexPath.section][indexPath.row];
    if ([model.status isEqualToString:@"PENDING"]) {
        [self showAlertStr:@"任务未开始，记得准时来抢！"];
    } else if ([model.status isEqualToString:@"UNAVAILABLE"]) {
        [self showAlertStr:@"任务已被抢光，换个任务试试吧！"];
    } else if ([model.status isEqualToString:@"AVAILABLE"]) {
        
        [[TaskAdManager sharedManager] doTaskAd:model controller:self success:^{
            
            TaskDetailViewController *detailVC = [TaskDetailViewController new];
            detailVC.doingTaskModel = [TaskAdManager sharedManager].doingTask;
            [self showViewController:detailVC sender:nil];
        }];
    } else if ([model.status isEqualToString:@"INVITE"]) {
        
        [[InviteAlertView new] show];
        [TalkingDataApi trackEvent:TD_CLICK_TASK_INVITE];
        
    } else if ([model.status isEqualToString:@"SIGN"]) {
        
        if ([PackageManager isAppInstalled:model.bundle_id]) {
            self.signingModel = model;
            _startSignApi.taskId = model.taskId;
            [_startSignApi call];
        } else {
            [self showAlertStr:@"请安装后尝试"];
        }
    }
}

- (void)showAlertStr:(NSString *)str
{
    [AlertControllerTool alertControllerWithViewController:self title:@"" message:str cancleTitle:@"" sureTitle:@"我知道了" cancleAction:nil sureAction:^{
        
    }];
}

- (TaskAdModel *)inviteModel
{
    if (!_inviteModel) {
        _inviteModel = [TaskAdModel new];
        _inviteModel.status = @"INVITE";
        _inviteModel.keyword = @"邀请好友";
    }
    return _inviteModel;
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
