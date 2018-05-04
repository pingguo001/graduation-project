//
//  PlayManager.h
//  MakeMoney
//
//  Created by yedexiong on 2017/2/11.
//  Copyright © 2017年 yoke121. All rights reserved.
//  播放管理单利

#import <Foundation/Foundation.h>
#import "EpisodeModel.h"
#import "SpecialDeailModel.h"
#import <AVFoundation/AVFoundation.h>


typedef enum {
    PlayStatusPause = 0, //停止播放/未播放
    PlayStatusPlaying, //正在播放
    PlayStatusStop //暂停播放
    
}PlayStatus;

@interface PlayManager : NSObject

@property(nonatomic,strong) AVPlayer *player;

//当前正在播放的音频集合
//注：当前播放某个专辑的音频，则持有持有这个专辑的数据源（此时与专辑详情界面数据源同步）
@property(nonatomic,strong) NSMutableArray *dataSource;

//专辑详情模型
@property(nonatomic,strong) SpecialDeailModel *detailModel;

//当前或上个播放模型
@property(nonatomic,strong) EpisodeModel *currentPlayModel;

//当前播放状态
@property(nonatomic,assign) PlayStatus playStatus;

//当前或者上一个正在播放的专辑标识：chancel +id 字符
@property(nonatomic,copy)NSString *currentPlayIndentifier;

+(instancetype)sharManager;

//配置音频信息
+(void)config;

//继续播放之前暂停的音频
-(void)play;
//播放指定的音频
-(void)playWithModel:(EpisodeModel*)model;

//播放下一首或上一首
-(void)playOther:(BOOL)isNext;

//暂停播放
-(void)pause;

@end
