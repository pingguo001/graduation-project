//
//  YJAlertViewController.m
//  Store-Dev07
//
//  Created by 刘永杰 on 2017/6/16.
//  Copyright © 2017年 yoke121. All rights reserved.
//

#import "YJAlertViewController.h"
#import "MJRefresh.h"

typedef void(^HandlerBlock)(YJAlertAction *action);

HandlerBlock _handler;

@implementation YJAlertAction

+ (instancetype)actionWithTitle:(nullable NSString *)title style:(YJAlertActionStyle)style handler:(void (^ __nullable)(YJAlertAction *action))handler
{
    YJAlertAction *action = [[YJAlertAction alloc] init];
    _handler = handler;
    [action setValue:title forKey:@"title"];
    return action;
}
@end

@implementation YJButton

@end

#pragma mark - YJAlertViewController

YJAlertViewController *_alertVC;
static NSString *_title;
static NSString *_message;
static NSString *_subMessage;
static NSInteger number;

@interface YJAlertViewController ()

@property (strong, nonatomic) UIView *backView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *subMessageLabel;

@end

@implementation YJAlertViewController

+ (instancetype)alertControllerWithTitle:(nullable NSString *)title message:(nullable NSString *)message subMessage:(nullable NSString *)subMessage preferredStyle:(YJAlertControllerStyle)preferredStyle
{
    _title = title;
    _message = message;
    _subMessage = subMessage;
    
    YJAlertViewController *alertVC = [[YJAlertViewController alloc] init];
    _alertVC = alertVC;
    alertVC.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    UIColor * color = [UIColor blackColor];
    alertVC.view.backgroundColor = [color colorWithAlphaComponent:0.4];

    [alertVC setupViews];
    number = 0;

    
    return alertVC;
}

- (void)setupViews
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [_alertVC.view addGestureRecognizer:tap];
    
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.cornerRadius = adaptHeight1334(20);
    backView.layer.masksToBounds = YES;
    [_alertVC.view addSubview:backView];
    _backView = backView;
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithString:COLORDCE3EB];
    [_backView addSubview:lineView];
    
    UIView *specView = [[UIView alloc] init];
    specView.backgroundColor = [UIColor colorWithString:COLORDCE3EB];

    [_backView addSubview:specView];
    
    UILabel *titleLabel = [self createLabelWithFontName:nil fontSize:adaptFontSize(38) colorStr:COLOR333333];
    titleLabel.font = [UIFont boldSystemFontOfSize:adaptFontSize(38)];
    titleLabel.text = _title;
    _titleLabel = titleLabel;
    [_backView addSubview:titleLabel];
    
    UILabel *messageLabel = [self createLabelWithFontName:nil fontSize:adaptFontSize(36) colorStr:COLOR666666];
    messageLabel.textAlignment = NSTextAlignmentLeft;
    messageLabel.text = _message;
    [_backView addSubview:messageLabel];
    
    UILabel *subMessaeLabel = [self createLabelWithFontName:nil fontSize:adaptFontSize(26) colorStr:COLORFF5A5D];
    subMessaeLabel.numberOfLines = 0;
    subMessaeLabel.text = _subMessage;
    subMessaeLabel.textAlignment = NSTextAlignmentLeft;
    _subMessageLabel = subMessaeLabel;
    [_backView addSubview:subMessaeLabel];
    
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.equalTo(self.view);
        make.width.mas_equalTo(kScreenWidth - adaptWidth750(100));
        if (_title.length == 0 && _subMessage.length == 0) {
            
            make.height.mas_equalTo(adaptHeight1334(150 + 90));
            
        } else if (_title.length != 0 && _message.length == 0) {
            
            make.height.mas_equalTo(adaptHeight1334(150 + 90));
            
        } else {
            
            make.height.mas_equalTo(adaptHeight1334(230 + 290));

        }
        
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(_backView);
        make.bottom.equalTo(_backView).offset(-adaptHeight1334(90));
        make.height.mas_equalTo(adaptHeight1334(1));
        
    }];
    
    [specView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(backView);
        make.top.equalTo(lineView.mas_bottom);
        make.width.mas_equalTo(adaptWidth750(1));
        make.bottom.equalTo(backView);
        
    }];
    
    
    if (_title.length == 0 && _subMessage.length == 0) {
        
        [messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(backView).offset(adaptWidth750(kSpecWidth));
            make.centerY.equalTo(backView).offset(-adaptHeight1334(45));
            
        }];
        
    } else if (_title.length != 0 && _message.length == 0) {
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.equalTo(backView);
            make.top.equalTo(backView).offset(adaptHeight1334(35));
            
        }];
        
    } else {
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.equalTo(backView);
            make.top.equalTo(backView).offset(adaptHeight1334(40));
            
        }];
        
        [messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(backView).offset(adaptWidth750(kSpecWidth));
            make.top.equalTo(titleLabel.mas_bottom).offset(adaptHeight1334(30));
            
        }];
        
        [subMessaeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(backView).offset(adaptWidth750(kSpecWidth));
            make.right.equalTo(backView).offset(-adaptWidth750(kSpecWidth));
            make.top.equalTo(messageLabel.mas_bottom).offset(adaptHeight1334(10));

        }];
        
        
    }
    
    
}

- (UILabel *)createLabelWithFontName:(NSString *)fontName fontSize:(NSInteger)fontSize colorStr:(NSString *)colorStr
{
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor colorWithString:colorStr];
    label.font = [UIFont systemFontOfSize:fontSize];
    return label;
}

- (void)addAction:(YJAlertAction *)action
{
    YJButton *button = [YJButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = [UIFont systemFontOfSize:adaptFontSize(34)];
    [button setTitle:action.title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithString:COLOR39AF34] forState:UIControlStateNormal];
    [_backView addSubview:button];
    button.action = action;
    if ([action.title isEqualToString:@"取消"]) {
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.bottom.equalTo(_backView);
            make.height.mas_equalTo(adaptHeight1334(90));
            make.width.mas_equalTo((kScreenWidth - adaptWidth750(100))/2 - adaptWidth750(0.5));
            
        }];
        
    } else if ([action.title isEqualToString:@"确认"] || [action.title isEqualToString:@"提交"] ){
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.bottom.equalTo(_backView);
            make.height.mas_equalTo(adaptHeight1334(90));
            make.width.mas_equalTo((kScreenWidth - adaptWidth750(100))/2 - adaptWidth750(0.5));
            
        }];
        
    } else {
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.right.bottom.equalTo(_backView);
            make.height.mas_equalTo(adaptHeight1334(90));
            
        }];
    }
    [self.view layoutIfNeeded];
    
    [button addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(button.width, button.height)] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithString:COLORF8F8F8] size:CGSizeMake(button.width, button.height)] forState:UIControlStateHighlighted];
 
}

- (void)addTextFieldWithConfigurationHandler:(void (^ __nullable)(AlertTextField *textField))configurationHandler
{
    number++;
    AlertTextField *alertTextField = [[AlertTextField alloc] init];
    [_backView addSubview:alertTextField];
    alertTextField.labelHidden = YES;
    
    [_backView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.center.equalTo(self.view);
        make.width.mas_equalTo(kScreenWidth - adaptWidth750(100));
        make.height.mas_equalTo(adaptHeight1334(130 + 250 + number * 130));
        
    }];
    
    [alertTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_subMessageLabel.mas_bottom).offset(adaptHeight1334((number - 1)*130 + 40));
        make.left.equalTo(_backView).offset(adaptWidth750(kSpecWidth));
        make.right.equalTo(_backView).offset(-adaptWidth750(kSpecWidth));
        make.height.mas_equalTo(adaptHeight1334(130));
        
    }];


    configurationHandler(alertTextField);
    
}

- (void)addTextViewWithConfigurationHandler:(void (^ __nullable)(AlertTextView *textView))configurationHandler
{
    AlertTextView *alertTextView = [[AlertTextView alloc] init];
    [_backView addSubview:alertTextView];
    alertTextView.labelHidden = YES;
    
    [_backView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.center.equalTo(self.view);
        make.width.mas_equalTo(kScreenWidth - adaptWidth750(100));
        make.height.mas_equalTo(adaptHeight1334(130 + 90 + 100 + 60 * 4 + 40));
        
    }];
    
    [alertTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_titleLabel.mas_bottom).offset(adaptHeight1334(100 + 40));
        make.left.equalTo(_backView).offset(adaptWidth750(kSpecWidth));
        make.right.equalTo(_backView).offset(-adaptWidth750(kSpecWidth));
        make.height.mas_equalTo(adaptHeight1334(60*4+40));
        
    }];
    
    configurationHandler(alertTextView);

    
}

- (void)show
{
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.view];
    [UIView animateWithDuration:0.5 animations:^{
        
        _backView.hidden = NO;

    }];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.view];
    self.backView.layer.position = self.view.center;
    self.backView.transform = CGAffineTransformMakeScale(1.20, 1.20);
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 options:UIViewAnimationOptionCurveLinear animations:^{
        
        self.backView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dismiss:(YJButton *)sender
{
    if (_handler && ![sender.action.title isEqualToString:@"取消"]) {
        _handler(sender.action);
        [self.view endEditing:YES];
    } else {
        
        [self.view removeFromSuperview];
    }
}

- (void)dismiss
{
    [self.view removeFromSuperview];
}

//实现当键盘出现的时候计算键盘的高度大小。用于输入框显示位置
- (void)keyboardWillShow:(NSNotification*)aNotification
{
    CGFloat curkeyBoardHeight = [[[aNotification userInfo] objectForKey:@"UIKeyboardBoundsUserInfoKey"] CGRectValue].size.height;
    CGRect begin = [[[aNotification userInfo] objectForKey:@"UIKeyboardFrameBeginUserInfoKey"] CGRectValue];
    CGRect end = [[[aNotification userInfo] objectForKey:@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    // 第三方键盘回调三次问题，监听仅执行最后一次
    if(begin.size.height>0 && (begin.origin.y-end.origin.y>0)){
        
        [UIView animateWithDuration:0.2f animations:^{
            
            self.view.mj_y = -(curkeyBoardHeight-(kScreenHeight-_backView.y - _backView.height -adaptHeight1334(10)));
        }];
        
    }
//    NSLog(@"%f", _backView.bottom);

}

//当键盘隐藏的时候
- (void)keyboardWillHidden:(NSNotification*)aNotification
{
    [UIView animateWithDuration:0.2f animations:^{
        
        self.view.mj_y = 0;

    }];
}

- (void)tapAction:(UITapGestureRecognizer *)tap
{
    [self.view endEditing:YES];
}

@end
