//
//  PublishViewController.m
//  DynamicPublic
//
//  Created by 刘永杰 on 2017/7/31.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "PublishViewController.h"
#import "YYTextView.h"
#import "PublishHeaderView.h"
#import "SelectAlertView.h"
#import "ShootViewController.h"
#import "WNNavigationController.h"
#import "AlertControllerTool.h"
#import "CameraRollViewController.h"

#define kHeaderHeight adaptHeight1334(800 + 230 + 90) + kImageWidth

@interface PublishViewController ()<PublishHeaderViewDelegate>

@property (strong, nonatomic) PublishHeaderView *headerView;
@property (strong, nonatomic) UIButton *sendButton;

@end

@implementation PublishViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.contentInset = UIEdgeInsetsMake(-adaptHeight1334(800), 0, 0, 0);
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [self setupNavigationItem];
    [self setupHeaderView];


}

/**
 设置navigationItem
 */
- (void)setupNavigationItem
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancleAction)];

    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendButton setTitle:@"发送" forState:UIControlStateNormal];
    sendButton.frame = CGRectMake(0, 0, 44, 44);
    [sendButton setTitleColor:[UIColor colorWithString:COLOR39AF34] forState:UIControlStateNormal];
    sendButton.titleLabel.font = [UIFont systemFontOfSize:18.0f];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:sendButton];
    _sendButton = sendButton;
    sendButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [sendButton addTarget:self action:@selector(sendAction) forControlEvents:UIControlEventTouchUpInside];
    
    if (self.isOnlyText) {
        self.title = @"转发到圈子";
        [self setSendButtonEnabled:NO];
    }
    [self setSendButtonEnabled:NO];
    
}

/**
 设置headerView
 */
- (void)setupHeaderView
{
    self.headerView = [[PublishHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, kHeaderHeight)];
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableFooterView = [UIView new];
    self.headerView.delegate = self;
    __weak typeof(self) weakSelf = self;
    self.headerView.changeHeight = ^(NSInteger index){
        
        weakSelf.headerView.height = kHeaderHeight + (kImageWidth + adaptHeight1334(30)) * index;
        
    };
    [self.headerView setOnlyText:self.isOnlyText];
    if (!self.isOnlyText) {
        [self.headerView reloadDataWithImageArray:self.imageArray];
    } else {
        [self.headerView.shareContentView configDataModel:self.timelineModel];
    }
    [self.headerView.textView becomeFirstResponder];
}

/**
 关闭界面
 */
- (void)cancleAction
{
    [self.view endEditing:YES];
    if (self.imageArray.count != 0 || self.headerView.textView.text.length != 0) {
        
        [AlertControllerTool alertControllerWithViewController:self title:@"" message:@"退出此次编辑？" cancleTitle:@"取消" sureTitle:@"退出" cancleAction:^{
            [self.headerView.textView becomeFirstResponder];
        } sureAction:^{
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }];
        
    } else {
        
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }

}

/**
 发送
 */
- (void)sendAction
{
    [self.view endEditing:YES];
    [MBProgressHUD showMessage:@"发送中..."];
    if (!self.isOnlyText) {
        [self publishTimeline];
    } else {
        [self transpondToTimeline];
    }
}

- (void)transpondToTimeline
{
    self.timelineModel.transpond = self.headerView.textView.text;
    self.timelineModel.original_time = [self getDateStr];
    NSMutableArray *array = [UserTimelineManager readUserTimelineFromDocument];
    [array addObject:[self.timelineModel mj_JSONString]];
    [UserTimelineManager saveUserTimelineToDocumentWithDictionary:@{@"data":array}];
    [MBProgressHUD hideHUD];
    [MBProgressHUD showSuccess:@"成功转发到圈子"];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:TimelineNotifiCation object:nil userInfo:self.timelineModel.mj_keyValues];
}

- (void)publishTimeline
{
    
    NSMutableArray *pathArray = [NSMutableArray array];
    
    [self.imageArray enumerateObjectsUsingBlock:^(UIImage *image, NSUInteger idx, BOOL * _Nonnull stop) {
        
        //imei+时间戳(ms级)+随机数（0~100）
        NSString *imageName = [NSString stringWithFormat:@"imei%.0f%u", [[NSDate date] timeIntervalSince1970]*1000, arc4random()%(101)];
        //图片名字MD5
        NSString *imageNameMD5 = [NSString stringWithFormat:@"%@.png",[NSString MD5Of16BitLowerString:imageName]];
        
        [self saveImage:image withName:imageNameMD5];
        
        NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageNameMD5];
        [pathArray addObject:fullPath];
        
    }];
    
    UserModel *userModel = [UserModel mj_objectWithKeyValues:[UserManager currentUser].userInfo];

    TimelineModel *timelineModel = [TimelineModel new];
    timelineModel.title = self.headerView.textView.text;
    timelineModel.content = self.headerView.textView.text;
    timelineModel.cover = [pathArray componentsJoinedByString:@","];
    timelineModel.channel = userModel.avatar;
    timelineModel.source_detail = userModel.nickName;
    timelineModel.status = @"1";
    timelineModel.read_num = @"0";
    timelineModel.comment_num = @"0";
    timelineModel.is_myself = YES;
    timelineModel.original_time = [self getDateStr];
    
    NSMutableArray *array = [UserTimelineManager readUserTimelineFromDocument];
    [array addObject:[timelineModel mj_JSONString]];
    [UserTimelineManager saveUserTimelineToDocumentWithDictionary:@{@"data":array}];
    [MBProgressHUD hideHUD];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
    [MBProgressHUD showSuccess:@"发布成功"];
    [[NSNotificationCenter defaultCenter] postNotificationName:TimelineNotifiCation object:nil userInfo:timelineModel.mj_keyValues];
    
}

- (NSString *)getDateStr
{
    //获取系统当前时间
    NSDate *currentDate = [NSDate date];
    //用于格式化NSDate对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设置格式：zzz表示时区
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //NSDate转NSString
    NSString *currentDateString = [dateFormatter stringFromDate:currentDate];
    //输出currentDateString
    WNLog(@"%@",currentDateString);
    return currentDateString;
}

#pragma mark - 保存图片至沙盒
- (void) saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{
    NSData *temp = UIImageJPEGRepresentation(currentImage, 0.1);
    // 获取沙盒目录
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    // 将图片写入文件
    [temp writeToFile:fullPath atomically:YES];
}

/**
 选择照片
 */
- (void)selectImages
{
    SelectAlertView *selectView = [SelectAlertView new];
    [selectView showAlertResult:^(NSInteger index) {
        
        if (index == 0) {
            
            WNLog(@"相机");
            ShootViewController *shootVC = [ShootViewController new];
            WNNavigationController *navc = [[WNNavigationController alloc] initWithRootViewController:shootVC];
            shootVC.blcokImage = ^(UIImage *image) {
                
                [self.imageArray addObject:image];
                [self.headerView reloadDataWithImageArray:self.imageArray];
                [self setSendButtonEnabled:YES];
                
            };
            [self presentViewController:navc animated:YES completion:nil];
            
        } else {
            
            WNLog(@"相册");
            CameraRollViewController *rollVC = [CameraRollViewController new];
            rollVC.currentNumber = self.imageArray.count;
            rollVC.blcokResult = ^(NSMutableArray *array) {
                
                [self.imageArray addObjectsFromArray:array];
                [self.headerView reloadDataWithImageArray:self.imageArray];
                [self setSendButtonEnabled:YES];
                
            };
            WNNavigationController *navc = [[WNNavigationController alloc] initWithRootViewController:rollVC];
            [self presentViewController:navc animated:YES completion:nil];
            
        }
        
    }];
    
}

/**
 删除图片

 @param image 删除的图片
 */
- (void)deleteImage:(UIImage *)image
{
    [self.imageArray removeObject:image];
    [self.headerView reloadDataWithImageArray:self.imageArray];
    if (self.imageArray.count == 0) {
        
        [self setSendButtonEnabled:NO];
    }
}

/**
 文本框开始变化

 @param textView 文本
 */
- (void)textViewDidChange:(YYTextView *)textView
{
    if ( textView.text.length != 0) {
        [self setSendButtonEnabled:YES];
    } else {
        [self setSendButtonEnabled:NO];
    }
}


/**
 设置发送按钮状态
 
 @param enabled 是否可点击
 */
- (void)setSendButtonEnabled:(BOOL)enabled
{
    self.sendButton.titleLabel.alpha = enabled ? 1 : 0.5;
    self.sendButton.userInteractionEnabled = enabled;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
