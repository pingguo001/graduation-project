//
//  AdInfoModel.m
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/10/31.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "AdInfoModel.h"

@implementation AdInfoModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"adDefault":@"default"};
}

+ (NSDictionary *)mj_objectClassInArray{
    
    return @{@"adArray":[AdLocationModel class]};
}

@end

@implementation AdLocationModel



@end
