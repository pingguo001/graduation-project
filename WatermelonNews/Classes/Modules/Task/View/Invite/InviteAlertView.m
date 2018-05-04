//
//  InviteAlertView.m
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/11/13.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "InviteAlertView.h"
#import "ShareImageTool.h"

@interface InviteAlertView ()<UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *dataArray;
@property (strong, nonatomic) NSArray *iconArray;

@end

@implementation InviteAlertView

- (void)p_setupViews
{
    UIColor * color = [UIColor blackColor];
    self.backgroundColor = [color colorWithAlphaComponent:0.7];
    self.frame = [UIScreen mainScreen].bounds;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth - adaptWidth750(150), adaptHeight1334(540)) style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.scrollEnabled = NO;
    [self addSubview:tableView];
    tableView.sectionFooterHeight = 0;
    tableView.sectionHeaderHeight = 0;
    
    self.tableView = tableView;
    
    UIButton *headerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    headerButton.frame = CGRectMake(0, 0, kScreenWidth, adaptHeight1334(100));
    [headerButton setTitle:@"邀请好友" forState:UIControlStateNormal];
    headerButton.titleLabel.font = [UIFont systemFontOfSize:adaptFontSize(40)];
    headerButton.backgroundColor = [UIColor colorWithString:COLOR39AF34];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"invite_btn_close"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [headerButton addSubview:closeButton];
    
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(headerButton).offset(-adaptWidth750(20));
        make.centerY.equalTo(headerButton);
        
    }];
    
    self.tableView.tableHeaderView = headerButton;
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.equalTo(self);
        make.left.equalTo(self).offset(adaptWidth750(80));
        make.right.equalTo(self).offset(-adaptWidth750(80));
        make.height.mas_equalTo(adaptHeight1334(540));
        
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    self.userInteractionEnabled = YES;
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    
    self.dataArray = @[@"分享到微信朋友圈", @"分享到QQ空间", @"发送给微信好友", @"发送给QQ好友"];
    self.iconArray = @[@"invite_btn_fried", @"invite_btn_qzone", @"invite_btn_wechat", @"invite_btn_qq"];
    [self.tableView reloadData];
    
}

- (void)show
{
    [UIView animateWithDuration:0.5 animations:^{
        
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        
    }];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    self.tableView.layer.position = self.center;
    self.tableView.transform = CGAffineTransformMakeScale(1.20, 1.20);
    [UIView animateWithDuration:0.5 delay:0
         usingSpringWithDamping:0.8
          initialSpringVelocity:1
                        options:UIViewAnimationOptionCurveLinear animations:^{
                            
                            self.tableView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                            
                        } completion:^(BOOL finished) {
                            
                        }];
    
}

- (void)dismiss
{
    self.tableView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    
    [UIView animateWithDuration:0.2 delay:0
         usingSpringWithDamping:1
          initialSpringVelocity:1
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         
                         self.tableView.transform = CGAffineTransformMakeScale(0.000001, 0.0000001);
                         
                     } completion:^(BOOL finished) {
                         [super removeFromSuperview];
                     }];
    
}

#pragma mark - TableViewDelegateAndDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:self.iconArray[indexPath.row]];
    cell.textLabel.text = self.dataArray[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:adaptFontSize(30)];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LinkModel *linkModel = [LinkModel mj_objectWithKeyValues:[UserManager currentUser].arrLinks];
    switch (indexPath.row) {
        case 0:
        case 2:{
            UIImage *shareImage = [ShareImageTool createShareImageWithUrl: indexPath.row == 2 ?  linkModel.wechatFriendPic : linkModel.wechatMomentPic];
            UIImage *thumbImage = [UIImage imageWithImage:shareImage scaledToSize:CGSizeMake(shareImage.size.width / 5.0, shareImage.size.height / 5.0)];
            [[WechatApi sharedInstance] shareImage:shareImage thumbImage:thumbImage to: indexPath.row == 2 ? WechatSceneSession : WechatSceneTimeline];
            break;
        }
        case 1:
        case 3:{
            
            UIImage *shareImage = [ShareImageTool createShareImageWithUrl: indexPath.row == 1 ?  linkModel.qqZone : linkModel.qqFriend];

            [[TencentQQApi sharedInstance] shareImage:shareImage title:@"西瓜头条" description:@"" to:indexPath.row == 1 ? QQSceneQzone : QQSceneSession callback:^(int code, NSString * _Nullable description) {
                if (code == 0) {
                    [MBProgressHUD showSuccess:@"分享成功"];
                } else {
                    
                    if (code == -4) {
                        [MBProgressHUD showError:@"分享取消"];
                    } else {
                        [MBProgressHUD showError:description];
                    }
                }
            }];
            break;
        }
    }
    [self dismiss];
    //统计事件
    [self clickStatisticalIndexPath:indexPath];
    
}

- (void)clickStatisticalIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0: [TalkingDataApi trackEvent:self.isHome ? TD_CLICK_HOME_INVITE_MOMENT : TD_CLICK_TASK_INVITE_MOMENT]; break;
        case 1: [TalkingDataApi trackEvent:self.isHome ? TD_CLICK_HOME_INVITE_QZONE : TD_CLICK_TASK_INVITE_QZONE]; break;
        case 2: [TalkingDataApi trackEvent:self.isHome ? TD_CLICK_HOME_INVITE_WECHAT : TD_CLICK_TASK_INVITE_WECHAT]; break;
        case 3: [TalkingDataApi trackEvent:self.isHome ? TD_CLICK_HOME_INVITE_QQ : TD_CLICK_TASK_INVITE_QQ]; break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return adaptHeight1334(110);
}

/**
 手势冲突解决
 
 @param gestureRecognizer 手势
 @param touch touch
 @return 是否支持手势
 */
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
}

@end
