//
//  ExchangeStatusViewController.m
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/11/29.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "ExchangeStatusViewController.h"
#import "StatusProcessCell.h"
#import "ExchangeFooterView.h"
#import "ExchangeHistoryViewController.h"
#import "FeedbackViewController.h"
#import "InviteAlertView.h"
#import "ShareImageTool.h"

@interface ExchangeStatusViewController ()

@property (strong, nonatomic) ExchangeFooterView *footerView;

@end

@implementation ExchangeStatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configTableView];
}

- (void)configTableView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.y = 0;
    self.tableView.height = kScreenHeight;
    
    [self.tableView registerClass:[StatusProcessCell class] forCellReuseIdentifier:StatusProcessCellID];
    
    self.tableView.sectionFooterHeight = 0;
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.01f)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    self.footerView = [[ExchangeFooterView alloc] init];
    self.tableView.tableFooterView = self.footerView;
    
    WS(weakSelf)
    self.footerView.backResult = ^(NSInteger index) {
        
        if (index == 0) {
            ExchangeHistoryViewController *recordVC = [[ExchangeHistoryViewController alloc] initWithStyle:UITableViewStylePlain];
            recordVC.title = @"提现历史记录";
            [weakSelf showViewController:recordVC sender:nil];
            
        } else {
            
            if (self.model.flag.integerValue == 1) {
                
                LinkModel *linkModel = [LinkModel mj_objectWithKeyValues:[UserManager currentUser].arrLinks];
                UIImage *shareImage = [ShareImageTool createSuccessShareImageWithUrl:linkModel.wechatMomentPic isFiftyMoney:self.model.checkMoney.integerValue <= 50 ? YES : NO];
                UIImage *thumbImage = [UIImage imageWithImage:shareImage scaledToSize:CGSizeMake(shareImage.size.width / 5.0, shareImage.size.height / 5.0)];
                [[WechatApi sharedInstance] shareImage:shareImage thumbImage:thumbImage to: WechatSceneTimeline];
                
            } else {
                [weakSelf showViewController:[FeedbackViewController new] sender:nil];
            }
        }
        
    };
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

    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    StatusProcessCell *cell = [self.tableView dequeueReusableCellWithIdentifier:StatusProcessCellID forIndexPath:indexPath];
    [cell configModelData:self.model indexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView fd_heightForCellWithIdentifier:StatusProcessCellID configuration:^(StatusProcessCell *cell) {
        
        [cell configModelData:self.model indexPath:indexPath];
    }];
}

- (void)setModel:(StatusModel *)model
{
    _model = model;
    [self.tableView reloadData];
    [self.footerView configData:model];
}

@end
