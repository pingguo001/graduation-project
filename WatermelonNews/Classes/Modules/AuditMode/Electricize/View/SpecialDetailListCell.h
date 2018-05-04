//
//  SpecialDetailListCell.h
//  MakeMoney
//
//  Created by yedexiong on 2017/2/10.
//  Copyright © 2017年 yoke121. All rights reserved.
//  专辑详情列表cell

#import <UIKit/UIKit.h>

@class EpisodeModel;
@interface SpecialDetailListCell : UITableViewCell

@property(nonatomic,strong) EpisodeModel *model;

@property(nonatomic,copy)void(^playBtnClick)(EpisodeModel *);

@end
