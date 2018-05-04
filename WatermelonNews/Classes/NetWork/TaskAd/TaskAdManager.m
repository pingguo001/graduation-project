//
//  TaskAdManager.m
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/10/27.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "TaskAdManager.h"
#import "TaskListApi.h"
#import "TaskStartApi.h"
#import "TaskDetailApi.h"
#import "TaskCancelApi.h"

@interface TaskAdManager ()<ResponseDelegate>

@property (strong, nonatomic) TaskStartApi *startApi;
@property (strong, nonatomic) TaskDetailApi *detailApi;
@property (strong, nonatomic) TaskCancelApi *cancelApi;
@property (copy,nonatomic) Success success;
@property (strong, nonatomic) UIViewController *currentController;
@property (strong, nonatomic) TaskAdModel *clickAdModel;

@end

@implementation TaskAdManager

+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    static TaskAdManager *manager;
    dispatch_once(&onceToken, ^{
        manager = [TaskAdManager new];
        manager.startApi = [[TaskStartApi alloc] init];
        manager.startApi.delegate = manager;
        manager.detailApi = [TaskDetailApi new];
        manager.detailApi.delegate = manager;
        manager.cancelApi = [TaskCancelApi new];
        manager.cancelApi.delegate = manager;
        
    });
    return manager;
}

//拉取任务
- (void)fetchTaskAd
{
    if ([UserManager currentUser].sensitiveArea.integerValue == 1) { //敏感地区无iCC任务
        return;
    }
    TaskListApi *listApi = [[TaskListApi alloc] init];
    listApi.delegate = self;
    [listApi call];
}

//开始做任务
- (void)doTaskAd:(TaskAdModel *)taskModel controller:(UIViewController *)controller success:(Success)success
{
    _success = success;
    self.clickAdModel = taskModel;
    self.currentController = controller;
    if (self.doingTask == nil) {
        self.doingTask = taskModel;
        _startApi.taskId = taskModel.taskId;
        [_startApi call];
        
    } else {
        
        if (![taskModel.taskId isEqualToString:self.doingTask.taskId]) {
            
            [self alertTaskProcess];
            
        } else {
            
            if (_success) {
                _success();
            }
        }
    }
}

- (void)cancelTask
{
    _cancelApi.taskId = self.doingTask.taskId;
    [_cancelApi call];
}

//获取任务详情信息
- (void)getTaskDetailSuccess:(Success)success
{
    if (self.doingTask == nil) {
        return;
    }
    _detailApi.taskId = self.doingTask.taskId;
    [_detailApi call];
    _success = success;
}

- (void)alertTaskProcess
{
    [AlertControllerTool alertControllerWithViewController:self.currentController title:[NSString stringWithFormat:@"《%@》\n", self.doingTask.keyword] message:@"任务正在进行中..." cancleTitle:@"放弃任务" sureTitle:@"去完成" cancleAction:^{
        
        [self cancelTask];
        
    } sureAction:^{
        
        if (_success) {
            _success();
        }
    }];
}

- (void)request:(NetworkRequest *)request success:(id)response
{
    if ([request.url containsString:startTaskUrl]) {
        
        WNLog(@"%@", response);
        if (_success) {
            _success(response);
        }
    } else if([request.url containsString:taskDetailUrl]) {
        
        if ([response[@"step"] isEqualToString:@"DONE"]) {
            if (_success) {
                _success(response);
            }
            self.doingTask = nil;
        } else if ([response[@"step"] isEqualToString:@"NONE"]){
            
            self.doingTask.step = @"NONE";
            self.doingTask = nil;
        }
        
    } else if([request.url containsString:cancleTaskUrl]) {
        
        self.doingTask.step = @"NONE";
        self.doingTask = nil;
        [self doTaskAd:self.clickAdModel controller:self.currentController success:_success];
        
    } else {
        self.adArray = [NSMutableArray array];
        NSMutableArray *array = [TaskAdModel mj_objectArrayWithKeyValuesArray:response].mutableCopy;
        [array enumerateObjectsUsingBlock:^(TaskAdModel *taskModel, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([taskModel.status isEqualToString:@"AVAILABLE"]) {
                
                [self.adArray addObject:taskModel];
                if (![taskModel.step isEqualToString:@"NONE"]) {
                    self.doingTask = taskModel;
                }
            }
            
        }];
        
    }
}

- (void)request:(NetworkRequest *)request failure:(NSError *)error
{
    if ([request.url containsString:startTaskUrl]) {
        self.doingTask = nil;
        if ([error.userInfo[@"data"][@"code"] integerValue] == 7) {
            
            self.doingTask = [TaskAdModel new];
            self.doingTask.taskId = error.userInfo[@"data"][@"task_id"];
            self.doingTask.keyword = error.userInfo[@"data"][@"keyword"];
            [self alertTaskProcess];
        }
    }
}

@end
