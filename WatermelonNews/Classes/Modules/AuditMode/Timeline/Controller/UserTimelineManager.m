//
//  UserTimelineManager.m
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/11/8.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "UserTimelineManager.h"

@implementation UserTimelineManager

// 存储用户信息字典
+ (void)saveUserTimelineToDocumentWithDictionary:(NSDictionary *)dictionary {
    NSString *diskStr = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES)[0];
    NSString *filePath = [diskStr stringByAppendingString:@"userInfo.plist"];
    
    [NSKeyedArchiver archiveRootObject:dictionary toFile:filePath];
}

// 读取用户信息
+ (NSMutableArray *)readUserTimelineFromDocument{
    NSString *diskStr = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES)[0];
    NSString *filePath = [diskStr stringByAppendingString:@"userInfo.plist"];
    
    BOOL isHave = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    
    if (!isHave) {
        WNLog(@"没有本地文件");
        return [NSMutableArray array];
    }
    NSMutableDictionary *dic = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    return dic[@"data"];
}

@end
