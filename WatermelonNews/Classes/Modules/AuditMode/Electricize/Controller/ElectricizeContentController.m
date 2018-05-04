//
//  ElectricizeContentController.m
//  MakeMoney
//
//  Created by yedexiong on 2017/2/9.
//  Copyright © 2017年 yoke121. All rights reserved.
//

#import "ElectricizeContentController.h"
#import "HttpRequest.h"
#import "FMListModel.h"
#import "FMListCell.h"
#import "SpecialDetailViewController.h"

static NSString * const CellIdentifier = @"FMListCell";
static NSInteger const  KCellHeight = 103;


@interface ElectricizeContentController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,assign) ChannelType type;

@property(nonatomic,strong) NSArray *dataSource;

@property(nonatomic,strong) UITableView *tableView;

@property(nonatomic,copy)NSString *channelValue;

@end

@implementation ElectricizeContentController

-(instancetype)initWithChannelType:(ChannelType)type
{
    if (self = [super init]) {
        self.type = type;
        
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self loadData];
   
}

-(void)loadData
{
    switch (self.type) {
        case ChannelTypeFinance:
            _channelValue = @"finance";
            break;
        case ChannelTypeChuanYe:
            _channelValue = @"internet";
            break;
        case ChannelTypeJingGuan:
            _channelValue = @"career";
            break;
            
        default:
            break;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"list" forKey:@"action"];
    [params setValue:_channelValue forKey:@"channel"];
    WS(weakSelf);
    [MYProgressHUD showStatus:@"正在加载..."];
    [HttpRequest get:API_FM params:params success:^(id responseObj) {
        [MYProgressHUD dismiss];
        weakSelf.dataSource = [FMListModel mj_objectArrayWithKeyValuesArray:responseObj];
        [weakSelf.tableView reloadData];
        
    } failure:^(NSError *error) {
        [MYProgressHUD dismiss];
    }];
}

#pragma mark - UITableViewDataSource/delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FMListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.model = self.dataSource[indexPath.row];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SpecialDetailViewController *detail = [[SpecialDetailViewController alloc] init];
    //拼装专辑详情请求参数
    FMListModel *model = self.dataSource[indexPath.row];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.channelValue forKey:@"channel"];
    [params setObject:model.Id forKey:@"id"];
    [params setObject:@4 forKey:@"page"];
     detail.params = params;
    [self.navigationController pushViewController:detail animated:YES];
}


#pragma mark - getter
-(UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:CellIdentifier bundle:nil] forCellReuseIdentifier:CellIdentifier];
        _tableView.rowHeight = KCellHeight;
         _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.dataSource =self;
        _tableView.delegate = self;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 149, 0);
    }
    return _tableView;
}



@end
