//
//  DetailJopDesCell.h
//  MakeMoney
//
//  Created by yedexiong on 16/10/30.
//  Copyright © 2016年 yoke121. All rights reserved.
//  兼职详情/职位描述

#import <UIKit/UIKit.h>

@class HotModel;
@interface DetailJopDesCell : UITableViewCell

@property(nonatomic,strong) HotModel *model;

+(instancetype)cellWithTableView:(UITableView*)tableView;


@end
