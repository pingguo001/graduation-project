//
//  UserTimelineManager.h
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/11/8.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TimelineModel.h"

@interface UserTimelineManager : NSObject

// 存储用户发布的动态字典
+ (void)saveUserTimelineToDocumentWithDictionary:(NSDictionary *)dictionary;

// 读取用户发布的动态
+ (NSMutableArray *)readUserTimelineFromDocument;

@end
