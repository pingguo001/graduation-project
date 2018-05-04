//
//  TencentAdCell.h
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/9/12.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "BaseNewsCell.h"

typedef void(^DeleteBlock)();

static NSString *const TencentAdCellID = @"TencentAdCellID";

@interface TencentAdCell : BaseNewsCell

@property (copy, nonatomic) DeleteBlock deleteBlock;

@end
