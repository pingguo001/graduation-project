//
//  TaskManager.m
//  Kratos
//
//  Created by Zhangziqi on 16/6/15.
//  Copyright © 2016年 lyq. All rights reserved.
//

#import "TaskManager.h"
#import "NSURL+Split.h"
#import "TaskMonitor.h"


@interface TaskManager ()

@property (nonatomic, strong) ResponseBlock fetchFastTaskResponseBlock;
@property (nonatomic, strong) ResponseBlock fetchSignTaskResponseBlock;
@property (nonatomic, strong) ResponseBlock startFastTaskResponseBlock;
@property (nonatomic, strong) ResponseBlock startSignTaskResponseBlock;
@property (nonatomic, strong) ResponseBlock cancelFastTaskResponseBlock;
@property (nonatomic, strong) ResponseBlock submitFastTaskResponseBlock;

@property (nonatomic, strong) TaskMonitor   *monitor; /**< 监听任务 */

@end

@implementation TaskManager

+ (instancetype _Nonnull)defaultManager {
    static TaskManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[TaskManager alloc] init];
    });
    return instance;
}

- (instancetype _Nonnull)init {
    self = [super init];
    if (self) {

    }
    return self;
}

/**
 *  拉取快速任务
 *
 *  @param block 回调Block
 */
- (void)fetchFastTasksWithResponseBlock:(ResponseBlock)block {
    _fetchFastTaskResponseBlock = block;
    
}

/**
 *  拉取签到任务
 *
 *  @param block 回调Block
 */
- (void)fetchSignTasksWithResponseBlock:(ResponseBlock)block {
    _fetchSignTaskResponseBlock = block;
}

/**
 *  根据任务ID获取任务详情
 *
 *  @param taskId 任务ID
 *
 *  @return 任务对象
 */
- (Task *_Nullable)getFastTaskDetailWithTaskId:(NSString *_Nonnull)taskId {
    return nil;
}

/**
 *  根据任务ID获取签到任务详情
 *
 *  @param taskId 任务ID
 *
 *  @return 签到任务对象
 */
- (Task *_Nullable)getSignTaskDetailWithTaskId:(NSString *_Nonnull)taskId {
    return nil;
}

/**
 *  开始任务
 *
 *  @param task  要开始的任务
 *  @param block 开始的回调
 */
- (void)startTask:(Task *_Nonnull)task withResponseBlock:(ResponseBlock)block {

}

/**
 *  开始任务
 *  专门为万普和趣米写的，因为他们家的任务会经过一个Web，如果我们的应用在后台是没办法打开Web
 *  所以目前的解决办法就是通过URL从Web端把刀刀调起前台，然后调用万普或趣米接口开始任务
 *
 *  因为这个方法会在 application:openURL:sourceApplication:annotation: 内调用，
 *  所以内部进行异步处理。
 *
 *  @param url 包含任务ID的URL
 */
- (void)startTaskWithURL:(NSURL *_Nonnull)url {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSString *taskId = [url queryItemForKey:@"task_id"];
        Task *aim = [self getFastTaskDetailWithTaskId:taskId];
        if (aim != nil) {
            [self startTask:aim withResponseBlock:nil];
        }
    });
}

/**
 *  提交任务
 *
 *  @param task  要提交的任务
 *  @param block 提交的回调，只有斗金任务需要提交
 */
- (void)submitTask:(Task *_Nonnull)task withResponseBlock:(ResponseBlock)block {
    _submitFastTaskResponseBlock = block;
}

/**
 *  取消任务
 *
 *  @param task  要取消的任务
 *  @param block 取消的回调，只有斗金任务需要取消
 */
- (void)cancelTask:(Task *_Nonnull)task withResponseBlock:(ResponseBlock)block {
    _cancelFastTaskResponseBlock = block;
}

/**
 监听指定的任务，监听到后会上传服务端，之后自动停止监听

 @param bundleId 要监听任务的Bundle Id
 */
- (void)monitorTask:(NSString *_Nonnull)bundleId {
    if (_monitor == nil)
        _monitor = [TaskMonitor new];
    
    [_monitor startWithBundleId:bundleId];
}

/**
 *  是否可以汇总任务
 *
 *  @return 是否可以汇总
 */
- (BOOL)shouldCollectTasks {
    return NO;
}

/**
 *  汇总任务
 */
- (void)collectTasks {
}

/**
 *  任务对象转换为任务字典
 *
 *  @param taskObjects 要转换的任务对象数组
 *
 *  @return 转换后的任务字典数组
 */
- (NSArray *)taskObjectsToTaskDictionaries:(NSArray *)taskObjects {
    NSMutableArray *taskDictionaries = [NSMutableArray arrayWithCapacity:taskObjects.count];
    for (id taskObject in taskObjects) {
        if ([taskObject respondsToSelector:@selector(dictionary)]) {
            [taskDictionaries addObject:[taskObject dictionary]];
        }
    }
    return [taskDictionaries copy];
}

@end
