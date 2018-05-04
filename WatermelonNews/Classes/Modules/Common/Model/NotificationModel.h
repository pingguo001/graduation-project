//
//  NotificationModel.h
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/9/6.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewsArticleModel.h"

@interface NotificationModel : NSObject

@property (strong, nonatomic) NewsArticleModel *content;
@property (copy, nonatomic) NSString *type;

@end
