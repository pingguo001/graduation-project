//
//  ConversationViewController.m
//  soosoa
//
//  Created by 刘永杰 on 2017/1/19.
//  Copyright © 2017年 liq. All rights reserved.
//

#import "ConversationViewController.h"
#import "HttpRequest.h"

@interface ConversationViewController ()<RCIMUserInfoDataSource>

@end

@implementation ConversationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.displayUserNameInCell = YES;
    self.title = self.nickName;
    
    //移除位置信息的发送扩展按钮
    [self.chatSessionInputBarControl.pluginBoardView removeItemAtIndex:2];
    
    //获取用户信息的代理
    [RCIM sharedRCIM].userInfoDataSource = self;
    
    //头像形状设置
    [RCIM sharedRCIM].globalMessageAvatarStyle = RC_USER_AVATAR_CYCLE;
    
}

//获取用户名和用户头像的代理实现
- (void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion
{
    
    [HttpRequest rongCloudPost:@"http://api.cn.ronghub.com/user/info.json" params:@{@"userId" : userId} success:^(id responseObj) {
        
        RCUserInfo *userInfo = [RCUserInfo new];
        userInfo.userId = userId;
        userInfo.name = responseObj[@"userName"];
        userInfo.portraitUri = responseObj[@"userPortrait"];
        NSLog(@"%@", userId);
        completion(userInfo);
        
    } failure:^(NSError *error) {
        
    }];
    
}

//点击用户头像的跳转用户主页
- (void)didTapCellPortrait:(NSString *)userId
{
//    FriendMainPageViewController *mainPage = [FriendMainPageViewController new];
//    [self showViewController:mainPage sender:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
