//
//  LYVideoPlayerControl.h
//  LYPlayerDemo
//
//  Created by liyang on 16/11/5.
//  Copyright © 2016年 com.liyang.player. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "LYSlider.h"
#import "VideoShareView.h"

@interface LYVideoPlayerControl : UIView

@property (nonatomic, copy)  void (^playButtonClick_block)(BOOL selected);//播放/暂停
@property (nonatomic, copy)  void (^sliderTouchEnd_block)(CGFloat time);//拖动滑块
@property (nonatomic, copy)  void (^fastFastForwardAndRewind_block)(CGFloat time);//快进快退
@property (nonatomic, copy)  void (^backButtonClick_block)();//返回
@property (nonatomic, copy)  void (^shareButtonClick_block)();//分享

@property (nonatomic, copy)  void (^fullScreenButtonClick_block)();//横屏播放
@property (nonatomic, copy)  void (^shareViewClick_block)(NSInteger index);//返回


@property (nonatomic, assign) CGFloat  currentTime;
@property (nonatomic, assign) CGFloat  totalTime;
@property (nonatomic, assign) CGFloat  playValue;   //播放进度
@property (nonatomic, assign) CGFloat  progress;    //缓冲进度
@property (assign, nonatomic) BOOL isPlaying;  //是否正在播放
@property (nonatomic, strong) UIButton *playButton;   //播放/暂停
@property (strong, nonatomic) UILabel  *titleLabel;      //标题
@property (strong, nonatomic) VideoShareView *shareView;
@property (nonatomic, strong) UIView   *topView;

//播放器调用方法
- (void)videoPlayerDidLoading;

- (void)videoPlayerDidBeginPlay;

- (void)videoPlayerDidEndPlay;

- (void)videoPlayerDidFailedPlay;

//外部方法播放
- (void)playerControlPlay;
//外部方法暂停
- (void)playerControlPause;

//横竖屏转换
- (void)fullScreenChanged:(BOOL)isFullScreen;

- (void)hiddenControlButton;

@end
