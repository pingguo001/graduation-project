//
//  DatePickAlertView.h
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/10/25.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "BaseView.h"

@protocol DatePickAlertViewDelegate <NSObject>

- (void)didSelectDate:(NSString *)date;

@end

@interface DatePickAlertView : BaseView

- (void)showDatePickerViewDelegate:(id<DatePickAlertViewDelegate>)delegate;

@end
