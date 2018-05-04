//
//  AlertTextView.h
//  Store-Dev07
//
//  Created by 刘永杰 on 2017/6/20.
//  Copyright © 2017年 yoke121. All rights reserved.
//

#import "BaseView.h"

@interface AlertTextView : BaseView

@property (strong, nonatomic) UILabel *placeHolder;
@property (assign, nonatomic) BOOL labelHidden;
@property (strong, nonatomic) UITextView *textView;
@property (strong, nonatomic) UILabel *showLabel;

@end
