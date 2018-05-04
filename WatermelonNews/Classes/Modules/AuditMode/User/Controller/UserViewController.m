//
//  UserViewController.m
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/10/24.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "UserViewController.h"
#import "UserHeaderView.h"
#import "FeedbackViewController.h"
#import "MessageViewController.h"
#import "ReadHistoryViewController.h"
#import "InformationTableViewController.h"
#import "UserModel.h"
#import "WechatApi.h"
#import "PersonalViewController.h"
#import "ConversationListViewController.h"

@interface UserViewController ()<WechatAPIDelegate>

@property (strong, nonatomic) NSMutableArray *rowArray;
@property (strong, nonatomic) NSMutableArray *iconArray;
@property (strong, nonatomic) UserHeaderView *headerView;
@property (assign, nonatomic) NSInteger changeHeight;

@end

@implementation UserViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([UserManager currentUser].isLogin.integerValue) {
        [self userIsLogin:YES];
    } else {
        [self userIsLogin:NO];

    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //用于测试第三方登录，正常版本注释掉
//    [[UserManager currentUser] setIsLogin:@"0"];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"登录推荐更准确";
    _changeHeight = 0;
    
    self.rowArray = @[@[@"我的动态", @"聊天列表"],@[@"阅读历史", @"我的消息", @"我要反馈"]].mutableCopy;
    self.iconArray =@[@[@"my_dyn",@"my_ chat"], @[@"my_read_his", @"my_news", @"my_feedback"]].mutableCopy;

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.contentInset = UIEdgeInsetsMake(kImgHeight+_changeHeight, 0, 0, 0);
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, adaptHeight1334(20))];
    self.tableView.sectionFooterHeight = adaptHeight1334(20);
    self.tableView.sectionHeaderHeight = 0;
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    self.headerView = [[UserHeaderView alloc] initWithFrame:CGRectMake(0, -kImgHeight-_changeHeight, kScreenWidth, kImgHeight+_changeHeight)];
    @kWeakObj(self)
    self.headerView.buttonBlock = ^(NSInteger index) {
        switch (index) {
            case 0:{
                
                PersonalViewController *personalVC = [[PersonalViewController alloc] initWithStyle:UITableViewStylePlain];
                personalVC.isMyself = YES;
                [selfWeak showViewController:personalVC sender:nil];
                
                break;
            }
            case 1:{
                
                [[WechatApi sharedInstance] login];
                [WechatApi sharedInstance].delegate = selfWeak;

                break;
            }
            case 2:{
                
                [[TencentQQApi sharedInstance] loginCallback:^(int code, NSString * _Nullable description) {
                    
                    NSData *jsonData = [description dataUsingEncoding:NSUTF8StringEncoding];
                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
                    
                    UserModel *model = [UserModel mj_objectWithKeyValues: [UserManager currentUser].userInfo];
                    if (model == nil) {
                        model = [UserModel new];
                    }
                    model.nickName = dic[@"nickname"];
                    model.avatar = dic[@"figureurl_qq_2"];
                    model.sex = dic[@"gender"];
                    [selfWeak loginSuccess:model];

                }];
                break;
            }
        }
    };
    [self.tableView addSubview:self.headerView];
    
}

//登录成功后操作
- (void)loginSuccess:(UserModel *)model
{
    if (model.nickName == nil) {
        model.nickName = [NSString stringWithFormat:@"西瓜用户%d", 10000 +  (arc4random() % 80001)];
    }
    [[UserManager currentUser] setUserInfo:[model mj_JSONString]];
    [[UserManager currentUser] setIsLogin:@"1"];
    
    [self userIsLogin:YES];
    [[RongCloudManager sharedManager] loginRongCloud];
}

#pragma mark - WechatAPIDelegate

/**
 *  调用微信API成功时的回调
 *
 *  @param response 返回值
 */
- (void)success:(NSDictionary *_Nonnull)response
{
    UserModel *model = [UserModel mj_objectWithKeyValues:[UserManager currentUser].userInfo];
    if (model == nil) {
        model = [UserModel new];
    }
    model.nickName = response[@"nickname"];
    model.avatar = response[@"headimgurl"];
    model.sex = [response[@"sex"] integerValue] == 1 ? @"男" : @"女";
    [self loginSuccess:model];
}

/**
 *  调用微信API失败时的回调
 *
 *  @param error 错误信息
 */
- (void)failure:(NSError *_Nonnull)error
{
    
}

//修改布局
- (void)userIsLogin:(BOOL)isLogin
{
    _changeHeight = isLogin ? 64 : 0;
    self.navigationController.navigationBar.hidden = isLogin;
    [self.headerView setUserIsLogin:isLogin];
    self.headerView.height = kImgHeight + _changeHeight;
    self.headerView.y = -kImgHeight-_changeHeight;
    self.tableView.contentInset = UIEdgeInsetsMake(kImgHeight+64, 0, 0, 0);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    WNLog(@"%f",offsetY);
    CGFloat offsetH = kImgHeight+_changeHeight + offsetY;
    if (offsetH < 0) {//下拉偏移为负数
        CGRect frame = self.headerView.frame;
        frame.size.height = kImgHeight+_changeHeight - offsetH;//下拉后图片的高度应变大
        frame.origin.y = -kImgHeight-_changeHeight + offsetH;// 下边界是一定的  高度变大了  起始的Y应该上移
        self.headerView.frame = frame;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.rowArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.rowArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.imageView.image = [UIImage imageNamed:self.iconArray[indexPath.section][indexPath.row]];
    cell.textLabel.text = self.rowArray[indexPath.section][indexPath.row];
    
    // Configure the cell...
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return adaptHeight1334(96);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if ([UserManager currentUser].isLogin.integerValue == 0) {
            [MBProgressHUD showError:@"请登录后操作"];
            return;
        }
        if (indexPath.row == 0) {
            PersonalViewController *personalVC = [[PersonalViewController alloc] initWithStyle:UITableViewStylePlain];
            personalVC.isMyself = YES;
            [self showViewController:personalVC sender:nil];
            
        } else {
            
            ConversationListViewController *vc = [ConversationListViewController new];
            [self showViewController:vc sender:nil];
        }
        
        return;
    }
    switch (indexPath.row) {
        case 0:{
            
            [self showViewController:[ReadHistoryViewController new] sender:nil];
            break;
        }
        case 1:{
            [self showViewController:[MessageViewController new] sender:nil];

            break;
        }
        case 2:{
            
            [self showViewController:[FeedbackViewController new] sender:nil];
            
            break;
        }
    }
}

@end
