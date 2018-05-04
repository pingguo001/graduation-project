//
//  EpisodeModel.h
//  MakeMoney
//
//  Created by yedexiong on 2017/2/10.
//  Copyright © 2017年 yoke121. All rights reserved.
//  音频集模型

#import <Foundation/Foundation.h>


@interface EpisodeModel : NSObject

@property(nonatomic,copy)NSString *title;

@property(nonatomic,copy)NSString *play_url;

@property(nonatomic,strong)NSNumber *duration;

@property(nonatomic,strong)NSNumber *play_count;

@property(nonatomic,copy)NSString *date;

//是否正在播放
@property(nonatomic,assign) BOOL isPlay;

@end
