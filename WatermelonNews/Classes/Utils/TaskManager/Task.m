//
//  Task.m
//  Kratos
//
//  Created by Zhangziqi on 16/6/15.
//  Copyright © 2016年 lyq. All rights reserved.
//

#import "Task.h"

@interface Task ()

@property (nonatomic, readwrite, strong, nonnull) NSString       *identity;    /**< 任务id */
@property (nonatomic, readwrite, strong, nonnull) NSString       *name;       /**< 任务名称 */
@property (nonatomic, readwrite, strong, nonnull) NSString       *icon;       /**< 任务图标 */
@property (nonatomic, readwrite, assign)          NSInteger      points;      /**< 任务积分 */
@end

@implementation Task

- (NSDictionary *_Nonnull)dictionary {
    return @{
             @"id"          : _identity,
             @"name"        : _name,
             @"icon"        : _icon,
             @"money"       : @((float)_points / 100),
             };
}

@end
