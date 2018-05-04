//
//  ExchangeViewController.m
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/11/25.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "ExchangeViewController.h"
#import "ExchangeCell.h"
#import "FeedbackViewController.h"
#import "InviteHelpViewController.h"
#import "DoPaymentApi.h"
#import "ExchangeHistoryViewController.h"
#import "ExchangeStatusViewController.h"
#import "StatusModel.h"
#import "ExchangeNotesViewController.h"

@interface ExchangeViewController ()<UITableViewDelegate, UITableViewDataSource, ResponseDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) NSMutableArray *iconArray;

@property (strong, nonatomic) DoPaymentApi *doPaymentApi;

@property (strong, nonatomic) ExchangeStatusViewController *statusVC;
@property (strong, nonatomic) AlertTextField *userName;
@property (strong, nonatomic) AlertTextField *account;

@end

@implementation ExchangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViews];
    
    
    self.dataArray = @[@[@"50元", @"100元"],@[@"提现历史", @"提现注意事项"], @[@"如何挣钱", @"用户反馈"].mutableCopy].mutableCopy;
    self.iconArray = @[@[@"", @""],@[@"user_history", @"user_careful"], @[@"user_money", @"user_feedback"].mutableCopy].mutableCopy;
    if ([UserManager currentUser].sensitiveArea.integerValue == 1) {
        [self.dataArray.lastObject removeObjectAtIndex:0];
        [self.iconArray.lastObject removeObjectAtIndex:0];
    }
    
    _doPaymentApi = [DoPaymentApi new];
    _doPaymentApi.delegate = self;
    
}

- (void)setupViews
{
    //去除上下导航半透明效果（不设置会渗透tableView内容）
    self.navigationController.navigationBar.translucent = NO;
    self.tabBarController.tabBar.translucent = NO;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kTabBarHeight - kNaviBarHeight) style:UITableViewStyleGrouped];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.tableView registerClass:[ExchangeCell class] forCellReuseIdentifier:ExchangeCellID];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.sectionFooterHeight = adaptHeight1334(20);
    self.tableView.tableFooterView = [UIView new];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, adaptHeight1334(20))];
    
}

#pragma mark - ResponseDelegate
- (void)request:(NetworkRequest *)request success:(id)response
{
    if ([request.url containsString:doPaymentUrl]) {
        
        [[UserManager currentUser] setMoney:[NSString stringWithFormat:@"%.2f", [response[@"money"] floatValue]]];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"check" object:nil];
        
    }
}

- (void)request:(NetworkRequest *)request failure:(NSError *)error
{
    [AlertControllerTool alertControllerWithViewController:self title:@"提示\n" message:@"余额不足，快去赚钱吧！" cancleTitle:@"" sureTitle:@"我知道了" cancleAction:nil sureAction:^{
        
    }];
}

#pragma mark - TableViewDelegateAndDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        ExchangeCell *cell = [tableView dequeueReusableCellWithIdentifier:ExchangeCellID forIndexPath:indexPath];
        cell.textLabel.text = @"提现到支付宝";
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont systemFontOfSize:adaptFontSize(30)];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        cell.moneyLabel.text = self.dataArray[indexPath.section][indexPath.row];
        cell.moneyLabel.textColor = [UIColor colorWithString:COLOR39AF34];
        
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.textLabel.text = self.dataArray[indexPath.section][indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:adaptFontSize(30)];
        cell.imageView.image = [UIImage imageNamed:self.iconArray[indexPath.section][indexPath.row]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return adaptHeight1334(96);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0:{
            switch (indexPath.row) {
                case 0: [self exchangeWithMoney:@"50"]; break;
                case 1: [self exchangeWithMoney:@"100"]; break;
            }
            break;
        }
        case 1:{
            switch (indexPath.row) {
                case 0: [self showViewController:[ExchangeHistoryViewController new] sender:nil]; break;
                case 1: [self showViewController:[[ExchangeNotesViewController alloc] initWithStyle:UITableViewStyleGrouped] sender:nil]; break;
            }
            break;
        }
        case 2:{
            if ([UserManager currentUser].sensitiveArea.integerValue == 1) {
                [self showViewController:[FeedbackViewController new] sender:nil]; break;
            }
            switch (indexPath.row) {
                case 0: [self showViewController:[InviteHelpViewController new] sender:nil]; break;
                case 1: [self showViewController:[FeedbackViewController new] sender:nil]; break;
            }
            break;
        }
    }
}

- (void)exchangeWithMoney:(NSString *)money
{
    if ([UserManager currentUser].money.floatValue < money.floatValue) {
        
        [AlertControllerTool alertControllerWithViewController:self title:@"提示\n" message:@"余额不足，快去赚钱吧！" cancleTitle:@"" sureTitle:@"我知道了" cancleAction:nil sureAction:^{

        }];
        
    } else {
        
        [self exchangeActionWithMoney:money];
        
    }
}

/**
 包装Message信息
 
 @return message数据源
 */
- (NSMutableArray *)dealWithMessageInfoWithMoney:(NSString *)money
{
    
    NSMutableArray *dataArray = @[@{@"\n提现类型：" : @"支付宝"},
                                  @{@"提现账号：" : _account.textField.text},
                                  @{@"姓名：" : _userName.textField.text},
                                  @{@"兑换余额：" : [NSString stringWithFormat:@"%@元", money]}].mutableCopy;
    NSMutableArray *messageArray = [NSMutableArray array];
    for (NSDictionary *dic in dataArray) {
        
        NSString * contentStr = [dic.allKeys.firstObject stringByAppendingString:dic.allValues.firstObject];
        [messageArray addObject:contentStr];
    }
    return messageArray;
}

- (void)exchangeActionWithMoney:(NSString *)money;
{
    [AlertControllerTool alertControllerWithTitle:@"提现支付宝" userNameTextField:^(AlertTextField *alert) {
        
        _userName = alert;
        alert.textField.placeholder = @"真实姓名";
        alert.showLabel.text = @"请输入正确的支付宝真实姓名";
        
        
    } accountTextField:^(AlertTextField *alert) {
        
        alert.textField.placeholder = @"支付宝账号";
        alert.showLabel.text = @"请输入正确的支付宝账号";
        _account = alert;
        
        
    } cancleAction:nil sureAction:^(YJAlertViewController *alert){
        
        if (_userName.textField.text.length == 0) {
            
            _userName.labelHidden = NO;
            
        } else {
            
            _userName.labelHidden = YES;
            
        }
        
        if (_account.textField.text.length == 0) {
            
            _account.labelHidden = NO;
        } else {
            
            _account.labelHidden = YES;
        }
        if (_userName.textField.text.length != 0 && _account.textField.text.length != 0) {
            
            [alert dismiss];

            NSMutableArray *message = [self dealWithMessageInfoWithMoney:money];
            [AlertControllerTool alertControllerWithViewController:self title:@"请确认兑换信息" message:[message componentsJoinedByString:@"\n"] cancleTitle:@"取消" sureTitle:@"确定" cancleAction:^{
    
            } sureAction:^{
                
                
                _doPaymentApi.realName = _userName.textField.text;
                _doPaymentApi.type = @"2";
                _doPaymentApi.money = money;
                _doPaymentApi.account = _account.textField.text;
                
                [_doPaymentApi call];
                
            }];
        }
        
    }];
}

- (ExchangeStatusViewController *)statusVC
{
    if (!_statusVC) {
        _statusVC = [[ExchangeStatusViewController alloc] initWithStyle:UITableViewStyleGrouped];
    }
    return _statusVC;
}

@end
