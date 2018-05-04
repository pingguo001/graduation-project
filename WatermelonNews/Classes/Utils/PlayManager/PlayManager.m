//
//  PlayManager.m
//  MakeMoney
//
//  Created by yedexiong on 2017/2/11.
//  Copyright © 2017年 yoke121. All rights reserved.
//

#import "PlayManager.h"
#import <MediaPlayer/MediaPlayer.h>

@interface PlayManager ()

@end

@implementation PlayManager

static PlayManager *_manager;

+(instancetype)sharManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[self alloc] init];
        
    });
    return _manager;
}

+(void)config
{
    //后台播放，设置会话类型。
    AVAudioSession *session = [AVAudioSession sharedInstance];
    //类型是:播放和录音。
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    //而且要激活，音频会话。
    [session setActive:YES error:nil];

}

-(instancetype)init
{
    if (self = [super init]) {
        self.playStatus = PlayStatusPause;
    }
    return self;
}

-(void)pause
{
    [self.player pause];
    self.playStatus = PlayStatusStop;
}

-(void)play
{
    [self.player play];
    self.playStatus = PlayStatusPlaying;
    self.currentPlayModel.isPlay = YES;
    //发送播放状态改变通知
    [[NSNotificationCenter defaultCenter] postNotificationName:Notify_Play_Change object:@"play"];
}


-(void)playWithModel:(EpisodeModel*)model
{
    [self removePlayStatus];
    
    [self.player replaceCurrentItemWithPlayerItem:[AVPlayerItem playerItemWithURL:[NSURL URLWithString:model.play_url]]];
    
    self.currentPlayModel = model;
    //设置播放状态
    self.playStatus = PlayStatusPlaying;
    
    [self.player play];
    //监听播放器状态
    [self addPlayStatus];
    //监听音乐播放完成通知
    [self addNSNotificationForPlayMusicFinish];
    //设置锁屏信息
    [self setupLockScreenInfo];
}

//播放上一首或下一首
-(void)playOther:(BOOL)isNext
{
    //1、获取当前播放资源在数组的索引
    NSInteger index = [self.dataSource indexOfObject:self.currentPlayModel];
    
    if (isNext) {
        index +=1;
        if (index == self.dataSource.count) {
            index = 0;
        }
    }else{
        index -=1;
        if (index < 0) {
            index = self.dataSource.count -1;
        }
    }
    
    //2、取出下一首播放资源
    EpisodeModel *nextModel = self.dataSource[index];
    self.currentPlayModel.isPlay = NO;
    [self playWithModel:nextModel];
    nextModel.isPlay = YES;
    //通知专辑详情界面刷新播放界面
    [[NSNotificationCenter defaultCenter] postNotificationName:Notify_Play_Change object:nil];

}

#pragma mark - 监听音乐各种状态
//通过KVO监听播放器状态
-(void)addPlayStatus
{
   [self.player.currentItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    
}
//移除监听播放器状态
-(void)removePlayStatus
{
    if (self.currentPlayModel ) {
        [self.player.currentItem removeObserver:self forKeyPath:@"status"];
    }
    
}

//音乐锁屏信息展示
- (void)setupLockScreenInfo
{
    // 1.获取锁屏中心
    MPNowPlayingInfoCenter *playingInfoCenter = [MPNowPlayingInfoCenter defaultCenter];
    
    // 2.设置锁屏参数
    NSMutableDictionary *playingInfoDict = [NSMutableDictionary dictionary];
    // 2.1设置歌曲名
    [playingInfoDict setObject:self.currentPlayModel.title forKey:MPMediaItemPropertyAlbumTitle];
    

    // 2.3回到主线程设置封面的图片
    if (self.detailModel.iconImage) {
        MPMediaItemArtwork *artwork = [[MPMediaItemArtwork alloc] initWithImage:self.detailModel.iconImage];
        [playingInfoDict setObject:artwork forKey:MPMediaItemPropertyArtwork];
    }
    
    // 2.4设置歌曲的总时长
    [playingInfoDict setObject:self.currentPlayModel.duration forKey:MPMediaItemPropertyPlaybackDuration];
    
    
    playingInfoCenter.nowPlayingInfo = playingInfoDict;
    
    // 3.开启远程交互
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
}


#pragma mark - NSNotification
-(void)addNSNotificationForPlayMusicFinish
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //给AVPlayerItem添加播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:_player.currentItem];
}

-(void)playFinished:(NSNotification*)notification
{
    
    [self playOther:YES];
}

#pragma mark -kvo 观察者回调
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context

{
    if ([keyPath isEqualToString:@"status"]) {
        switch (self.player.status) {
            case AVPlayerStatusUnknown:
            {
                NSLog(@"未知转态");
            }
                break;
            case AVPlayerStatusReadyToPlay:
            {
                NSLog(@"准备播放");
            }
                break;
            case AVPlayerStatusFailed:
            {
                NSLog(@"加载失败");
            }
                break;
                
            default:
                break;
        }
        
    }
}




#pragma mark - getter

-(AVPlayer *)player
{
    if (_player == nil) {
        AVPlayerItem *item = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:@""]];
        _player = [AVPlayer playerWithPlayerItem:item];
    }
    return _player;
}

-(NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end
