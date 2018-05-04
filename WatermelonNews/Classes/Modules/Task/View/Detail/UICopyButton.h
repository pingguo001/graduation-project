//
//  UICopyButton.h
//  Store-Dev07
//
//  Created by 刘永杰 on 2017/6/14.
//  Copyright © 2017年 yoke121. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BackResult)(NSInteger);

@interface UICopyButton : UIButton

@property (copy, nonatomic) BackResult backResult;

@end
