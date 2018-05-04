//
//  AdInfoModel.h
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/10/31.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AdLocationModel;

@interface AdInfoModel : NSObject

@property (strong, nonatomic) NSArray<AdLocationModel *> *adArray;
@property (strong, nonatomic) NSArray *adDefault;

@end

@interface AdLocationModel : NSObject

@property (copy, nonatomic) NSString *location;
@property (copy, nonatomic) NSString *type;

@end
