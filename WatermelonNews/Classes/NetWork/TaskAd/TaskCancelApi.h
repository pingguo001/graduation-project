//
//  TaskCancelApi.h
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/10/30.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "BaseApi.h"

static NSString * _Nullable const cancleTaskUrl = @"/v1/task/canceltask";


@interface TaskCancelApi : BaseApi

@property(nonatomic, weak) id <ResponseDelegate> _Nullable delegate; /**< 回调的代理 */
@property (copy, nonatomic) NSString * _Nullable taskId;

/**
 *  调用请求
 */
- (void)call;

@end
