//
//  DetailViewController.m
//  MakeMoney
//
//  Created by yedexiong on 16/10/27.
//  Copyright © 2016年 yoke121. All rights reserved.
//

#import "DetailViewController.h"
#import "HomeHotCell.h"
#import "DetailsecondCell.h"
#import "DetailJopDesCell.h"
#import "HotModel.h"
#import "DetailCompanyCell.h"
#import "DetailTopCell.h"

@interface DetailViewController ()<UITableViewDelegate,UITableViewDataSource>


@property(nonatomic,strong) UITableView *tableView;

@property(nonatomic,strong) UIView *sectionHead;

@property(nonatomic,strong) NSMutableArray *dataSource;


@end

@implementation DetailViewController


#pragma mark -view life
- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setupUI];
    
    [self loadData];

}

#pragma mark -private
-(void)setupUI
{
    self.title = @"兼职详情";
    [self.view addSubview:self.tableView];
    
}

-(void)loadData
{
    NSString *paramValue = @"jingxuan";
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:paramValue ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:jsonPath];
    id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    self.dataSource = [HotModel mj_objectArrayWithKeyValuesArray:result];
}
#pragma mark - UITableViewDataSource/delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 3)
        return 4;
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.section) {
        case 0:
        {
            DetailTopCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailTopCell"];
            cell.model = self.hotmodel;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            
        }
        break;
        case 1:
        {
            DetailsecondCell *cell = [DetailsecondCell cellWithTableView:tableView];
            cell.model = self.hotmodel;
            return cell;
        }
            break;
        case 2:
        {
            DetailJopDesCell *cell = [DetailJopDesCell cellWithTableView:tableView];
            cell.model = self.hotmodel;
            return cell;
        }
            break;
        case 3:
        {
            if(indexPath.row == 0){
                UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
                cell.textLabel.text = @"推荐职位";
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
            HomeHotCell *cell = [HomeHotCell cellWithTableView:tableView];
            int value = -1;
            for (int i=0; i<indexPath.row; i++) {
                 value += (arc4random() % 19 +1);
            }
            cell.model = self.dataSource[value];
            return cell;
        }
            break;
        default:
        return nil;
        break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 3 && indexPath.row != 0) {
        DetailViewController *detail = [[DetailViewController alloc] init];
        detail.hotmodel = self.dataSource[indexPath.row];
        [self.navigationController pushViewController:detail animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.section) {
        case 0:
        {
            return 68;
        }
            break;
        case 1:
        {
             return 200;
        }
            break;
        case 2:
        {
            return  self.hotmodel.jopDesCellHeight;
        }
            break;
        case 3:
        {
            return 60;
        }
            break;
        default:
            return 0;
            break;
    }
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section > 0) {
        return 15;
    }else{
        return 0;
    }
}


#pragma mark - getter
-(UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:@"DetailTopCell" bundle:nil] forCellReuseIdentifier:@"DetailTopCell"];
        _tableView.dataSource =self;
        _tableView.delegate = self;
    }
    return _tableView;
}

-(UIView *)sectionHead
{
    if (_sectionHead == nil) {
        _sectionHead = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 15)];
        _sectionHead.backgroundColor = UIColorFromRGBA(0xf3f3f3, 1);
    }
   return  _sectionHead;
}


@end
