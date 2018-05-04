//
//  TaskViewController.h
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/8/21.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WNBaseViewController.h"
#import "TaskAdModel.h"

typedef NS_ENUM(NSUInteger, PageType) {
    PageTypeTask,  /**< 任务 >*/
    PageTypeExchange, /**< 兑换 > */
    PageTypeDetail,  /**< 任务详情 >*/
};

@interface TaskAndExchangeController : WNBaseViewController

@property (assign, nonatomic) PageType pageType;
@property (strong, nonatomic) TaskAdModel *taskModel;

@end
