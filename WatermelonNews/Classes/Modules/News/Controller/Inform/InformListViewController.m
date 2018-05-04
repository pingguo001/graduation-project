//
//  InformListViewController.m
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/10/17.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "InformListViewController.h"
#import "InformCell.h"
#import "InformResultViewController.h"

@interface InformListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray *infoArray;
@property (strong, nonatomic) NSMutableArray *hiddenArray;
@property (strong, nonatomic) UIButton *submitButton;
@property (strong, nonatomic) UITableView *tableView;

@end

@implementation InformListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubViews];

    self.title = @"投诉";
    
    self.infoArray = [@"广告，标题夸张，与事实不符，内容质量差，重复旧闻，低俗色情，违法犯罪，疑似抄袭，其他原因" componentsSeparatedByString:@"，"].mutableCopy;
    self.hiddenArray = [NSMutableArray array];
    [self.infoArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.hiddenArray addObject:@"1"];
    }];
    
    [self.tableView registerClass:[InformCell class] forCellReuseIdentifier:InformCellID];
    self.tableView.tableFooterView = [[UIView alloc] init];
    
}

- (void)setupSubViews
{
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 -49) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    self.submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.submitButton.backgroundColor = [UIColor lightGrayColor];
    self.submitButton.userInteractionEnabled = NO;
    [self.submitButton setTitle:@"提交" forState:UIControlStateNormal];
    self.submitButton.frame = CGRectMake(0, kScreenHeight - 49, kScreenWidth, 49);
    [self.submitButton addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.submitButton];
}

- (void)submitAction
{
    [self showViewController:[InformResultViewController new] sender:nil];
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
    return self.infoArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    InformCell *cell = [tableView dequeueReusableCellWithIdentifier:InformCellID forIndexPath:indexPath];
    cell.titleLabel.text = self.infoArray[indexPath.row];
    cell.iconImageView.hidden = [self.hiddenArray[indexPath.row] boolValue];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.hiddenArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        self.hiddenArray[idx] = @"1";
    }];
    self.hiddenArray[indexPath.row] = @"0";
    [self.tableView reloadData];
    self.submitButton.backgroundColor = [UIColor colorWithString:COLOR39AF34];
    self.submitButton.userInteractionEnabled = YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return adaptHeight1334(90);
}

@end
