//
//  TaskAdManager.h
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/10/27.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TaskAdModel.h"

typedef void(^Success)();

@interface TaskAdManager : NSObject

@property (strong, nonatomic) NSMutableArray *adArray;
@property (strong, nonatomic) TaskAdModel *doingTask;

+ (instancetype)sharedManager;

- (void)fetchTaskAd;

- (void)doTaskAd:(TaskAdModel *)taskModel controller:(UIViewController *)controller success:(Success)success;

- (void)cancelTask;

- (void)getTaskDetailSuccess:(Success)success;

@end
