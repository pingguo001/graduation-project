//
//  HomeHotCell.h
//  MakeMoney
//
//  Created by yedexiong on 16/10/29.
//  Copyright © 2016年 yoke121. All rights reserved.
//  首页热门职位cell

#import <UIKit/UIKit.h>

@class HotModel;

@interface HomeHotCell : UITableViewCell

@property(nonatomic,strong) HotModel *model;

+(instancetype)cellWithTableView:(UITableView*)tableView;

@end
