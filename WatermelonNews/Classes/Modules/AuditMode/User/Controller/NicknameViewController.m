//
//  NicknameViewController.m
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/10/25.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "NicknameViewController.h"

@interface NicknameViewController ()<UITextFieldDelegate>

@property (strong, nonatomic) UITextField *nickTextField;

@end

@implementation NicknameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithString:COLORF5F5F5];
    self.title = @"设置昵称";
    
    [self setupSubViews];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc ] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancleAction)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc ] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(sureAction)];

    
    // Do any additional setup after loading the view.
}

- (void)cancleAction
{
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)sureAction
{
    if (self.nickTextField.text.length == 0) {
        
        [MBProgressHUD showError:@"请输入昵称"];
        return;
    }
    [self.view endEditing:YES];
    UserModel *model = [UserModel mj_objectWithKeyValues: [UserManager currentUser].userInfo];
    model.nickName = self.nickTextField.text;
    
    self.model.info = model.nickName;
    [[UserManager currentUser] setUserInfo:[model mj_JSONString]];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setupSubViews
{
    UserModel *model = [UserModel mj_objectWithKeyValues: [UserManager currentUser].userInfo];
    
    self.nickTextField = [UITextField new];
    self.nickTextField.frame = CGRectMake(-0.5, adaptHeight1334(20)+64, kScreenWidth + 1, adaptHeight1334(96));
    [self.view addSubview:self.nickTextField];
    self.nickTextField.text = model.nickName;
    self.nickTextField.font = [UIFont systemFontOfSize:adaptFontSize(30)];
    self.nickTextField.backgroundColor = [UIColor whiteColor];
    self.nickTextField.delegate = self;
    self.nickTextField.layer.borderWidth = 0.5;
    self.nickTextField.layer.borderColor = [UIColor colorWithString:COLORCACACA].CGColor;
    self.nickTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, adaptWidth750(30), adaptHeight1334(80))];
    self.nickTextField.leftViewMode = UITextFieldViewModeAlways;

    self.nickTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.nickTextField.returnKeyType = UIReturnKeyDone;
    UIButton *clearButton = [self.nickTextField valueForKey:@"_clearButton"];
    [clearButton setImage:[UIImage imageNamed:@"edit_delete"] forState:UIControlStateNormal];
    [clearButton setImage:[UIImage imageNamed:@"edit_delete"] forState:UIControlStateHighlighted];

//    [self.nickTextField mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.left.equalTo(self.view).offset(-0.5);
//        make.right.equalTo(self.view).offset(0.5);
//        make.top.equalTo(self.view).offset(adaptHeight1334(20)+64);
//        make.height.mas_equalTo(adaptHeight1334(96));
//        
//    }];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.nickTextField becomeFirstResponder];
    });
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self sureAction];
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
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
