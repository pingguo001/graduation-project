//
//  TaskDetailModel.h
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/11/27.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TaskDetailModel : NSObject

@property (copy, nonatomic)   NSString *bundle_id;
@property (strong, nonatomic) NSArray *guides;
@property (copy, nonatomic)   NSString *icon;
@property (copy, nonatomic)   NSString *keyword;
@property (copy, nonatomic)   NSString *step;
@property (copy, nonatomic)   NSString *tags;
@property (copy, nonatomic)   NSString *time;
@property (copy, nonatomic)   NSString *type;

@end
