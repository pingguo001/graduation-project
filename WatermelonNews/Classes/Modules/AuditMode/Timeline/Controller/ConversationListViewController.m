//
//  FriendsConversationListViewController.m
//  soosoa
//
//  Created by 刘永杰 on 2017/1/19.
//  Copyright © 2017年 liq. All rights reserved.
//

#import "ConversationListViewController.h"
#import "ConversationViewController.h"
#import "HttpRequest.h"

@interface ConversationListViewController ()<RCIMUserInfoDataSource>

@end

@implementation ConversationListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"聊天列表";
    //设置需要显示哪些类型的会话
    [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),@(ConversationType_DISCUSSION),@(ConversationType_CHATROOM),
        @(ConversationType_GROUP),
        @(ConversationType_APPSERVICE),
        @(ConversationType_SYSTEM)]];
    //设置需要将哪些类型的会话在会话列表中聚合显示
    [self setCollectionConversationType:@[@(ConversationType_DISCUSSION),@(ConversationType_GROUP)]];
    
    //获取用户信息的代理
    [RCIM sharedRCIM].userInfoDataSource = self;

    //设置头像为圆形的
    [self setConversationAvatarStyle:RC_USER_AVATAR_CYCLE];
    
    self.conversationListTableView.tableFooterView = [[UIView alloc] init];
}

//重写RCConversationListViewController的onSelectedTableRow事件
- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType
         conversationModel:(RCConversationModel *)model
               atIndexPath:(NSIndexPath *)indexPath {
    ConversationViewController *conversationVC = [[ConversationViewController alloc]init];
    conversationVC.conversationType = model.conversationType;
    conversationVC.targetId = model.targetId;
    conversationVC.nickName = model.conversationTitle;
    NSLog(@"%@", model.targetId);
    NSLog(@"%lld", model.receivedTime);
    [self.navigationController pushViewController:conversationVC animated:YES];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

@end
