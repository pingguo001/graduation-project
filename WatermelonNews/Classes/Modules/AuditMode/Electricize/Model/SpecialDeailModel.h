//
//  SpecialDeailModel.h
//  MakeMoney
//
//  Created by yedexiong on 2017/2/10.
//  Copyright © 2017年 yoke121. All rights reserved.
//  专辑详情模型

#import <Foundation/Foundation.h>

@interface SpecialDeailModel : NSObject

@property(nonatomic,copy)NSString *title;

@property(nonatomic,copy)NSString *icon_url;

@property(nonatomic,strong) UIImage *iconImage;

@property(nonatomic,copy)NSString *play_count;

@property(nonatomic,copy)NSString *brief;

@property(nonatomic,copy)NSString *intro;
//集数
@property(nonatomic,copy)NSString *episode_count;
//音频列表,里面装EpisodeModel模型
@property(nonatomic,strong) NSArray *episodes;


//辅助属性 当前音频列表页数
@property(nonatomic,assign) NSInteger currentPage;

@property(nonatomic,assign) CGFloat desCellHeight;

@end

