//
//  AlertControllerTool.h
//  NationalRedPacket
//
//  Created by 刘永杰 on 2017/7/4.
//  Copyright © 2017年 孙明悦. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YJAlertViewController.h"

typedef void(^AlertBlcok)();
typedef void(^AlertBlcokResult)(id alertController);
typedef void(^AlertFieldBlock)(id alert);

@interface AlertControllerTool : NSObject

+ (void)alertControllerWithViewController:(UIViewController *)vc title:(NSString *)title message:(NSString *)message cancleTitle:(NSString *)cancleTitle sureTitle:(NSString *)sureTitle cancleAction:(AlertBlcok)cancleAction sureAction:(AlertBlcok)sureAction;

+ (void)sheetControllerWithViewController:(UIViewController *)vc title:(NSString *)title otherTilte:(NSString *)otherTitle titleAction:(AlertBlcok)titleAction otherTilteAction:(AlertBlcok)otherTilteAction;

+ (void)alertControllerWithTitle:(NSString *)title userNameTextField:(AlertFieldBlock)userNameTextField accountTextField:(AlertFieldBlock)accountTextField cancleAction:(AlertBlcokResult)cancleAction sureAction:(AlertBlcokResult)sureAction;

@end
