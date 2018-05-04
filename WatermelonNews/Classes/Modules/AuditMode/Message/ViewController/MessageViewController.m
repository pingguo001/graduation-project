//
//  MessageViewController.m
//  WaterMelonHeadline
//
//  Created by 王海玉 on 2017/9/29.
//  Copyright © 2017年 yoke121. All rights reserved.
//

#import "MessageViewController.h"
#import "selectionViewController.h"
#import "TableViewCell.h"
#import "NullViewController.h"

@interface MessageViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UITableView *tableView;

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息";
    [self.tableView registerNib:[UINib nibWithNibName:@"TableViewCell" bundle:nil] forCellReuseIdentifier:@"TableViewCell"];
    [self setupUI];
    // Do any additional setup after loading the view.
}
-(void)setupUI
{
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewCell" forIndexPath:indexPath];
    switch (indexPath.row) {
        case 0:
            cell.messagelabel.text = @"系统消息";
            cell.message.image = [UIImage imageNamed:@"news_system"];
            break;
        case 1:
            cell.messagelabel.text = @"客服消息";
            cell.message.image = [UIImage imageNamed:@"news_customer"];
            break;
        case 2:
            cell.messagelabel.text = @"精选消息";
            cell.message.image = [UIImage imageNamed:@"news_collection"];
            cell.describeMessage.text = @"点击查看详情";
            break;
        case 3:
            cell.messagelabel.text = @"附近消息";
            cell.message.image = [UIImage imageNamed:@"news_add"];
            break;
        default:
            break;
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    selectionViewController *sel = [[selectionViewController alloc]init];
    NullViewController *nul = [[NullViewController alloc]init];
    switch (indexPath.row) {
        case 0:
            nul.title = @"系统消息";
            [self.navigationController pushViewController:nul animated:YES];
            break;
        case 1:
            nul.title = @"客服消息";
            [self.navigationController pushViewController:nul animated:YES];
            break;
        case 2:
            [self.navigationController pushViewController:sel animated:YES];
            break;
        case 3:
            nul.title = @"附近消息";
            [self.navigationController pushViewController:nul animated:YES];
            break;
        default:
            break;
    }
}

-(UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, kScreenHeight-20) style:UITableViewStylePlain];
        _tableView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.rowHeight = 66;
        _tableView.dataSource =self;
        _tableView.delegate = self;
    }
    return _tableView;
}

@end
