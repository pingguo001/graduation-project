//
//  JobViewController.m
//  WaterMelonHeadline
//
//  Created by 王海玉 on 2017/9/29.
//  Copyright © 2017年 yoke121. All rights reserved.
//

#import "JobViewController.h"
#import "buttonScrollView.h"
#import "DetailViewController.h"
#import "HomeHotCell.h"
#import "HotModel.h"
#import "TabHeaderView.h"
#import "NewsCategoryModel.h"

static NSString * const CellIdentifier = @"HomeHotCell";

@interface JobViewController ()<UIScrollViewDelegate,
UITableViewDelegate,UITableViewDataSource,TabHeaderViewDelegate>

@property (strong, nonatomic) TabHeaderView *navigationTabView;
@property(nonatomic,strong) buttonScrollView *scrollButton;
@property(nonatomic,strong) UIScrollView *backScrollView;

@property(nonatomic,strong) NSMutableArray *dataSource;
@property (strong, nonatomic) NSMutableArray *titleArray;

@end

@implementation JobViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    
    [self loadData:0];
    // Do any additional setup after loading the view.
}

- (void)initUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.titleArray = [NSMutableArray array];
    NSArray *array = @[@"传单分发",@"餐饮帮工",
                                     @"家教老师",@"校园代理",
                                     @"服务小生",@"导购专员",
                                     @"话务客服",@"其他兼职"].mutableCopy;
    for (NSString *str in array) {
        
        NewsCategoryModel *model = [NewsCategoryModel new];
        model.name = str;
        [self.titleArray addObject:model];
    }
    [self.navigationController.navigationBar addSubview:self.navigationTabView];
    
    CGRect frame = CGRectMake(0,
                              20 + 50,
                              kScreenWidth,
                              kScreenHeight - 20 - 50);
    self.backScrollView = [[UIScrollView alloc] initWithFrame:frame];
    self.backScrollView.contentSize = CGSizeMake(kScreenWidth * self.titleArray.count,
                                                 kScreenHeight - 20 - 50 - 49);
    self.backScrollView.pagingEnabled = YES;
    self.backScrollView.delegate = self;
    self.backScrollView.bounces = NO;
    [self.view addSubview:self.backScrollView];
    
    for (int i = 0; i < self.titleArray.count; i++) {
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(i * kScreenWidth, 0,kScreenWidth,kScreenHeight - 20 - 50 - 49)];
        tableView.rowHeight = 89;
        tableView.tag = 200 + i;
        tableView.delegate = self;
        tableView.dataSource = self;
       [tableView registerNib:[UINib nibWithNibName:@"HomeHotCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
        [self.backScrollView addSubview:tableView];
    }
    __weak typeof(self) weakSelf = self;
    //点击按钮切换tableview
    self.scrollButton.passButton = ^(NSInteger index){
        weakSelf.backScrollView.contentOffset = CGPointMake(kScreenWidth * index, 0);
        [weakSelf loadData:index];
    };
    
}

-(void)loadData:(NSInteger)species
{
    NSString *paramValue;
    switch (species) {
        case 0:
        {
            paramValue = @"doumi_canyingong";
        }
            break;
        case 1:
        {
            paramValue = @"doumi_chuandan";
        }
            break;
        case 2:
        {
            paramValue = @"doumi_daogou";
        }
            break;
        case 3:
        {
            paramValue = @"doumi_fuwuyuan";
        }
            break;
        case 4:
        {
            paramValue = @"doumi_jiajiao";
        }
            break;
        case 5:
        {
            paramValue = @"doumi_kefu";
        }
            break;
        case 6:
        {
            paramValue = @"doumi_xiaoyuandaili";
        }
            break;
        case 7:
        {
            paramValue = @"doumi_qita";
        }
            break;
        default:
            break;
    }
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:paramValue ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:jsonPath];
    id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    [[self.view viewWithTag:species +200] reloadData];
    self.dataSource = [HotModel mj_objectArrayWithKeyValuesArray:result];
}

#pragma mark - TabHeaderViewDelegate

- (void)didSelectTabIndex:(NSInteger)index
{
    [self.backScrollView setContentOffset:CGPointMake(index * kScreenWidth, 0) animated:YES];
    [self loadData:index];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeHotCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.model = self.dataSource[indexPath.row];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewController *detail = [[DetailViewController alloc] init];
    detail.hotmodel = self.dataSource[indexPath.row];
    [self.navigationController pushViewController:detail animated:YES];
}

//底层scrollview滑动代理
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([scrollView isMemberOfClass:[UITableView class]]) {
        return ;
    }
    NSInteger index = scrollView.contentOffset.x/ kScreenWidth;
    [self.navigationTabView selectTabIndex:index];

}

- (TabHeaderView *)navigationTabView
{
    if (!_navigationTabView) {
        
        _navigationTabView = [[TabHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
        [_navigationTabView cofigureDelegate:self dataArray:self.titleArray withMultiple:1.8];
    }
    return _navigationTabView;
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
