//
//  UserHeaderView.m
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/10/24.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "UserHeaderView.h"

@interface UserHeaderView ()

@property (strong, nonatomic) UIImageView *headImageView;
@property (strong, nonatomic) UILabel     *nickNameLabel;
@property (strong, nonatomic) UIButton    *settingButton;
@property (strong, nonatomic) UIView *backView;
@property (strong, nonatomic) UIView *loginView;

@end

@implementation UserHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self p_setupViews];
    }
    return self;
}

- (void)p_setupViews
{

    self.backgroundColor = [UIColor whiteColor];
    self.contentMode = UIViewContentModeScaleAspectFill;
    self.userInteractionEnabled = YES;
    
    UIView *backView = [UIView new];
    [self addSubview: backView];
    _backView = backView;
    _backView.hidden = YES;

    //登录View
    self.loginView = [[UIView alloc] init];
    [self addSubview:self.loginView];
    
    UIButton *wechatButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [wechatButton setBackgroundImage:[UIImage imageNamed:@"weixin"] forState:UIControlStateNormal];
    [wechatButton addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    wechatButton.tag = 101;
    [self.loginView addSubview:wechatButton];
    
    UIButton *qqButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [qqButton setBackgroundImage:[UIImage imageNamed:@"qq"] forState:UIControlStateNormal];
    [qqButton addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    qqButton.tag = 102;
    [self.loginView addSubview:qqButton];
    
    self.headImageView = [UIImageView new];
    [backView addSubview:self.headImageView];
    self.headImageView.image = [UIImage imageNamed:@"my_default_avatar"];
    self.headImageView.userInteractionEnabled = YES;
    self.headImageView.layer.cornerRadius = adaptHeight1334(140)/2.0;
    self.headImageView.layer.masksToBounds = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonAction)];
    [self.headImageView addGestureRecognizer:tap];
    
    self.nickNameLabel = [UILabel labWithText:@"西瓜用户123456" fontSize:adaptFontSize(32) textColorString:COLORFFFFFF];
    [backView addSubview:self.nickNameLabel];
    
    self.settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backView addSubview:self.settingButton];
    [self.settingButton setTitle:@"设置个人信息 >" forState:UIControlStateNormal];
    [self.settingButton addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    self.settingButton.titleLabel.font = [UIFont systemFontOfSize:adaptFontSize(28)];
    
    [self.loginView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(kImgHeight);
        
    }];
    
    [wechatButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.loginView);
        make.right.equalTo(self.loginView.mas_centerX).offset(-adaptWidth750(40));
        
    }];
    
    [qqButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.loginView);
        make.left.equalTo(self.loginView.mas_centerX).offset(adaptWidth750(40));
    }];
    
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(kImgHeight+64);
        
    }];
    
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backView);
        make.top.equalTo(backView).offset(adaptHeight1334(96));
        make.height.width.mas_equalTo(adaptHeight1334(140));
    }];
    
    [self.nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backView);
        make.top.equalTo(self.headImageView.mas_bottom).offset(adaptHeight1334(26));
    }];
    
    [self.settingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backView);
        make.top.equalTo(self.nickNameLabel.mas_bottom).offset(adaptHeight1334(16));
    }];
}

- (void)setUserIsLogin:(BOOL)isLogin
{
    self.backView.hidden = !isLogin;
    self.loginView.hidden = isLogin;
    self.image = [UIImage imageNamed:isLogin ? @"my_bg":@""];
    if (isLogin) {
        
        UserModel *model = [UserModel mj_objectWithKeyValues:[UserManager currentUser].userInfo];
        self.nickNameLabel.text = model.nickName;
        if (model.avatar == nil || model.avatar.length == 0) {
            
            self.headImageView.image = [UIImage imageNamed:@"my_default_avatar"];

        } else {
            
            if ([model.avatar containsString:@"http:"] ||[model.avatar containsString:@"https:"] ) {
                [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"my_default_avatar"]];
                
            } else {
                
                self.headImageView.image = [UIImage imageWithContentsOfFile:model.avatar];
            }

        }
    }

}

- (void)buttonAction
{
    if (self.buttonBlock) {
        self.buttonBlock(0);
    }
}

- (void)shareAction:(UIButton *)sender
{
    if (self.buttonBlock) {
        self.buttonBlock(sender.tag - 100);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
