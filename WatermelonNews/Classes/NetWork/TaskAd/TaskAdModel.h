//
//  TaskAdModel.h
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/10/27.
//  Copyright © 2017年 刘永杰. All rights reserved.
//
/*

 {
 "app_name" = "\U5f8b\U515c\U6cd5\U5f8b\U54a8\U8be2";
 "apple_id" = 992714103;
 "bundle_id" = "com.ilvdo.ios.kehu";
 "daily_activate_limit" = 300;
 "demander_id" = 1;
 "distribute_type" = 0;
 "download_url" = "";
 icon = "http://oss-cn-beijing.aliyuncs.com/lyq-ios/com.ilvdo.ios.kehu-404.jpg";
 id = 430;
 keyword = "\U6cd5\U5f8b\U54a8\U8be2";
 "left_num" = 0;
 money = "1.00";
 "start_time" = 61200;
 status = AVAILABLE;
 step = NONE;
 tags =     (
 ""
 );
 "task_type" = 2;
 time = 0;
 type = DOWNLOAD;
 star_num = 5;
 download_num = 21.5;
 sub_title = "应用描述";
 recommend = 1;
 }
 
*/

#import <Foundation/Foundation.h>

static NSString * const TaskAdType = @"iCC广告";

@interface TaskAdModel : NSObject

@property (copy, nonatomic) NSString *app_name;
@property (copy, nonatomic) NSString *apple_id;
@property (copy, nonatomic) NSString *bundle_id;
@property (copy, nonatomic) NSString *daily_activate_limit;
@property (copy, nonatomic) NSString *demander_id;
@property (copy, nonatomic) NSString *distribute_type;
@property (copy, nonatomic) NSString *download_url;
@property (copy, nonatomic) NSString *icon;
@property (copy, nonatomic) NSString *taskId;
@property (copy, nonatomic) NSString *keyword;
@property (copy, nonatomic) NSString *left_num;
@property (copy, nonatomic) NSString *money;
@property (copy, nonatomic) NSString *start_time;
@property (copy, nonatomic) NSString *status;
@property (copy, nonatomic) NSString *step;
@property (strong, nonatomic) NSArray *tags;
@property (copy, nonatomic) NSString *time;
@property (copy, nonatomic) NSString *type;
@property (copy, nonatomic) NSString *star_num;
@property (copy, nonatomic) NSString *download_num;
@property (copy, nonatomic) NSString *sub_title;
@property (copy, nonatomic) NSString *recommend;
@property (copy, nonatomic) NSString *source;

@property (copy, nonatomic) NSString *guides;
@property (copy, nonatomic) NSString *name;

@end
