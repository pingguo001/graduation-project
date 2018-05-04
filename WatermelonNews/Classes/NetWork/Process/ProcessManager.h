//
//  ProcessManager.h
//  Kratos
//
//  Created by Zhangziqi on 16/5/11.
//  Copyright © 2016年 lyq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ErrorResolver.h"

@interface ProcessManager : NSObject
@property (nonatomic, strong) ErrorResolver * _Nullable resolver; /**< 发生错误时，调用其进行处理 */

/**
 获取单例对象
 
 @return 单例对象
 */
+ (instancetype _Nonnull)sharedInstance;

/**
 上传指定进程
 
 @param processName 要上传的进程名
 */
- (void)uploadProcess:(NSString *_Nonnull)processName;

/**
 上传做过的任务进行
 
 @param processArray 要上传的进程数组
 */
- (void)uploadProcessArray:(NSMutableArray *_Nullable)processArray;

@end
