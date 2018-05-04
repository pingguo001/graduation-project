//
//  PersionalView.m
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/11/7.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "PersionalView.h"

@interface PersionalView ()

@property (strong, nonatomic) UIImageView *headImageView;
@property (strong, nonatomic) UILabel     *nickNameLabel;
@property (strong, nonatomic) UIView      *backView;

@end

@implementation PersionalView

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
    self.image = [UIImage imageNamed:@"my_bg"];
    
    UIView *backView = [UIView new];
    backView.backgroundColor = [UIColor whiteColor];
    [self addSubview: backView];
    _backView = backView;
    
    self.headImageView = [UIImageView new];
    [self.backView addSubview:self.headImageView];
    self.headImageView.image = [UIImage imageNamed:@"my_default_avatar"];
    self.headImageView.userInteractionEnabled = YES;
    self.headImageView.layer.cornerRadius = adaptHeight1334(140)/2.0;
    self.headImageView.layer.masksToBounds = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonAction)];
    [self.headImageView addGestureRecognizer:tap];
    
    self.nickNameLabel = [UILabel labWithText:@"西瓜用户123456" fontSize:adaptFontSize(32) textColorString:COLOR060606];
    [self.backView addSubview:self.nickNameLabel];
    
    self.editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.editButton setTitle:@"编辑资料" forState:UIControlStateNormal];
    [self.editButton setTitleColor:[UIColor colorWithString:COLOR6CD4F5] forState:UIControlStateNormal];
    self.editButton.layer.borderColor = [UIColor colorWithString:COLOR6CD4F5].CGColor;
    self.editButton.layer.borderWidth = 1;
    self.editButton.layer.cornerRadius = 4;
    self.editButton.layer.masksToBounds = YES;
    self.editButton.titleLabel.font = [UIFont boldSystemFontOfSize:adaptFontSize(30)];
    [self.backView addSubview:self.editButton];
    
    
    UIView *lineView = [UIView new];
    lineView.backgroundColor = [UIColor colorWithString:COLORE1E1DF];
    [self.backView addSubview:lineView];
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo((kPersionalHeight)/2.5);
        
    }];
    
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.backView.mas_top);
        make.left.equalTo(self.backView).offset(adaptWidth750(30));
        make.height.width.mas_equalTo(adaptHeight1334(140));
        
    }];
    
    [self.nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.headImageView);
        make.top.equalTo(self.headImageView.mas_bottom).offset(adaptHeight1334(26));
        
    }];
    
    [self.editButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.backView).offset(adaptHeight1334(20));
        make.height.mas_equalTo(adaptHeight1334(55));
        make.width.mas_equalTo(adaptWidth750(160));
        make.right.equalTo(self.backView).offset(-adaptWidth750(30));
        
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.right.left.equalTo(self.backView);
        make.height.mas_equalTo(0.5);
        
    }];
    
}

- (void)configHeadImage:(NSString *)headImage
{
    if (headImage == nil || headImage.length == 0) {
        
        self.headImageView.image = [UIImage imageNamed:@"my_default_avatar"];
        
    } else {
        
        if ([headImage containsString:@"http:"] ||[headImage containsString:@"https:"] ) {
            [self.headImageView sd_setImageWithURL:[NSURL URLWithString:headImage] placeholderImage:[UIImage imageNamed:@"my_default_avatar"]];
            
        } else {
            
            self.headImageView.image = [UIImage imageWithContentsOfFile:headImage];
        }
    }
}

- (void)configNickname:(NSString *)nickname
{
    self.nickNameLabel.text = nickname;
}

- (void)buttonAction
{
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
