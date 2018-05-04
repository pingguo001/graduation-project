//
//  TaskManager.h
//  Kratos
//
//  Created by Zhangziqi on 16/6/15.
//  Copyright © 2016年 lyq. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSInteger const ERROR_TASK_NOT_FOUND = 7701;
static NSInteger const ERROR_APP_NOT_FOUND  = 7702;

@class Task;
typedef void(^ResponseBlock)(NSError *_Nullable error, id _Nullable obj);

@interface TaskManager : NSObject

+ (instancetype _Nonnull)defaultManager;

- (void)fetchFastTasksWithResponseBlock:(ResponseBlock _Nullable)block;

- (Task *_Nullable)getFastTaskDetailWithTaskId:(NSString *_Nonnull)taskId;

- (Task *_Nullable)getSignTaskDetailWithTaskId:(NSString *_Nonnull)taskId;

- (void)fetchSignTasksWithResponseBlock:(ResponseBlock _Nullable)block;

- (void)startTask:(Task *_Nonnull)task withResponseBlock:(ResponseBlock _Nullable)block;

- (void)startTaskWithURL:(NSURL *_Nonnull)taskId;

- (void)submitTask:(Task *_Nonnull)task withResponseBlock:(ResponseBlock _Nullable)block;

- (void)cancelTask:(Task *_Nonnull)task withResponseBlock:(ResponseBlock _Nullable)block;

- (void)monitorTask:(NSString *_Nonnull)bundleId;

@end
