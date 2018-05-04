//
//  SpecialDetailViewController.m
//  MakeMoney
//
//  Created by yedexiong on 2017/2/10.
//  Copyright © 2017年 yoke121. All rights reserved.
//

#import "SpecialDetailViewController.h"
#import "HttpRequest.h"
#import "SpecialDeailModel.h"
#import "ContentView.h"
#import "SpecialDetailListCell.h"
#import "SpecialDetailDesCell.h"
#import "MJRefresh.h"
#import "EpisodeModel.h"
#import "PlayManager.h"

static NSString * const CellIdentifier = @"SpecialDetailListCell";
static NSString * const CellDesIdentifier = @"SpecialDetailDesCell";

static NSInteger const  KCellHeight = 58;

@interface SpecialDetailViewController ()<TitleViewDataSource,UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UIScrollView *scrollView;
//节目列表表格
@property(nonatomic,strong) UITableView *listTableView;
//简介表格
@property(nonatomic,strong) UITableView *desTableView;
//标题数据源
@property(nonatomic,strong) NSMutableArray *titles;

//播放数据源
@property(nonatomic,strong) NSMutableArray *dataSource;

@property(nonatomic,strong) TitleView *titleView;
//播放按钮
@property(nonatomic,strong) UIButton *playBtn;

//专辑详情数据模型
@property(nonatomic,strong) SpecialDeailModel *detailModel;

//当前节目总数
@property(nonatomic,assign) NSInteger total;
//上一个播放模型
@property(nonatomic,strong) EpisodeModel *lastPlayModel;

//播放管理类是否持有当前专辑数据
@property(nonatomic,assign) BOOL isCurrentSpecialData;


@end

@implementation SpecialDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
 
    if ([[PlayManager sharManager].currentPlayIndentifier isEqualToString:[self getcurrentPlayIndentifier]]) {
        //播放管理类是持有当前专辑数据，无需网络请求
        self.isCurrentSpecialData = YES;
        [self.dataSource addObjectsFromArray:[PlayManager sharManager].dataSource];
        [self.listTableView reloadData];
        [self refreshTitleData:[PlayManager sharManager].detailModel];
        [self refreshDesTable:[PlayManager sharManager].detailModel];
        self.lastPlayModel = [PlayManager sharManager].currentPlayModel;
        
    }else{
         self.isCurrentSpecialData = NO;
         [self loadDataIsRefresh:YES];
    }
    
    if ([PlayManager sharManager].playStatus == PlayStatusPlaying) {
        //如果当前是正在播放
        self.playBtn.selected = YES;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshListTable:) name:Notify_Play_Change object:nil];
   
}

#pragma mark - setupUI
-(void)setupUI
{
    self.title = @"专辑详情";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.titleView];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.listTableView];
    [self.scrollView addSubview:self.desTableView];
    [self.view addSubview:self.playBtn];
    
    //集成下拉刷新控件
    WS(weakSelf);
    self.listTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (weakSelf.dataSource.count != weakSelf.total) {
            [weakSelf loadDataIsRefresh:NO];
        }else{
            [weakSelf.listTableView.mj_footer endRefreshing];
            [weakSelf.listTableView.mj_footer endRefreshingWithNoMoreData];
        }
        
    }];

}

#pragma mark - loadData
/*
 param isRefresh :YES加载最新数据，NO，加载更多数据
 */
-(void)loadDataIsRefresh:(BOOL)isRefresh
{
    if (isRefresh) {
        
        [MYProgressHUD showStatus:@"正在加载..."];
        [self.params setValue:@1 forKey:@"page"];
    }else{
        [self.params setValue:@(self.detailModel.currentPage+1) forKey:@"page"];
    }
    WS(weakSelf);
    [HttpRequest get:API_FM params:self.params success:^(id responseObj) {
        [MYProgressHUD dismiss];
        SpecialDeailModel *model = [SpecialDeailModel mj_objectWithKeyValues:responseObj];
        if (isRefresh) {
            model.currentPage = 1;
           //刷新标题数据
            [weakSelf refreshTitleData:model];
            //刷新简介数据
            [weakSelf refreshDesTable:model];
            
            [weakSelf.dataSource removeAllObjects];
        }
        //刷新列表数据
        [weakSelf.dataSource addObjectsFromArray:model.episodes];
       
        if (weakSelf.isCurrentSpecialData && isRefresh == NO) {
            [[PlayManager sharManager].dataSource addObjectsFromArray:model.episodes];
        }
        [weakSelf.listTableView reloadData];
       
        if (!isRefresh) {
            //记录专辑详情模型最新页数
            weakSelf.detailModel.currentPage += 1;
            [weakSelf.listTableView.mj_footer endRefreshing];
        }
        
        
       
    } failure:^(NSError *error) {
        [MYProgressHUD dismiss];
        
    }];
}


#pragma mark - private
-(NSString*)getcurrentPlayIndentifier
{
    NSString *currentPlayIndentifier = [NSString stringWithFormat:@"%@_%@",self.params[@"channel"],self.params[@"id"]];
    
    return currentPlayIndentifier;
}
//刷新简介数据
-(void)refreshDesTable:(SpecialDeailModel*)model
{
    //刷新简介数据
    
    self.detailModel = model;
    [self.desTableView reloadData];
}

//刷新标题数据
-(void)refreshTitleData:(SpecialDeailModel*)model
{
    //获取节目总数
    self.total = [model.episode_count integerValue];
    //拼接节目标题装入标题数组
    [self.titles addObject:[NSString stringWithFormat:@"节目(%@)",model.episode_count]];
    [self.titles addObject:@"简介"];
    //刷新titleView
    [self.titleView reloadData];
}

#pragma mark - action

-(void)playBtnClick:(UIButton*)btn
{
    if (!self.dataSource.count) {return;}//若没有数据，直接返回
    
    if (btn.selected) {
        //暂停播放
        [[PlayManager sharManager] pause];
        btn.selected = NO;
        self.lastPlayModel.isPlay = NO;
        [PlayManager sharManager].currentPlayModel.isPlay = NO;
        [self.listTableView reloadData];
        
    }else{
        
        if (!self.isCurrentSpecialData) {
            //如果是新进来的专辑
            if (self.lastPlayModel) {//已有播放过，继续播放前面暂停的
                [[PlayManager sharManager] play];
                 btn.selected = YES;
                
             }else{//没有播放过
                 //播放第一集
                 [self tableView:self.listTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            }
        }else{
            
            [[PlayManager sharManager] play];
            btn.selected = YES;
            
        }
        
    }
    
}

-(void)refreshListTable:(NSNotification*)notification
{
    if (self.isCurrentSpecialData || [[PlayManager sharManager].currentPlayIndentifier isEqualToString:[self getcurrentPlayIndentifier]]) {
        [self.listTableView reloadData];
        WNLog(@"刷新表格");
    }
    id object = notification.object;
    if (object) {
        if ([object isKindOfClass:[NSString class]]) {
            object = (NSString*)object;
            if ([object isEqualToString:@"play"]) {
                self.playBtn.selected = YES;
            }else{
                self.playBtn.selected = NO;

            }
        }
    }
}

#pragma mark - TitleViewDataSource
-(NSArray*)showTitlesWithtitleView:(TitleView*)titleView
{
    return self.titles;
}
-(void)titleView:(TitleView*)titleView selectIndex:(NSInteger)index
{
    [self.scrollView setContentOffset:CGPointMake(index*self.scrollView.width, 0) animated:YES];
   }

#pragma mark - UITableViewDataSource/delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.listTableView) {
         return  self.dataSource.count;
    }else{
        return self.detailModel !=nil ? 1:0;
    }
   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 100) {
        WS(weakSelf);
        SpecialDetailListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        [cell setPlayBtnClick:^(EpisodeModel *episode) {//播放按钮回调block
            
            if (!episode.isPlay) {
                //若播放此专辑，并且播放管理类无此专辑数据，则让播放管理类拥有此专辑数据
                if (!weakSelf.isCurrentSpecialData) {
                    [PlayManager sharManager].currentPlayIndentifier = [weakSelf getcurrentPlayIndentifier];
                    [PlayManager sharManager].dataSource = weakSelf.dataSource;
                    [PlayManager sharManager].detailModel = weakSelf.detailModel;
                    weakSelf.isCurrentSpecialData = YES;
                    
                }
                if (self.lastPlayModel == episode) {
                    [[PlayManager sharManager] play];
                }else{
                    //标记上一个播放模型，用于刷新列表播放按钮状态
                    if (weakSelf.lastPlayModel) {
                        weakSelf.lastPlayModel.isPlay = NO;
                    }
                    episode.isPlay = YES;
                    //开始播放
                    [[PlayManager sharManager] playWithModel:episode];
                    weakSelf.lastPlayModel = episode;

                }
               
                     weakSelf.playBtn.selected = YES;
                
            }else{
                 //暂停播放
                episode.isPlay = NO;
               [[PlayManager sharManager] pause];
                weakSelf.playBtn.selected = NO;
                
            }
            
            [tableView reloadData];
        }];
        cell.model = self.dataSource[indexPath.row];
        return cell;

    }else{
        SpecialDetailDesCell *cell = [tableView dequeueReusableCellWithIdentifier:CellDesIdentifier];
        cell.model = self.detailModel;
        return cell;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 200) {
        return self.detailModel.desCellHeight;
    }else{
        return KCellHeight;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 100) {
       EpisodeModel *model = self.dataSource[indexPath.row];
        SpecialDetailListCell *cell = (SpecialDetailListCell *)[tableView cellForRowAtIndexPath:indexPath];
        if (cell) {
            cell.playBtnClick(model);
        }
       
    }
}

#pragma mark - UIScrollView delegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.scrollView) {
        NSInteger page = scrollView.contentOffset.x/scrollView.width;
        [self.titleView selectIndex:page];
    }
}

#pragma mark - getter
-(TitleView *)titleView
{
    if (_titleView == nil) {
        _titleView = [[TitleView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, TitleViewH)];
        _titleView.dataSource = self;
        
    }
    return _titleView;
}

-(UIScrollView *)scrollView
{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 65+TitleViewH, kScreenWidth, kScreenHeight-65-TitleViewH)];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.contentSize = CGSizeMake(kScreenWidth*2, _scrollView.height);
        
    }
    return _scrollView;
}

-(UITableView *)listTableView
{
    if (_listTableView == nil) {
        _listTableView = [[UITableView alloc] initWithFrame:self.scrollView.bounds style:UITableViewStylePlain];
        [_listTableView registerNib:[UINib nibWithNibName:CellIdentifier bundle:nil] forCellReuseIdentifier:CellIdentifier];
        _listTableView.tableFooterView = [[UIView alloc] init];
        _listTableView.dataSource =self;
        _listTableView.delegate = self;
        _listTableView.tag = 100;
    }
    return _listTableView;
}

-(UITableView *)desTableView
{
    if (_desTableView == nil) {
        _desTableView = [[UITableView alloc] initWithFrame:CGRectMake(self.scrollView.width, 0, self.scrollView.width, self.scrollView.height) style:UITableViewStylePlain];
      [_desTableView registerNib:[UINib nibWithNibName:CellDesIdentifier bundle:nil] forCellReuseIdentifier:CellDesIdentifier];
      _desTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
      _desTableView.tableFooterView = [[UIView alloc] init];
      _desTableView.dataSource =self;
        _desTableView.delegate =self;
      _desTableView.tag = 200;
        
    }
    return _desTableView;
}

-(UIButton *)playBtn
{
    if (_playBtn == nil) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _playBtn.frame = CGRectMake(0, kScreenHeight-90, 90, 90);
        _playBtn.centerX = self.view.centerX;
        [_playBtn setImage:[UIImage imageNamed:@"charge_btn_bottom_start"] forState:UIControlStateNormal];
        [_playBtn setImage:[UIImage imageNamed:@"charge_btn_bottom_timeout"] forState:UIControlStateSelected];
        [_playBtn addTarget:self action:@selector(playBtnClick:) forControlEvents:UIControlEventTouchDown];

        
    }
    return _playBtn;
}



-(NSMutableArray *)titles
{
    if (_titles == nil) {
        _titles = [NSMutableArray array];
    }
    return _titles;
}

-(NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
