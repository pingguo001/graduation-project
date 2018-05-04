//
//  DetailsecondCell.h
//  MakeMoney
//
//  Created by yedexiong on 16/10/29.
//  Copyright © 2016年 yoke121. All rights reserved.
// 兼职详情-薪资待遇cell

#import <UIKit/UIKit.h>
@class HotModel;
@interface DetailsecondCell : UITableViewCell

@property(nonatomic,strong) HotModel *model;


+(instancetype)cellWithTableView:(UITableView*)tableView;

@end
