//
//  NewsListViewController.m
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/8/21.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "NewsListViewController.h"
#import "SimpleNewsCell.h"
#import "MultiNewsCell.h"
#import "TencentAdCell.h"
#import "GoogleAdCell.h"
#import "NewsDetailViewController.h"
#import "WNLoadingView.h"
#import "ShowDataView.h"
#import "NewsListApi.h"
#import "FreshNewsCell.h"
#import "VideoNewsCell.h"
#import "NewsStatApi.h"
#import "RedPacketOpenView.h"
#import "UserManager.h"
#import "ArticleDatabase.h"
#import "NativeExpressAdApi.h"
#import "TencentAdManager.h"
#import <Social/SLComposeViewController.h>
#import <Social/Social.h>
#import "GoogleAdModel.h"
#import "GoogleAdManager.h"
#import "GoogleNativeAdCell.h"
#import "TaskAdManager.h"
#import "TaskAdCell.h"
#import "TaskDetailViewController.h"
#import "AdInfoModel.h"
#import "PackageManager.h"
#import "ShareImageCell.h"
#import "InviteAlertView.h"

#define KselfName @"自定义"
#define kInviteLocation @"邀请好友"

//新闻相关
#define kMaxSequence(x) [NSString stringWithFormat:@"%@MaxSequence", x]
#define kMinSequence(x) [NSString stringWithFormat:@"%@MinSequence", x]
#define kMaxVideoSequence(x) [NSString stringWithFormat:@"%@MaxVideoSequence", x]
#define kMinVideoSequence(x) [NSString stringWithFormat:@"%@MinVideoSequence", x]


@interface NewsListViewController ()<ResponseDelegate, UITabBarDelegate>

@property (strong, nonatomic) NSMutableArray *freshImages;
@property (strong, nonatomic) NewsListApi *listApi;
@property (strong, nonatomic) NewsStatApi *statApi;
@property (assign, nonatomic) NSInteger startTime;

@property (strong, nonatomic) NSMutableArray *dataArray;
@property (copy, nonatomic) NSString *dateKey;
@property (strong, nonatomic) ShowDataView *dataView;
@property (strong, nonatomic) NewsArticleModel *inviteModel;
@property (strong, nonatomic) NewsArticleModel *freshModel;
@property (assign, nonatomic) BOOL isShowInvite;

@end

@implementation NewsListViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UploadShowInfoNotifiCation object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[TaskAdManager sharedManager] getTaskDetailSuccess:^{
        
        [TalkingDataApi trackEvent:TD_FINISH_ICCAD];
        [self.dataArray removeObject:[TaskAdManager sharedManager].doingTask];
        [self.tableView reloadData];
    }];
    
    if ([UserManager currentUser].applicationMode.integerValue != 0 || [UserManager currentUser].sensitiveArea.integerValue == 1) {
        return;
    }
    
    [self getDateKey];
    NSInteger number = [[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@number", self.dateKey]] integerValue];  //点击过的文章数
    NSString *showKey = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@Show",self.dateKey]];
    
    if ([UserManager currentUser].taskAlert.integerValue == 1 && ![showKey isEqualToString:@"YES"] && number > [UserManager currentUser].taskAlertLimit.integerValue) {
        
        [AlertControllerTool alertControllerWithViewController:self title:@"赚钱秘籍" message:@"\n多做下载任务，阅读时能领到更多红包哦！" cancleTitle:@"给钱不要" sureTitle:@"去做任务" cancleAction:^{
            [TalkingDataApi trackEvent:TD_CANCLE_SHOWTASK];
            
        } sureAction:^{

            UITabBarController *tabBar = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
            tabBar.selectedIndex = 1;
            [TalkingDataApi trackEvent:TD_SURE_DOTASK];

        }];
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:[NSString stringWithFormat:@"%@Show",self.dateKey]];
        [[NSUserDefaults standardUserDefaults] synchronize];

    }
}

- (void)getDateKey
{
    NSDate *now = [NSDate date];
    // 1.创建一个时间格式化对象
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 2.设置时间格式化对象的样式
    formatter.dateFormat = @"yyyy-MM-dd";
    // 3.利用时间格式化对象对时间进行格式化
    NSString *str = [formatter stringFromDate:now];
    self.dateKey = str;
    WNLog(@"%@",str);
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    WNLog(@"%@", kMaxSequence(self.categoryModel.type));
    
    [self.tableView registerClass:[SimpleNewsCell class] forCellReuseIdentifier:SimpleNewsCellID];
    [self.tableView registerClass:[MultiNewsCell class] forCellReuseIdentifier:MultiNewsCellID];
    [self.tableView registerClass:[VideoNewsCell class] forCellReuseIdentifier:VideoNewsCellID];
    [self.tableView registerClass:[FreshNewsCell class] forCellReuseIdentifier:FreshNewsCellID];
    [self.tableView registerClass:[TencentAdCell class] forCellReuseIdentifier:TencentAdCellID];
    [self.tableView registerClass:[GoogleAdCell class] forCellReuseIdentifier:GoogleAdCellID];
    [self.tableView registerClass:[TaskAdCell class] forCellReuseIdentifier:TaskAdCellID];
    [self.tableView registerClass:[ShareImageCell class] forCellReuseIdentifier:ShareImageCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"GoogleNativeAdCell" bundle:nil] forCellReuseIdentifier:@"GoogleNativeAdCell"];
    
    _listApi = [[NewsListApi alloc] initWithDelegate:self newsKey:self.categoryModel.type];
    _statApi = [[NewsStatApi alloc] initWithDelegate:self articleCategory:self.categoryModel.type];
    
    [self setupRefreshControl];
    [self newUserOpenPacket];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
}
//新用户红包
- (void)newUserOpenPacket
{
    
    if ([UserManager currentUser].infoFlowRed.integerValue == 1 && [UserManager currentUser].applicationMode.integerValue != 1) {
        
        RedPacketOpenView *redView = [[RedPacketOpenView alloc] init];
        [redView show];
        
        redView.complete = ^{
            
            [self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        };
    }
}

- (void)insetInviteInfo
{
    if (!([UserManager currentUser].applicationMode.integerValue == 0)) {
        return;  //线上模式才有
    }
    NSInteger number = [[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@number", self.dateKey]] integerValue];  //点击过的文章数
    //1.只在用户安装前3天；2.用户累计阅读10篇文章后
    if ((time(0) - [[[NSUserDefaults standardUserDefaults] objectForKey:InstallTime] longLongValue]) <= 60*60*24*3 && number > 10 && self.isShowInvite != YES) {
        //插入邀请入口
        if ([self.categoryModel.type isEqualToString:@"hot"] && self.dataArray.count > 1) {
            [self.dataArray insertObject:self.inviteModel atIndex:1];
            self.isShowInvite = YES;
        }
    } else {
        [self.dataArray removeObject:self.inviteModel];
    }
}

//在数据源中插入广告
- (void)insertAdInfoToOriginArray:(NSMutableArray *)originArray
{
    if (!([UserManager currentUser].applicationMode.integerValue == 0 && [UserManager currentUser].registrationDays.integerValue >= 1)) {
        return;  //线上模式才加广告（线上且注册24H以上的用户加广告）
    }
    
    AdInfoModel *adModel = [AdInfoModel mj_objectWithKeyValues:[UserManager currentUser].newAdInfo];
    WNLog(@"%@\n%@", adModel.adArray, adModel.adDefault);
    
    NSMutableArray *tencentArray = [TencentAdManager sharedManager].adArray;
    NSMutableArray *googleArray = [GoogleAdManager sharedManager].adArray;
    NSMutableArray *iccArray = [TaskAdManager sharedManager].adArray;
    
    for (AdLocationModel *locationModel in adModel.adArray) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[locationModel.location integerValue] inSection:0];
        //如果插入的位置大于数据源数量，直接返回
        if (indexPath.row > originArray.count) {
            return;
        }
        if ([locationModel.type isEqualToString:@"icc"]) {
            
            if (iccArray.count != 0) {
                
                [self removeSameIccAd:iccArray.firstObject]; //移除已存在的相同任务
                //插入前判断本地是否安装，若已经安装，该任务应该屏蔽掉
                if ([PackageManager isAppInstalled:[iccArray.firstObject bundle_id]]) {
                    
                    [iccArray removeObject:iccArray.firstObject];
                    [self insertDefaultAd:originArray indexPath:indexPath];
                    
                } else {
                    
                    [originArray insertObject:iccArray.firstObject atIndex:indexPath.row];
                    [iccArray removeObject:iccArray.firstObject];
                }
                
            } else {
                
                [[TaskAdManager sharedManager] fetchTaskAd];
                [self insertDefaultAd:originArray indexPath:indexPath];
            }
            
        } else if ([locationModel.type isEqualToString:@"google"]){
            
            if (googleArray.count != 0) {
                
                [originArray insertObject:googleArray.firstObject atIndex:indexPath.row];
                [googleArray removeObject:googleArray.firstObject];
                
            } else {
                
                [[GoogleAdManager sharedManager] fetchGoogleAd];
                [self insertDefaultAd:originArray indexPath:indexPath];
            }
            
        } else if ([locationModel.type isEqualToString:@"tencent"]){
            
            if (tencentArray.count != 0) {
                
                [originArray insertObject:tencentArray.firstObject atIndex:indexPath.row];
                [tencentArray removeObject:tencentArray.firstObject];
                
            } else {
                
                [[NSNotificationCenter defaultCenter] postNotificationName:FetchAdNotifiCation object:nil];
                [self insertDefaultAd:originArray indexPath:indexPath];
            }
        }
    }
}

//指定位置插入默认广告
- (void)insertDefaultAd:(NSMutableArray *)originArray indexPath:(NSIndexPath *)indexPath
{
    AdInfoModel *adModel = [AdInfoModel mj_objectWithKeyValues:[UserManager currentUser].newAdInfo];
    WNLog(@"%@\n%@", adModel.adArray, adModel.adDefault);
    
    NSMutableArray *tencentArray = [TencentAdManager sharedManager].adArray;
    NSMutableArray *googleArray = [GoogleAdManager sharedManager].adArray;
    NSMutableArray *iccArray = [TaskAdManager sharedManager].adArray;
    
    for (NSString *typeStr in adModel.adDefault) {
        
        if ([typeStr isEqualToString:@"icc"]) {
            
            if (iccArray.count != 0) {
                
                [self removeSameIccAd:iccArray.firstObject]; //移除已存在的相同任务
                //插入前判断本地是否安装，若已经安装，该任务应该屏蔽掉
                if ([PackageManager isAppInstalled:[iccArray.firstObject bundle_id]]) {
                    
                    [iccArray removeObject:iccArray.firstObject];
                } else {
                    
                    [originArray insertObject:iccArray.firstObject atIndex:indexPath.row];
                    [iccArray removeObject:iccArray.firstObject];
                    break;
                }
            } else {
                
                [[TaskAdManager sharedManager] fetchTaskAd];
            }
        } else if ([typeStr isEqualToString:@"google"]){
            
            if (googleArray.count != 0) {
                
                [originArray insertObject:googleArray.firstObject atIndex:indexPath.row];
                [googleArray removeObject:googleArray.firstObject];
                break;
            } else {
                
                [[GoogleAdManager sharedManager] fetchGoogleAd];
                
            }
        } else if ([typeStr isEqualToString:@"tencent"]){
            
            if (tencentArray.count != 0) {
                
                [originArray insertObject:tencentArray.firstObject atIndex:indexPath.row];
                [tencentArray removeObject:tencentArray.firstObject];
                break;
            } else {
                [[NSNotificationCenter defaultCenter] postNotificationName:FetchAdNotifiCation object:nil];
            }
        }
    }
}

- (void)removeSameIccAd:(TaskAdModel *)model
{
    for (TaskAdModel *taskModel in self.dataArray) {
        if ([taskModel.source isEqualToString:TaskAdType]) {
            if (taskModel.taskId.integerValue == model.taskId.integerValue) {
                [self.dataArray removeObject:taskModel];
                break;
            }
        }
    }
}

#pragma mark - ListApiDelegate
//请求数据成功
- (void)request:(NetworkRequest *)request success:(id)response
{
    if ([request.url containsString:statUrl]) {
        return;
    }
    [WNLoadingView hideLoadingForView:self.loadingView];

    NSMutableArray *newArray = [NewsArticleModel mj_objectArrayWithKeyValuesArray:response[@"article"]].mutableCopy;
    
    ShowDataView *dataView = [ShowDataView new];
    _dataView = dataView;
    if (_listApi.operationType == OperationFresh) {

        [self statRequestWithActionType:STAT_REFRESH newsArray:newArray.mutableCopy];
        
        dataView.frame = CGRectMake(0, 0, kScreenWidth, adaptHeight1334(42 * 2));
        [dataView setDataNumber:newArray.count];
        
        //记录上次看到的位置
        if (_listApi.sequence.integerValue != 0 && newArray.count != 0 && self.dataArray.count != 0) {
            
            [self.dataArray removeObject:self.freshModel];
            [newArray addObject:self.freshModel];
            
        }
        
        //最新的数据放在前面位置
        [newArray addObjectsFromArray:self.dataArray];
        self.dataArray = newArray;
        
        //插入广告数据
        [self insertAdInfoToOriginArray:self.dataArray];
        //插入邀请广告
        [self insetInviteInfo];
        
        [self.tableView.mj_header addSubview:dataView];

        
    } else {
        
        [self statRequestWithActionType:STAT_PULL newsArray:newArray.mutableCopy];
        //插入广告数据
        [self insertAdInfoToOriginArray:newArray];
        [self.dataArray addObjectsFromArray:newArray];
        [self.tableView.mj_footer endRefreshing];
        
    }
    if (newArray.count == 0) {
        
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
    
    [self.tableView reloadData];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView.mj_header endRefreshingWithCompletionBlock:^{
            [dataView removeFromSuperview];
        }];
    });
}

- (void)request:(NetworkRequest *)request failure:(NSError *)error
{
    [self.tableView.mj_header endRefreshingWithCompletionBlock:^{
        [_dataView removeFromSuperview];
    }];
    [self.tableView.mj_footer endRefreshing];
    [WNLoadingView hideLoadingForView:self.loadingView];

}

- (void)statRequestWithActionType:(NSString *)type newsArray:(NSArray *)newArray
{
    NSMutableArray *idsArray = [NSMutableArray new];
    NSMutableArray *videosArray = [NSMutableArray new];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        for (NewsArticleModel *model in newArray) {
            if (model.type.integerValue == 1) {
                [idsArray addObject:model.articleId];
            } else {
                [videosArray addObject:model.articleId];
            }
        }
        // 下拉刷新统计
        _statApi.actionType = type;
        _statApi.articleIds = idsArray.mutableCopy;
        _statApi.videoIds = videosArray.mutableCopy;
        [_statApi call];
        
        //保存id
        if ([type isEqualToString:STAT_PULL]) {
            
            [self saveMinSequenceWithNewsArray:newArray.mutableCopy];

        } else {
            
            if (self.dataArray.count == 0) {
                [self saveMinSequenceWithNewsArray:newArray.mutableCopy];
            }
            [self saveMaxSequenceWithNewArray:newArray.mutableCopy];
        }
       
    });
}

#pragma mark - SetupViews

- (void)setupRefreshControl
{
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.dataArray = [NSMutableArray array];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *type = self.categoryModel.type;
    
    //下拉
    MJRefreshGifHeader *gifHeader = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        
        _listApi.operationType = OperationFresh;
        _listApi.sequence = [defaults objectForKey:kMaxSequence(type)];
        _listApi.videosequence = [defaults objectForKey:kMaxVideoSequence(type)];

        [_listApi call];
        
    }];
    [self confignHeaderView:gifHeader];
    [self.tableView.mj_header beginRefreshing];
    
    //上拉
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        _listApi.operationType = OperationNext;
        _listApi.sequence = [defaults objectForKey:kMinSequence(type)];
        _listApi.videosequence = [defaults objectForKey:kMinVideoSequence(type)];
        [_listApi call];
        
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadShowInfo) name:UploadShowInfoNotifiCation object:nil];
}

//配置headerView
- (void)confignHeaderView:(MJRefreshGifHeader *)gifHeader
{
    
    gifHeader.lastUpdatedTimeLabel.hidden = YES;
    
    [gifHeader setImages:self.freshImages.mutableCopy forState:MJRefreshStateRefreshing];
    [gifHeader setImages:self.freshImages.mutableCopy forState:MJRefreshStateIdle];

    [gifHeader setTitle:@"推荐中..." forState:MJRefreshStateRefreshing];
    [gifHeader setTitle:@"松开推荐" forState:MJRefreshStatePulling];
    [gifHeader setTitle:@"下拉推荐" forState:MJRefreshStateIdle];
    self.tableView.mj_header = gifHeader;
    
}

- (NSMutableArray *)freshImages
{
    if (!_freshImages) {
        
        _freshImages = [NSMutableArray array];
        
        for (int i = 1; i < 5; i++) {
            
            [_freshImages addObject:[UIImage imageNamed:[NSString stringWithFormat:@"news_%d", i]]];
        }
    }
    return _freshImages;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NewsArticleModel *model = self.dataArray[indexPath.row];
    
    //刷新cell
    if ([model.source isEqualToString:KselfName]) {
        
        FreshNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:FreshNewsCellID forIndexPath:indexPath];
        return cell;
    }
    
    //邀请cell
    if ([model.source isEqualToString:kInviteLocation]) {
        ShareImageCell *cell = [tableView dequeueReusableCellWithIdentifier:ShareImageCellID forIndexPath:indexPath];
        [cell configModelData:nil indexPath:indexPath];
        [TalkingDataApi trackEvent:TD_SHOW_HOME_INVITE];
        return cell;
    }
    
    //iCC广告cell
    if ([model.source isEqualToString:TaskAdType]) {
        
        TaskAdCell *cell = [tableView dequeueReusableCellWithIdentifier:TaskAdCellID forIndexPath:indexPath];
        [cell configModelData:model indexPath:indexPath];
        return cell;
        
    }
    
    //腾讯广告cell
    if ([model.source isEqualToString:expressAdType]) {
        
        TencentAdCell *cell = [[TencentAdCell alloc] init];
        if ([((TencentAdModel *)model).expressAdType isEqualToString:adType1] ) {
            cell.frame = CGRectMake(0, 0, kScreenWidth, kAd1Height);
        } else {
            cell.frame = CGRectMake(0, 0, kScreenWidth, kAd2Height);
        }
        cell.deleteBlock = ^{
            
            //第一,删除数据源,
            [self.dataArray removeObject:self.dataArray[indexPath.row]];
            //第二,删除表格cell
            [tableView deleteRowsAtIndexPaths:@[indexPath]withRowAnimation: UITableViewRowAnimationAutomatic];

        };
        ((TencentAdModel *)model).expressAdView.controller = self;
        [cell configModelData:model indexPath:indexPath];
        
        return cell;
    }
    //google广告
    if ([model.source isEqualToString:GoogleAdType]) {
        
        GADNativeAppInstallAd * ad = [(GoogleAdModel *)model raw];
        ad.rootViewController = self;
        
        GoogleNativeAdCell *nativeAppInstallAdCell = [tableView dequeueReusableCellWithIdentifier:@"GoogleNativeAdCell" forIndexPath:indexPath];
        nativeAppInstallAdCell.deleteBlock = ^(NSIndexPath *indexPath) {
            [self.dataArray removeObjectAtIndex:indexPath.row];
            /** TableView中 删除一条广告cell */
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        };
        [nativeAppInstallAdCell configModelData:model indexPath:indexPath];
        return nativeAppInstallAdCell;
    }
    
    MultiNewsCell *cell;
    if (model.type.integerValue == 2) {
        
        cell = [tableView dequeueReusableCellWithIdentifier:VideoNewsCellID forIndexPath:indexPath];
    } else {
        
        cell = [tableView dequeueReusableCellWithIdentifier:model.cover.count > 1 ? MultiNewsCellID : SimpleNewsCellID forIndexPath:indexPath];
    }
    model.category = self.categoryModel.type;
    //插入到数据库中
    [[ArticleDatabase sharedManager] insertShowArticleModel:model];
    [cell configModelData:model indexPath:indexPath];
    
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArray.count == 0) {
        return;
    }
    NewsArticleModel *model = self.dataArray[indexPath.row];
    //广告cell不跳转
    if ([model.source isEqualToString:tencentAdType] || [model.source isEqualToString:GoogleAdType]) {
        return;
    }
    //iCC广告cell
    if ([model.source isEqualToString:TaskAdType]) {
        
        TaskAdModel *taskModel = (TaskAdModel *)model;
        [TalkingDataApi trackEvent:TD_CLICK_ICCAD];
        [[TaskAdManager sharedManager] doTaskAd:taskModel controller:self success:^{
            
            TaskDetailViewController *detailVC = [TaskDetailViewController new];
            detailVC.doingTaskModel = [TaskAdManager sharedManager].doingTask;
            [self showViewController:detailVC sender:nil];
            
        }];
        
        return;
    }
    //刷新点击
    if ([model.source isEqualToString:KselfName]) {
        [self.tableView.mj_header beginRefreshing];
        return;
    }
    //邀请cell点击
    if ([model.source isEqualToString:kInviteLocation]) {
        InviteAlertView *inviteView = [InviteAlertView new];
        inviteView.isHome = YES;
        [inviteView show];
        [TalkingDataApi trackEvent:TD_CLICK_HOME_INVITE];
        return;
    }
    
    model.isRead = YES;
    [[ArticleDatabase sharedManager] updateArticleIdDidReadWithArticleIds:model.articleId];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    NewsDetailViewController *detailVC = [NewsDetailViewController new];
    model.category = self.categoryModel.type;
    detailVC.model = model;
    
    [self showViewController:detailVC sender:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsArticleModel *model = self.dataArray[indexPath.row];
    if ([model.source isEqualToString:KselfName]) {
        return adaptHeight1334(80);
    }
    if ([model.source isEqualToString:kInviteLocation]) {
        return adaptHeight1334(440);
    }
    //iCC广告cell
    if ([model.source isEqualToString:TaskAdType]) {
        
        return adaptHeight1334(200);
        
    }
    if ([model.source isEqualToString:expressAdType]) {
        
        if ([((TencentAdModel *)model).expressAdType isEqualToString:adType1] ) {
            return kAd1Height + 0.5 + adaptHeight1334(34);
        } else {
            return kAd2Height + 0.5 + adaptHeight1334(34);
        }
    }
    if ([model.source isEqualToString:GoogleAdType]) {
        
        return [tableView fd_heightForCellWithIdentifier: GoogleAdCellID cacheByKey:model.title configuration:^(GoogleAdCell *cell) {
            
            [cell configModelData:model indexPath:indexPath];
        }];
    }
    
    if (model.type.integerValue == 2) {
        
        return [tableView fd_heightForCellWithIdentifier: VideoNewsCellID cacheByKey:model.articleId configuration:^(VideoNewsCell *cell) {
            
            [cell configModelData:model indexPath:indexPath];
        }];
    }
    CGFloat height = [tableView fd_heightForCellWithIdentifier:model.cover.count > 1 ? MultiNewsCellID : SimpleNewsCellID cacheByKey:model.articleId configuration:^(MultiNewsCell *cell) {
        
        [cell configModelData:model indexPath:indexPath];
        
    }];
    return height < adaptHeight1334(214) ? adaptHeight1334(214) : height;
}

//上传显示过的新闻
- (void)uploadShowInfo
{
    
    NSArray *array = [[ArticleDatabase sharedManager] queryNoUploadAritcleWithCategory:self.categoryModel.type type:@"1"];
    NSArray *videoArray = [[ArticleDatabase sharedManager] queryNoUploadAritcleWithCategory:self.categoryModel.type type:@"2"];
    if (array.count || videoArray.count) {
        
        _statApi.articleIds = array;
        _statApi.videoIds = videoArray;
        _statApi.actionType = STAT_SHOW;
        [_statApi call];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [[ArticleDatabase sharedManager] updateArticleIdDidUploadWithArticleIds:array];
            [[ArticleDatabase sharedManager] updateArticleIdDidUploadWithArticleIds:videoArray];
        });
        

    }

}

/**
 保存不同类型新闻模型的相关id到本地--历史最大最小id逻辑

 @param model 新闻模型
 */
- (void)saveNewsSequence:(NewsArticleModel *)model
{

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *type = self.categoryModel.type;
    
    switch (model.type.integerValue) {
        case 1:{
            
            if (model.articleId.integerValue > [[defaults objectForKey:kMaxSequence(type)] integerValue]) {
                
                [defaults setObject:model.articleId forKey:kMaxSequence(type)];
            }
            if ([[defaults objectForKey:kMinSequence(type)] integerValue] == 0) {
                
                [defaults setObject:model.articleId forKey:kMinSequence(type)];
            }
            if (model.articleId.integerValue < [[defaults objectForKey:kMinSequence(type)] integerValue]) {
                
                [defaults setObject:model.articleId forKey:kMinSequence(type)];
            }
            break;
        }
        case 2:{
            
            if (model.articleId.integerValue > [[defaults objectForKey:kMaxVideoSequence(type)] integerValue]) {
                
                [defaults setObject:model.articleId forKey:kMaxVideoSequence(type)];
            }
            if ([[defaults objectForKey:kMinVideoSequence(type)] integerValue] == 0) {
                
                [defaults setObject:model.articleId forKey:kMinVideoSequence(type)];
            }
            if (model.articleId.integerValue < [[defaults objectForKey:kMinVideoSequence(type)] integerValue]) {
                
                [defaults setObject:model.articleId forKey:kMinVideoSequence(type)];
            }
            break;
        }
    }
}

#pragma mark - 存储id到本地  存储本次更新的数据的最大最小id

//存储新数据最大的id
- (void)saveMaxSequenceWithNewArray:(NSArray *)newArray
{
    if (newArray.count == 0) {
        return;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *type = self.categoryModel.type;
    
    NewsArticleModel *firstModel = newArray.firstObject;
    
    if (firstModel.type.integerValue == 1) {
        
        [defaults setObject:firstModel.articleId forKey:kMaxSequence(type)];
        for (NewsArticleModel *model in newArray) {
            if (model.type.integerValue == 2) {
                
                [defaults setObject:model.articleId forKey:kMaxVideoSequence(type)];
                break;
            }
        }
        
    } else {
        
        [defaults setObject:firstModel.articleId forKey:kMaxVideoSequence(type)];
        for (NewsArticleModel *model in newArray) {
            if (model.type.integerValue == 1) {
                
                [defaults setObject:model.articleId forKey:kMaxSequence(type)];
                break;
            }
        }
    }


}

//存储新数据最小的id
- (void)saveMinSequenceWithNewsArray:(NSArray *)newArray
{
    if (newArray.count == 0) {
        return;
    }
    NSArray *reversedArray = [[newArray reverseObjectEnumerator] allObjects];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *type = self.categoryModel.type;
    
    NewsArticleModel *firstModel = reversedArray.firstObject;
    
    if (firstModel.type.integerValue == 1) {
        
        [defaults setObject:firstModel.articleId forKey:kMinSequence(type)];
        for (NewsArticleModel *model in reversedArray) {
            if (model.type.integerValue == 2) {
                
                [defaults setObject:model.articleId forKey:kMinVideoSequence(type)];
                break;
            }
        }
        
    } else {
        
        [defaults setObject:firstModel.articleId forKey:kMinVideoSequence(type)];
        for (NewsArticleModel *model in reversedArray) {
            if (model.type.integerValue == 1) {
                
                [defaults setObject:model.articleId forKey:kMinSequence(type)];
                break;
            }
        }
    }
}

- (NewsArticleModel *)inviteModel
{
    if (!_inviteModel) {
        _inviteModel = [NewsArticleModel new];
        _inviteModel.source = kInviteLocation;
    }
    return _inviteModel;
}

- (NewsArticleModel *)freshModel
{
    if (!_freshModel) {
        _freshModel = [NewsArticleModel new];
        _freshModel.source = KselfName;
    }
    return _freshModel;
}

@end
