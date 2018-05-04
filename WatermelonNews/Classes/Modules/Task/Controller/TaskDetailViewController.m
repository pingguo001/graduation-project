//
//  TaskDetailViewController.m
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/11/27.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "TaskDetailViewController.h"
#import "DetailFooterView.h"
#import "TaskDetailApi.h"
#import "TaskDetailModel.h"
#import "TaskDetailCell.h"
#import "PackageManager.h"
#import "ProcessManager.h"
#import "BackgroundTask.h"
#import "TaskMonitor.h"
#import "WNBaseViewController.h"
#import "TaskAdManager.h"
#import "TaskFinishStepApi.h"
#import "TaskCancelApi.h"

@interface TaskDetailViewController () <ResponseDelegate, ApplicationSwitchDelegate, UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView         *tableView;

@property (nonatomic, strong) PackageManager      *packageManager;    /**< 安装包管理的实例对象 */
@property (nonatomic, strong) ProcessManager      *processManager;    /**< 进程管理的实例对象 */
@property (nonatomic, strong) BackgroundTask      *backgroundTask;    /**< 后台长时间任务 */

@property (strong, nonatomic) TaskMonitor         *taskMonitor;

@property (strong, nonatomic) DetailFooterView    *footerView;
@property (strong, nonatomic) TaskDetailApi       *taskDetailApi;
@property (strong, nonatomic) TaskDetailModel     *taskDetailModel;
@property (strong, nonatomic) TaskFinishStepApi   *finishStepApi;
@property (strong, nonatomic) TaskCancelApi       *taskCancelApi;

@end

@implementation TaskDetailViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_taskDetailApi call];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
    
    [self initNewWorkApi];
    [self initPackageManager];
    [self initProcessManager];
    [self initBackgroundTask];
}

- (void)initNewWorkApi
{
    _taskDetailApi = [TaskDetailApi new];
    _taskDetailApi.delegate = self;
    _taskDetailApi.taskId = self.doingTaskModel.taskId;
    
    _finishStepApi = [TaskFinishStepApi new];
    _finishStepApi.delegate = self;
    _finishStepApi.taskId = self.doingTaskModel.taskId;
    
    _taskCancelApi = [TaskCancelApi new];
    _taskCancelApi.delegate = self;
    _taskCancelApi.taskId = self.doingTaskModel.taskId;
}

/**
 *  初始化安装包管理
 */
- (void)initPackageManager {
    _packageManager = [[PackageManager alloc] init];
}

/**
 *  初始化进程管理
 */
- (void)initProcessManager {
    _processManager = [ProcessManager sharedInstance];
}

/**
 *  初始化后台任务
 */
- (void)initBackgroundTask {
    _backgroundTask = [[BackgroundTask alloc] init];
}

- (void)setupViews
{
    self.navigationController.navigationBar.translucent = NO;

    self.title = @"任务详情";
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[TaskDetailCell class] forCellReuseIdentifier:TaskDetailCellID];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
    self.tableView.sectionHeaderHeight = 0;
    
    self.footerView = [[DetailFooterView alloc] init];
    self.tableView.tableFooterView = self.footerView;
    WS(weakSelf)
    self.footerView.backResult = ^(NSInteger index) {
        if (index == 0) {
            [AlertControllerTool alertControllerWithViewController:weakSelf title:@"" message:@"确定放弃当前任务？" cancleTitle:@"取消" sureTitle:@"确定" cancleAction:nil sureAction:^{
                [weakSelf.taskCancelApi call];
            }];
        } else if (index == 1) {
            [weakSelf.taskCancelApi call];
        } else if (index == 2) {
            [weakSelf.finishStepApi call];
        }
    };
}

#pragma mark - ResponseDelegate
- (void)request:(NetworkRequest *)request success:(id)response
{
    if ([request.url containsString:taskDetailUrl]) {
        self.taskDetailModel = [TaskDetailModel mj_objectWithKeyValues:response];
        [self.footerView configModelData:self.taskDetailModel];
        [self.tableView reloadData];
        
        self.doingTaskModel.step = self.taskDetailModel.step;
        self.doingTaskModel.time = self.taskDetailModel.time;
        
    } else if ([request.url containsString:finishStepUrl]) {
        
        TaskAdModel *currentModel = [TaskAdManager sharedManager].doingTask;
        if ([currentModel.type isEqualToString:@"DOWNLOAD"] && currentModel.download_url.length != 0) {
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:currentModel.download_url]];
            
        } else {
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://"]];
        }
        [self.taskMonitor startWithBundleId:currentModel.bundle_id];
    } else if ([request.url containsString:cancleTaskUrl]){
        
        self.doingTaskModel.step = @"NONE";
        [TaskAdManager sharedManager].doingTask = nil;
        [self.navigationController popViewControllerAnimated:YES];

    }
    
    
}
- (void)request:(NetworkRequest *)request failure:(NSError *)error
{
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TaskDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:TaskDetailCellID forIndexPath:indexPath];
    [cell configModelData:self.taskDetailModel indexPath:indexPath];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView fd_heightForCellWithIdentifier:TaskDetailCellID cacheByKey:self.taskDetailModel.bundle_id configuration:^(TaskDetailCell *cell) {
        [cell configModelData:self.taskDetailModel indexPath:indexPath];
    }];
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
    [_taskDetailApi call];

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

- (TaskMonitor *)taskMonitor
{
    if (!_taskMonitor) {
        _taskMonitor = [TaskMonitor new];
    }
    return _taskMonitor;
}


@end
