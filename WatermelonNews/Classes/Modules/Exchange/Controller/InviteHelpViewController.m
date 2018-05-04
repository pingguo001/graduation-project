//
//  InviteHelpViewController.m
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/11/29.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "InviteHelpViewController.h"
#import "InviteHelpCell.h"

@interface InviteHelpViewController ()

@property (strong, nonatomic) NSMutableArray *dataArray;

@end

@implementation InviteHelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[InviteHelpCell class] forCellReuseIdentifier:InviteHelpCellID];
    self.tableView.pagingEnabled = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.dataArray = @[@"invitation_pic1.jpg", @"invitation_pic2.jpg", @"invitation_pic3.jpg", @"invitation_pic4.jpg"].mutableCopy;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:255 green:255 blue:255 alpha: 0] size:CGSizeMake(SCREEN_WIDTH, 64)] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    if (@available(iOS 11.0, *)) {
        
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
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
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    InviteHelpCell *cell = [tableView dequeueReusableCellWithIdentifier:InviteHelpCellID forIndexPath:indexPath];
    [cell configModelData:self.dataArray[indexPath.row] indexPath:indexPath];
    cell.inviteAction = ^{
        [self.navigationController popViewControllerAnimated:YES];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kScreenHeight;
}

@end
