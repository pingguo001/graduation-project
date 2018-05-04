//
//  InformationTableViewController.m
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/10/25.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "InformationTableViewController.h"
#import "CameraTakeMamanger.h"
#import "InformationCell.h"
#import "InfomationModel.h"
#import "NicknameViewController.h"
#import "AlertControllerTool.h"
#import "DatePickAlertView.h"

@interface InformationTableViewController ()<DatePickAlertViewDelegate>

@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) NSArray *titleArray;
@property (strong, nonatomic) UserModel *userModel;

@end

@implementation InformationTableViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"完善资料";
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.01f)];
    [self.tableView registerClass:[InformationCell class] forCellReuseIdentifier:InformationCellID];
    
    self.dataArray = [NSMutableArray array];
    self.userModel = [UserModel mj_objectWithKeyValues: [UserManager currentUser].userInfo];
    
    self.titleArray = @[@"头像",@"昵称",@"年龄",@"性别"];

    [self.titleArray enumerateObjectsUsingBlock:^(NSString *str, NSUInteger idx, BOOL * _Nonnull stop) {
        
        InfomationModel *model = [InfomationModel new];
        model.title = str;
        [self.dataArray addObject:model];
        switch (idx) {
            case 0: model.info = self.userModel.avatar; break;
            case 1: model.info = self.userModel.nickName; break;
            case 2: model.info = self.userModel.age; break;
            case 3: model.info = self.userModel.sex; break;
        }
        
    }];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return 1;
    }
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    InformationCell *cell = [tableView dequeueReusableCellWithIdentifier:InformationCellID forIndexPath:indexPath];
    
    [cell configModelData:self.dataArray[indexPath.row] indexPath:indexPath];
    // Configure the cell...
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        
        [AlertControllerTool alertControllerWithViewController:self title:@"" message:@"确定退出登录吗？" cancleTitle:@"取消" sureTitle:@"确定" cancleAction:^{
            
        } sureAction:^{
            
            [[UserManager currentUser] setIsLogin:@"0"];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }];
        return;
    }
    InfomationModel *model = self.dataArray[indexPath.row];
    switch (indexPath.row) {
        case 0:{
            [[CameraTakeMamanger sharedInstance] cameraSheetInController:self titleMessage:@"" handler:^(UIImage *image, NSString *imagePath) {
                model.info = imagePath;
                
                self.userModel.avatar = imagePath;
                [[UserManager currentUser] setUserInfo:[self.userModel mj_JSONString]];
                
                [self.tableView reloadData];
                
            }];
            break;
        }
        case 1:{
            
            NicknameViewController *nickVC = [NicknameViewController new];
            nickVC.model = model;
            WNNavigationController *nav = [[WNNavigationController alloc] initWithRootViewController:nickVC];
            [self presentViewController:nav animated:YES completion:nil];
            break;
        }
        case 2:{
            
            DatePickAlertView *dateAlertView = [DatePickAlertView new];
            [dateAlertView showDatePickerViewDelegate:self];
            break;
        }
        case 3:{
            
            [AlertControllerTool sheetControllerWithViewController:self title:@"男" otherTilte:@"女" titleAction:^{
                model.info = @"男";
                
                self.userModel.sex = model.info;
                [[UserManager currentUser] setUserInfo:[self.userModel mj_JSONString]];
                
                [self.tableView reloadData];
            } otherTilteAction:^{
                model.info = @"女";
               
                self.userModel.sex = model.info;
                [[UserManager currentUser] setUserInfo:[self.userModel mj_JSONString]];
                
                [self.tableView reloadData];
            }];
            break;
        }

    }

}

- (void)didSelectDate:(NSString *)date
{
    self.userModel.age = date;
    ((InfomationModel *)self.dataArray[2]).info = date;
    [[UserManager currentUser] setUserInfo:[self.userModel mj_JSONString]];
    
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        return adaptHeight1334(96);
    }
    return indexPath.row ? adaptHeight1334(96) : adaptHeight1334(168);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return adaptHeight1334(150);
    }
    return 0;
}

@end
