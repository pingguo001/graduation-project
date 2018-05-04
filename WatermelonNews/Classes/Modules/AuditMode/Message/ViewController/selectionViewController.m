//
//  selectionViewController.m
//  WaterMelonHeadline
//
//  Created by 王海玉 on 2017/9/29.
//  Copyright © 2017年 yoke121. All rights reserved.
//

#import "selectionViewController.h"
#import "HotModel.h"
#import "DetailViewController.h"
#import "selectionCellView.h"

@interface selectionViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSMutableArray *selectionDate;

@end

@implementation selectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGBA(0xF5F5F5, 1);
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.title = @"精选推荐";
    
    _tableView=[[UITableView alloc]initWithFrame:self.view.bounds
                                           style:UITableViewStylePlain];
    
    _tableView.dataSource = self;
    _tableView.delegate   = self;
    _tableView.rowHeight  = 180;
    [self.tableView registerNib:[UINib nibWithNibName:@"selectionCellView" bundle:nil] forCellReuseIdentifier:@"selectionCellView"];
    
    [self requsetHotData];
    
    [self.view addSubview:_tableView];

    // Do any additional setup after loading the view.
}

//加载下方职位列表数据
- (void)requsetHotData
{
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"jingxuantuijian"
                                                         ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:jsonPath];
    id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    self.selectionDate = [HotModel mj_objectArrayWithKeyValuesArray:result];
    [self.tableView reloadData];
}

- (NSInteger)getTimeAdd {
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval sinceTime = 1507515953;
    NSInteger i = (currentTime - sinceTime)/(60*60*24);
    return i;
}

- (NSString *)getTime:(NSInteger)row {
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    currentTime -= (60*60*24)*row ;
    NSDate * currentDate = [[NSDate alloc] initWithTimeIntervalSince1970:currentTime];
    NSDateFormatter * df = [[NSDateFormatter alloc] init ];
    [df setDateFormat:@"MM-dd"];
    NSString * na = [df stringFromDate:currentDate];
    return na;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.selectionDate.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectionCellView *cell = [tableView dequeueReusableCellWithIdentifier:@"selectionCellView"];
    cell.model = self.selectionDate[indexPath.row];

    cell.timeLable.text = [self getTime:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewController *detail = [[DetailViewController alloc] init];
    detail.hotmodel = self.selectionDate[indexPath.row];
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
