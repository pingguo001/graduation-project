//
//  SelectAlertView.h
//  NationalRedPacket
//
//  Created by 刘永杰 on 2017/7/31.
//  Copyright © 2017年 孙明悦. All rights reserved.
//

#import "BaseView.h"

@interface SelectAlertView : BaseView

/**
 弹出选择界面

 @param result 回调选择方式
 */
- (void)showAlertResult:(BackResult)result;

@end
