//
//  SelectAlertView.m
//  NationalRedPacket
//
//  Created by 刘永杰 on 2017/7/31.
//  Copyright © 2017年 孙明悦. All rights reserved.
//

#import "SelectAlertView.h"
#import "SelectCell.h"

@interface SelectAlertView ()<UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *dataArray;

@end

@implementation SelectAlertView

- (void)p_setupViews
{
    UIColor * color = [UIColor blackColor];
    self.backgroundColor = [color colorWithAlphaComponent:0.8];
    self.frame = [UIScreen mainScreen].bounds;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, adaptHeight1334(314)) style:UITableViewStyleGrouped];
    tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [tableView registerClass:[SelectCell class] forCellReuseIdentifier:SelectCellID];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.scrollEnabled = NO;
    [self addSubview:tableView];
    tableView.sectionFooterHeight = 0;
    tableView.sectionHeaderHeight = adaptHeight1334(14);
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.01f)];
    
    self.tableView = tableView;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    self.userInteractionEnabled = YES;
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    
    self.dataArray = @[@[@"拍照", @"从手机相册选择"], @[@"取消"]];
    [self.tableView reloadData];
    
}

#pragma mark - TableViewDelegateAndDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray[section] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SelectCell *cell = [tableView dequeueReusableCellWithIdentifier:SelectCellID forIndexPath:indexPath];
    [cell configModelData:self.dataArray[indexPath.section][indexPath.row] indexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        self.backResult(indexPath.row);
    }
    [self dismiss];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return adaptHeight1334(100);
}

/**
 弹出选择界面
 
 @param result 回调选择方式
 */
- (void)showAlertResult:(BackResult)result
{
    self.backResult = result;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.25 animations:^{
       
        self.tableView.y = kScreenHeight - self.tableView.height;
        
    }];
}

/**
 界面消失
 */
- (void)dismiss
{
    [UIView animateWithDuration:0.25 animations:^{
        self.tableView.y = kScreenHeight;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
