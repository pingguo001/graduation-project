//
//  ElectricizeController.m
//  MakeMoney
//
//  Created by yedexiong on 2017/2/6.
//  Copyright © 2017年 yoke121. All rights reserved.
//

#import "ElectricizeController.h"
#import "TitleView.h"
#import "ContentView.h"
#import "ElectricizeContentController.h"
#import "PlayManager.h"
#import "MYProgressHUD.h"


@interface ElectricizeController ()<TitleViewDataSource>

@property(nonatomic,strong) TitleView *titleView;

@property(nonatomic,strong) ContentView *contentView;

@property(nonatomic,strong) UIButton *rigthItemBtn;

@end

@implementation ElectricizeController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self addObserver];
    
}

-(void)setupUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.titleView];
    [self.view addSubview:self.contentView];
    self.navigationItem .rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rigthItemBtn];
}

-(void)addObserver
{
    //监听播放器状态
    [[PlayManager sharManager] addObserver:self forKeyPath:@"playStatus" options:NSKeyValueObservingOptionNew context:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshRightItem:) name:Notify_Play_Change object:nil];
}

#pragma mark - TitleViewDataSource
-(NSArray*)showTitlesWithtitleView:(TitleView*)titleView
{
    return @[@"理财",@"创业",@"经管"];
}

-(void)titleView:(TitleView*)titleView selectIndex:(NSInteger)index
{
    [self.contentView scrollToIndex:index];
    
}

#pragma mark - kvo
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"currentPage"]) {
        NSInteger index = [change[@"new"] integerValue];
        [self.titleView selectIndex:index];
    }
    
    //播放器状态改变的回调
    if ([keyPath isEqualToString:@"playStatus"]) {
         NSInteger status = [change[@"new"] integerValue];
        if (status == PlayStatusPlaying) {
            self.rigthItemBtn.selected = YES;
        }else{
            self.rigthItemBtn.selected = NO;
        }
        
    }
    
}

#pragma mark - action

-(void)rigthItemBtnClick:(UIButton*)btn
{
    if (btn.selected) {
        //停止播放
        [[PlayManager sharManager] pause];
        [PlayManager sharManager].currentPlayModel.isPlay = NO;
        btn.selected = NO;
    }else{
        if ([PlayManager sharManager].playStatus == PlayStatusPause) {
            [MYProgressHUD showMessage:@"请进入专辑内选择播放内容"];
        }else{
             [[PlayManager sharManager] play];
              btn.selected = YES;
        }
    }
}

-(void)refreshRightItem:(NSNotification*)notification
{
    id object = notification.object;
    if (object) {
        if ([object isKindOfClass:[NSString class]]) {
            object = (NSString*)object;
            if ([object isEqualToString:@"play"]) {
                self.rigthItemBtn.selected = YES;
            }else{
                self.rigthItemBtn.selected = NO;
                
            }
        }
    }

}

#pragma mark - getter
-(TitleView *)titleView
{
    if (_titleView == nil) {
        _titleView = [[TitleView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, TitleViewH)];
        _titleView.dataSource = self;
        
    }
    return _titleView;
}

-(ContentView *)contentView
{
    if (_contentView == nil) {
       
        //创建子控制器
        UIViewController *vc1 = [[ElectricizeContentController alloc] initWithChannelType:ChannelTypeFinance];
        
        UIViewController *vc2 = [[ElectricizeContentController alloc] initWithChannelType:ChannelTypeChuanYe];
       
        UIViewController *vc3 = [[ElectricizeContentController alloc] initWithChannelType:ChannelTypeJingGuan];
        
        NSArray *childViewControllers = @[vc1,vc2,vc3];
       
        _contentView = [[ContentView alloc] initWithFrame:CGRectMake(0, 65+TitleViewH, kScreenWidth, kScreenHeight-65-TitleViewH) childViewControllers:childViewControllers parentVC:self];
        //利用观察者监听_contentView页面变化
        [_contentView addObserver:self forKeyPath:@"currentPage" options:NSKeyValueObservingOptionNew context:nil];
    }
    return _contentView;
}

-(UIButton *)rigthItemBtn
{
    if (_rigthItemBtn == nil) {
        _rigthItemBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [_rigthItemBtn setImage:[UIImage imageNamed:@"navigationbar_btn_play"] forState:UIControlStateNormal];
        [_rigthItemBtn setImage:[UIImage imageNamed:@"navigationbar_btn_play_pressed"] forState:UIControlStateSelected];
        [_rigthItemBtn addTarget:self action:@selector(rigthItemBtnClick:) forControlEvents:UIControlEventTouchDown];
    }
    return _rigthItemBtn;
}

#pragma mark - dealloc
- (void)dealloc
{
    [self.contentView removeObserver:self forKeyPath:@"currentPage"];
    [[PlayManager sharManager] removeObserver:self forKeyPath:@"playStatus"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
