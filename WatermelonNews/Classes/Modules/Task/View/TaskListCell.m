//
//  TaskListCell.m
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/11/25.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "TaskListCell.h"
#import "TaskAdModel.h"
#import "CountDownTool.h"
#import "TaskAdManager.h"

@interface TaskListCell()

@property (strong, nonatomic) UIImageView *iconImageView; //icon
@property (strong, nonatomic) UILabel *appNameLabel;      //appname
@property (strong, nonatomic) UILabel *detailLabel;       //描述
@property (strong, nonatomic) UILabel *countdownLabel;    //countdown
@property (strong, nonatomic) UIButton *integralButton;   //integral
@property (strong, nonatomic) UILabel *numberLabel;
@property (strong, nonatomic) UILabel *registerLabel;
@property (strong, nonatomic) UILabel *signLabel;

@end

@implementation TaskListCell

- (void)p_setupViews
{
    
    self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];//这句不可省略
    self.selectedBackgroundView.backgroundColor = [UIColor colorWithString:COLORF9F8F5];
    //icon
    UIImageView *iconImageView = [[UIImageView alloc] init];
    iconImageView.layer.cornerRadius = adaptWidth750(10);
    iconImageView.layer.masksToBounds = YES;
    _iconImageView = iconImageView;
    [self.contentView addSubview:iconImageView];
    
    //name
    _appNameLabel = [UILabel labWithText:@"" fontSize:adaptFontSize(30) textColorString:COLOR333333];
    [self.contentView addSubview:_appNameLabel];
    
    _detailLabel = [UILabel labWithText:@"邀请好友送2元" fontSize:adaptFontSize(26) textColorString:COLORA9A9A9];
    [self.contentView addSubview:_detailLabel];
    
    //integral
    UIButton *integralButton = [UIButton buttonWithType:UIButtonTypeCustom];
    integralButton.titleLabel.font = [UIFont systemFontOfSize:adaptFontSize(28)];
    [integralButton setTitle:@"送***元" forState:UIControlStateNormal];
    [integralButton setBackgroundImage:[UIImage imageNamed:@"but_gre"] forState:UIControlStateNormal];
    [integralButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _integralButton = integralButton;
    _integralButton.userInteractionEnabled = NO;
    [self.contentView addSubview:_integralButton];
    [self setIntegralData:_integralButton.titleLabel.text];
    
    _countdownLabel = [UILabel labWithText:@"" fontSize:adaptNormalHeight1334(28) textColorString:COLOR060606];
    [self.contentView addSubview:_countdownLabel];
    _countdownLabel.textAlignment = NSTextAlignmentLeft;
    _countdownLabel.textColor = [UIColor redColor];
    
    //line
    UIView *lineView = [UIView new];
    lineView.backgroundColor = [UIColor colorWithString:COLORE1E1DF];
    lineView.hidden = YES;
    [self.contentView addSubview:lineView];
    
    //number
    for (int i = 0; i < 3; i++) {
        UILabel *taskLabel = [UILabel labWithText:@"测试一下" fontSize:adaptFontSize(22) textColorString:COLORA9A9A9];
        taskLabel.textAlignment = NSTextAlignmentCenter;
        taskLabel.layer.borderColor = [UIColor colorWithString:COLORA9A9A9].CGColor;
        taskLabel.layer.borderWidth = adaptWidth750(1);
        taskLabel.layer.cornerRadius = adaptWidth750(5);
        taskLabel.tag = 400+i;
        [self.contentView addSubview:taskLabel];
        [taskLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(_appNameLabel);
            make.bottom.equalTo(iconImageView).offset(-adaptHeight1334(4));
            make.height.mas_equalTo(adaptHeight1334(34));
            make.width.mas_equalTo(taskLabel.mj_textWith + adaptWidth750(20));
        }];
        
    }
    self.numberLabel = [self.contentView viewWithTag:400];
    self.registerLabel = [self.contentView viewWithTag:401];
    self.signLabel = [self.contentView viewWithTag:402];
    
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(adaptWidth750(kSpecWidth));
        make.width.height.mas_equalTo(adaptHeight1334(90));
        make.centerY.equalTo(self);
        
    }];
    
    [_appNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(iconImageView.mas_right).offset(adaptWidth750(20));
        make.top.equalTo(iconImageView).offset(adaptHeight1334(6));
        
    }];
    
    [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_appNameLabel);
        make.bottom.equalTo(iconImageView).offset(-adaptHeight1334(4));
        
    }];
    
    [_countdownLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(_appNameLabel);
        make.left.equalTo(_appNameLabel.mas_right).offset(adaptWidth750(10));
        
    }];
    
    [_integralButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self).offset(-adaptWidth750(30));
        make.centerY.equalTo(self);
        make.height.mas_equalTo(adaptHeight1334(54));
        make.width.mas_equalTo(_integralButton.titleLabel.mj_textWith + adaptWidth750(40));
        
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.right.equalTo(self);
        make.left.equalTo(_appNameLabel);
        make.height.mas_equalTo(0.5);
        
    }];
    
}

- (void)configModelData:(TaskAdModel *)model indexPath:(NSIndexPath *)indexPath;
{
    _appNameLabel.text = model.keyword;
    [self setCellStatus:model];
    [self setInviteModel:model];
    [self setTaskLabel:model];
    [self setTaskStep:model];
}

//富文本
- (void)setIntegralData:(NSString *)str
{
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:str];
    [attributeString setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:adaptFontSize(24)]} range:NSMakeRange(0, 1)];
    [attributeString setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:adaptFontSize(24)]} range:NSMakeRange(str.length - 1, 1)];
    [_integralButton setAttributedTitle:attributeString forState:UIControlStateNormal];
    
    [_integralButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self).offset(-adaptWidth750(30));
        make.centerY.equalTo(self);
        make.height.mas_equalTo(adaptHeight1334(54));
        make.width.mas_equalTo(_integralButton.titleLabel.mj_textWith + adaptWidth750(40));
        
    }];
}

//标签
- (void)setTaskLabel:(TaskAdModel *)model
{
    self.numberLabel.text = [NSString stringWithFormat:@"剩余%@份", model.left_num];
    
    [self.numberLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_appNameLabel);
        make.bottom.equalTo(_iconImageView).offset(-adaptHeight1334(4));
        make.height.mas_equalTo(adaptHeight1334(34));
        make.width.mas_equalTo(self.numberLabel.mj_textWith + adaptWidth750(20));
    }];
    
    if ([model.status isEqualToString:@"UNAVAILABLE"]) {
        self.registerLabel.hidden = YES;
        self.signLabel.hidden = YES;
        self.numberLabel.text = @"剩余0份";
        
    } else if ([model.status isEqualToString:@"PENDING"]) {

        self.registerLabel.hidden = NO;
        self.signLabel.hidden = YES;
        
        self.registerLabel.text = model.start_time;
        
        [self.registerLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_appNameLabel);
            make.bottom.equalTo(_iconImageView).offset(-adaptHeight1334(4));
            make.height.mas_equalTo(adaptHeight1334(34));
            make.width.mas_equalTo(self.registerLabel.mj_textWith + adaptWidth750(20));
        }];
        
        
        [self.numberLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(_appNameLabel).offset(self.registerLabel.mj_textWith + adaptWidth750(30));
            make.bottom.equalTo(self.registerLabel);
            make.height.mas_equalTo(adaptHeight1334(34));
            make.width.mas_equalTo(self.numberLabel.mj_textWith + adaptWidth750(20));
            
        }];
        
    } else if ([model.status isEqualToString:@"AVAILABLE"]){
        
        if ([model.tags.firstObject length] != 0) {
            if (model.tags.count == 1) {
                self.registerLabel.hidden = NO;
                self.signLabel.hidden = YES;
                self.registerLabel.text = model.tags.firstObject;
                
                [self.registerLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                    
                    make.left.equalTo(self.numberLabel.mas_right).offset(adaptWidth750(10));
                    make.bottom.equalTo(self.numberLabel);
                    make.height.mas_equalTo(adaptHeight1334(34));
                    make.width.mas_equalTo(self.registerLabel.mj_textWith + adaptWidth750(20));
                    
                }];
                
            } else if (model.tags.count == 2){
                self.registerLabel.hidden = NO;
                self.signLabel.hidden = NO;
                self.registerLabel.text = model.tags.firstObject;
                self.signLabel.text = model.tags.lastObject;
                
                [self.registerLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                    
                    make.left.equalTo(self.numberLabel.mas_right).offset(adaptWidth750(10));
                    make.bottom.equalTo(self.numberLabel);
                    make.height.mas_equalTo(adaptHeight1334(34));
                    make.width.mas_equalTo(self.registerLabel.mj_textWith + adaptWidth750(20));
                    
                }];
                
                [self.signLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                    
                    make.left.equalTo(self.registerLabel.mas_right).offset(adaptWidth750(10));
                    make.bottom.equalTo(self.numberLabel);
                    make.height.mas_equalTo(adaptHeight1334(34));
                    make.width.mas_equalTo(self.signLabel.mj_textWith + adaptWidth750(20));
                    
                }];
                
            }
        } else {
            self.registerLabel.hidden = YES;
            self.signLabel.hidden = YES;
        }
    }
    [self setRegisterRedWithModel:model];
}
//标签颜色
- (void)setRegisterRedWithModel:(TaskAdModel *)model
{
    if ([model.status isEqualToString:@"AVAILABLE"]) {
        if (self.registerLabel.text.length != 0) {
            self.registerLabel.textColor = [UIColor redColor];
            self.registerLabel.layer.borderColor = [UIColor redColor].CGColor;
        }
        if (self.signLabel.text.length != 0) {
            self.signLabel.textColor = [UIColor redColor];
            self.signLabel.layer.borderColor = [UIColor redColor].CGColor;
        }
    } else {
        self.registerLabel.textColor = [UIColor colorWithString:COLORA9A9A9];
        self.registerLabel.layer.borderColor = [UIColor colorWithString:COLORA9A9A9].CGColor;
        
        self.signLabel.textColor = [UIColor colorWithString:COLORA9A9A9];
        self.signLabel.layer.borderColor = [UIColor colorWithString:COLORA9A9A9].CGColor;
    }
}

- (void)setCellStatus:(TaskAdModel *)model
{
    _appNameLabel.textColor = [UIColor colorWithString:[model.status isEqualToString:@"UNAVAILABLE"] ? COLORCCCCCC : COLOR333333];
    [_integralButton setBackgroundImage:[UIImage imageNamed:[model.status isEqualToString:@"UNAVAILABLE"] ? @"but_gray" : @"but_gre"] forState:UIControlStateNormal];
    _appNameLabel.text = [model.status isEqualToString:@"PENDING"] ? [self dealWithString:model.keyword] : model.keyword;
    
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:[UIImage imageNamed:@"withdraw_icon_wechat"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (!image) {
            image = [UIImage imageNamed:@"withdraw_icon_wechat"];
        }
        _iconImageView.image = [model.status isEqualToString:@"UNAVAILABLE"] ? [self grayImage:image] : image;
    }];
}

- (void)setInviteModel:(TaskAdModel *)model
{
    NSString *str;

    if ([model.status isEqualToString:@"INVITE"] || [model.status isEqualToString:@"SIGN"]) {
        self.numberLabel.hidden = YES;
        self.signLabel.hidden = YES;
        self.registerLabel.hidden = YES;
        self.detailLabel.hidden = NO;
        if ([model.status isEqualToString:@"INVITE"]) {
            str = [NSString stringWithFormat:@"送%.2f元",[[UserManager currentUser].inviteReward floatValue]];
            self.detailLabel.text = [NSString stringWithFormat:@"邀请成功%@",str];
            _iconImageView.image = [UIImage imageNamed:@"task_inv"];
        } else {
            self.detailLabel.text = model.guides;
            self.appNameLabel.text = model.name;
            str = [NSString stringWithFormat:@"送%.2f元",[model.money floatValue] * [[UserManager currentUser].signRatio floatValue]];
        }
        
    } else {
        self.numberLabel.hidden = NO;
        self.signLabel.hidden = NO;
        self.registerLabel.hidden = NO;
        self.detailLabel.hidden = YES;
        str = [NSString stringWithFormat:@"送%.2f元",[model.money floatValue] * [[UserManager currentUser].taskRatio floatValue]];
    }
    
    [self setIntegralData:str];
}

- (void)setTaskStep:(TaskAdModel *)model
{
    if ([model.status isEqualToString:@"AVAILABLE"] && ![model.step isEqualToString:@"NONE"]) {
        _countdownLabel.hidden = NO;
        _countdownLabel.text = [NSString stringWithFormat:@"%@%@秒",[self stepStrWithModel:model],model.time];
        [CountDownTool timeCountDown:_countdownLabel timeout:model.time.intValue timeoutAction:^(int time) {
            if(time <= 0) {
                _countdownLabel.hidden = YES;
                [TaskAdManager sharedManager].doingTask = nil;
            } else {
                _countdownLabel.text = [NSString stringWithFormat:@"%@%d秒",[self stepStrWithModel:model],time];
                model.time = [NSString stringWithFormat:@"%d", time];
            }
        }];
    } else {
        _countdownLabel.hidden = YES;
    }
}

- (NSString *)stepStrWithModel:(TaskAdModel *)model
{
    if ([model.step isEqualToString:@"WAIT_COPY"]) {
        return @"等待复制:";
    } else if ([model.step isEqualToString:@"WAIT_INSTALL"]) {
        return @"等待下载:";
    } else if ([model.step isEqualToString:@"WAIT_USE"]) {
        return @"等待体验:";
    }
    return @"";
}

- (NSString *)dealWithString:(NSString *)str
{
    NSString *doneStr = str;
    for (int i = 1; i < str.length; i++) {
        
       doneStr = [doneStr stringByReplacingCharactersInRange:NSMakeRange(i, 1) withString:@"*"];
    }
    return doneStr;
}

//UIImage:去色功能的实现（图片灰色显示）
- (UIImage*)grayImage:(UIImage*)sourceImage {
    int width = sourceImage.size.width;
    int height = sourceImage.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate (nil, width, height,8,0, colorSpace,kCGImageAlphaNone);
    CGColorSpaceRelease(colorSpace);
    if (context ==NULL) {
        return nil;
    }
    CGContextDrawImage(context,CGRectMake(0,0, width, height), sourceImage.CGImage);
    UIImage *grayImage = [UIImage imageWithCGImage:CGBitmapContextCreateImage(context)];
    CGContextRelease(context);
    return grayImage;
}

@end
