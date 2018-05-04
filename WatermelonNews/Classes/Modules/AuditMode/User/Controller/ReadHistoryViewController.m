//
//  ReadHistoryViewController.m
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/10/24.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "ReadHistoryViewController.h"
#import "ArticleDatabase.h"
#import "SimpleNewsCell.h"
#import "MultiNewsCell.h"
#import "VideoNewsCell.h"
#import "NewsDetailViewController.h"

@interface ReadHistoryViewController ()

@property (strong, nonatomic) NSMutableArray *dataArray;

@end

@implementation ReadHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataArray = [[ArticleDatabase sharedManager] queryDidReadAritcle].mutableCopy;
    WNLog(@"%@",self.dataArray);
    self.title = @"阅读历史";
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[SimpleNewsCell class] forCellReuseIdentifier:SimpleNewsCellID];
    [self.tableView registerClass:[MultiNewsCell class] forCellReuseIdentifier:MultiNewsCellID];
    [self.tableView registerClass:[VideoNewsCell class] forCellReuseIdentifier:VideoNewsCellID];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc ] initWithTitle:@"清空" style:UIBarButtonItemStylePlain target:self action:@selector(clearAction)];
    //上拉
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
    }];
    [self updateTableViewData];

}

- (void)clearAction
{
    [AlertControllerTool alertControllerWithViewController:self title:@"" message:@"确定清空记录吗？" cancleTitle:@"取消" sureTitle:@"确定" cancleAction:^{
        
    } sureAction:^{
        
        [[ArticleDatabase sharedManager] deleteArticleInfoFromDisk];
        [self.dataArray removeAllObjects];
        [self updateTableViewData];
        
    }];
    
}

- (void)updateTableViewData
{
    [self.tableView reloadData];
    [self.tableView.mj_footer endRefreshingWithNoMoreData];
    [(MJRefreshAutoNormalFooter *)self.tableView.mj_footer setTitle:@"没有更多内容了" forState:MJRefreshStateNoMoreData];

    if (self.dataArray.count == 10) {
        /** 设置state状态下的文字 */
        [(MJRefreshAutoNormalFooter *)self.tableView.mj_footer setTitle:@"系统为您保留最近十条阅读记录～" forState:MJRefreshStateNoMoreData];
    }
    if (self.dataArray.count == 0) {
        
        [(MJRefreshAutoNormalFooter *)self.tableView.mj_footer setTitle:@"您还没有新的阅读~" forState:MJRefreshStateNoMoreData];
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
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NewsArticleModel *model = [NewsArticleModel mj_objectWithKeyValues:self.dataArray[indexPath.row]];
    
    MultiNewsCell *cell;
    if (model.type.integerValue == 2) {
        
        cell = [tableView dequeueReusableCellWithIdentifier:VideoNewsCellID forIndexPath:indexPath];
        cell.hidden = YES;
        return cell;
    } else {
        
        cell.hidden = NO;
        cell = [tableView dequeueReusableCellWithIdentifier:model.cover.count > 1 ? MultiNewsCellID : SimpleNewsCellID forIndexPath:indexPath];
    }
    [cell configModelData:model indexPath:indexPath];
    [cell setContentDidRed:NO];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArray.count == 0) {
        return;
    }
    NewsArticleModel *model = [NewsArticleModel mj_objectWithKeyValues:self.dataArray[indexPath.row]];
    model.isRead = YES;
    
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    NewsDetailViewController *detailVC = [NewsDetailViewController new];
    detailVC.model = model;
    [self showViewController:detailVC sender:nil];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsArticleModel *model = [NewsArticleModel mj_objectWithKeyValues:self.dataArray[indexPath.row]];
    
    if (model.type.integerValue == 2) {
        return 0;
        return [tableView fd_heightForCellWithIdentifier: VideoNewsCellID cacheByKey:model.articleId configuration:^(VideoNewsCell *cell) {
            
            [cell configModelData:model indexPath:indexPath];
        }];
    }
    return [tableView fd_heightForCellWithIdentifier:model.cover.count > 1 ? MultiNewsCellID : SimpleNewsCellID cacheByKey:model.articleId configuration:^(MultiNewsCell *cell) {
        
        [cell configModelData:model indexPath:indexPath];
        
    }];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
