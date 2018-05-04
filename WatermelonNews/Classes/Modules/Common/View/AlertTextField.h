//
//  AlertTextField.h
//  Store-Dev07
//
//  Created by 刘永杰 on 2017/6/19.
//  Copyright © 2017年 yoke121. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlertTextField : BaseView

@property (assign, nonatomic) BOOL labelHidden;
@property (strong, nonatomic) UITextField *textField;
@property (strong, nonatomic) UILabel *showLabel;

@end
