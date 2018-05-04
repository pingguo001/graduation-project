//
//  DatePickAlertView.m
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/10/25.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "DatePickAlertView.h"

@interface DatePickAlertView ()<UIGestureRecognizerDelegate>

@property (strong, nonatomic) UIView *backView;
@property (weak, nonatomic) id<DatePickAlertViewDelegate>delegate;
@property (strong, nonatomic) UIDatePicker *datePicker;

@end

@implementation DatePickAlertView

- (void)p_setupViews
{
    self.frame = [UIScreen mainScreen].bounds;
    UIColor * color = [UIColor blackColor];
    self.backgroundColor = [color colorWithAlphaComponent:0.5];
    
    UIView *backView = [UIView new];
    backView.backgroundColor = [UIColor colorWithString:COLORF8F8F8];
    _backView = backView;
    _backView.userInteractionEnabled = YES;
    [self addSubview:backView];
    backView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, adaptHeight1334((46+216)*2));
    
    UIView *headView = [UIView new];
    [_backView addSubview:headView];
    headView.backgroundColor = [UIColor whiteColor];
    
    self.datePicker = [UIDatePicker new];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    self.datePicker.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_backView addSubview:self.datePicker];
    
    //设置显示格式
    //默认根据手机本地设置显示为中文还是其他语言
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置为中文显示
    self.datePicker.locale = locale;
    //设置属性
    self.datePicker.maximumDate = [NSDate date];
    
    
    UIButton *cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backView addSubview:cancleButton];
    [cancleButton setTitle:@"取消" forState:UIControlStateNormal];
    cancleButton.titleLabel.font = [UIFont systemFontOfSize:adaptFontSize(36)];
    [cancleButton setTitleColor:[UIColor colorWithString:COLOR999999] forState:UIControlStateNormal];
    [cancleButton setTitleColor:[UIColor colorWithString:COLOR999999] forState:UIControlStateHighlighted];
    [cancleButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backView addSubview:sureButton];
    [sureButton setTitle:@"完成" forState:UIControlStateNormal];
    sureButton.titleLabel.font = [UIFont systemFontOfSize:adaptFontSize(36)];
    [sureButton setTitleColor:[UIColor colorWithString:COLOR39AF34] forState:UIControlStateNormal];
    [sureButton setTitleColor:[UIColor colorWithString:COLOR39AF34] forState:UIControlStateHighlighted];
    [sureButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.top.equalTo(backView);
        make.height.mas_equalTo(adaptHeight1334(46*2));
        
    }];
    
    [cancleButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerY.equalTo(headView);
        make.left.equalTo(headView).offset(adaptWidth750(50));
        
    }];
    
    [sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headView);
        make.right.equalTo(headView).offset(-adaptWidth750(50));
    }];
    
    [self.datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(backView);
        make.top.equalTo(headView.mas_bottom);
        make.bottom.equalTo(backView);
        
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    self.userInteractionEnabled = YES;
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    
}


- (void)buttonAction:(UIButton *)sender
{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(didSelectDate:)]) {
        
        //NSDate格式转换为NSString格式
        NSDate *pickerDate = [self.datePicker date];// 获取用户通过UIDatePicker设置的日期和时间
        NSDateFormatter *pickerFormatter = [[NSDateFormatter alloc] init];// 创建一个日期格式器
        [pickerFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *dateString = [pickerFormatter stringFromDate:pickerDate];
        
        [self.delegate didSelectDate:dateString];
        [self dismiss];
    }
}

- (void)showDatePickerViewDelegate:(id<DatePickAlertViewDelegate>)delegate
{
    self.delegate = delegate;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.25 animations:^{
        
        self.backView.y = kScreenHeight - self.backView.height;
    }];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.25 animations:^{
        self.backView.y = kScreenHeight;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if ([touch.view isEqual:_backView]) {
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
