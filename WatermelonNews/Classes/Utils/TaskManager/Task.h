//
//  Task.h
//  Kratos
//
//  Created by Zhangziqi on 16/6/15.
//  Copyright © 2016年 lyq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Task : NSObject

@property (nonatomic, readonly, strong, nonnull) NSString       *identity;   /**< 任务id */
@property (nonatomic, readonly, strong, nonnull) NSString       *name;       /**< 任务名称 */
@property (nonatomic, readonly, strong, nonnull) NSString       *icon;       /**< 任务图标 */
@property (nonatomic, readonly, assign)          NSInteger      points;      /**< 任务积分 */

- (NSDictionary *_Nonnull)dictionary;

@end
