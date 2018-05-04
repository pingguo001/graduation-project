//
//  ExchangeNotesViewController.m
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/12/1.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "ExchangeNotesViewController.h"
#import "ExchangeNotesCell.h"

@interface ExchangeNotesViewController ()

@property (strong, nonatomic) NSArray *titleArray;
@property (strong, nonatomic) NSArray *contentArray;

@end

@implementation ExchangeNotesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"提现注意事项";
    self.titleArray = @[@"原因", @"我该怎么办"];
    self.contentArray = @[@"您的支付宝账号没有实名认证\n (支付宝公司规定：没有实名制认证的账号，无法正常接收转账）", @"登录支付宝网站，进行实名认证，然后再提交支付宝提现"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.tableView registerClass:[ExchangeNotesCell class] forCellReuseIdentifier:ExchangeNotesCellID];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, adaptHeight1334(20))];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.textLabel.text = @"支付宝提现失败";
        cell.textLabel.textColor = [UIColor colorWithString:COLORFF5A5D];
        cell.textLabel.font = [UIFont systemFontOfSize:adaptFontSize(32)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        
        ExchangeNotesCell *cell = [tableView dequeueReusableCellWithIdentifier:ExchangeNotesCellID forIndexPath:indexPath];
        cell.titleLabel.text = self.titleArray[indexPath.row-1];
        cell.contentLabel.text = self.contentArray[indexPath.row-1];
        cell.iconImageView.image = [UIImage imageNamed:indexPath.row == 1 ? @"" : @"exchange_bg_attention"];
        [cell configModelData:@"" indexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return UITableViewAutomaticDimension;
    } else {
        return [tableView fd_heightForCellWithIdentifier:ExchangeNotesCellID configuration:^(ExchangeNotesCell *cell) {
            cell.titleLabel.text = self.titleArray[indexPath.row-1];
            cell.contentLabel.text = self.contentArray[indexPath.row-1];
            cell.iconImageView.image = [UIImage imageNamed:indexPath.row == 1 ? @"" : @"exchange_bg_attention"];
            [cell configModelData:@"" indexPath:indexPath];
        }];
    }
}

@end
