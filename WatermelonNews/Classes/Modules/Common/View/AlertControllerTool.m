//
//  AlertControllerTool.m
//  NationalRedPacket
//
//  Created by 刘永杰 on 2017/7/4.
//  Copyright © 2017年 孙明悦. All rights reserved.
//

#import "AlertControllerTool.h"

@implementation AlertControllerTool

+ (void)alertControllerWithViewController:(UIViewController *)vc title:(NSString *)title message:(NSString *)message cancleTitle:(NSString *)cancleTitle sureTitle:(NSString *)sureTitle cancleAction:(AlertBlcok)cancleAction sureAction:(AlertBlcok)sureAction
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    //修改title
    NSMutableAttributedString *alertControllerStr = [[NSMutableAttributedString alloc] initWithString:title];
    [alertControllerStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:adaptFontSize(36)] range:NSMakeRange(0, title.length)];
    [alert setValue:alertControllerStr forKey:@"attributedTitle"];
    
    //修改message
    NSMutableAttributedString *alertControllerMessageStr = [[NSMutableAttributedString alloc] initWithString:message];
    [alertControllerMessageStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:adaptFontSize(30)] range:NSMakeRange(0, message.length)];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    CGFloat specLine;
    if ([title isEqualToString:@"请确认兑换信息"]) {
        specLine = adaptHeight1334(30);
        paragraphStyle.alignment = NSTextAlignmentLeft;

    } else {
        specLine = adaptHeight1334(20);
        paragraphStyle.alignment = NSTextAlignmentCenter;

    }
    [paragraphStyle setLineSpacing:specLine];
    [alertControllerMessageStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(1, message.length-1)];

    [alert setValue:alertControllerMessageStr forKey:@"attributedMessage"];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:cancleTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        if (cancleAction) {
            cancleAction();
        }
    }];

    UIAlertAction *sure = [UIAlertAction actionWithTitle:sureTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    
        if (sureAction) {
            sureAction();
        }
        
    }];

    if (cancleTitle.length != 0){
        [alert addAction:cancel];
    }
    if (sureTitle.length != 0) {
        [alert addAction:sure];
    }
    
    [vc presentViewController:alert animated:YES completion:nil];
}

+ (void)sheetControllerWithViewController:(UIViewController *)vc title:(NSString *)title otherTilte:(NSString *)otherTitle titleAction:(AlertBlcok)titleAction otherTilteAction:(AlertBlcok)otherTilteAction
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        [vc dismissViewControllerAnimated:YES completion:^{
            
        }];
    }];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (titleAction) {
            titleAction(action.title);
        }
        
    }];
    UIAlertAction *action2= [UIAlertAction actionWithTitle:otherTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (otherTilteAction) {
            otherTilteAction(action.title);
        }
        
    }];
    
    [alert addAction:cancelAction];
    if (title.length != 0) {
        [alert addAction:action1];
    }
    if (otherTitle.length != 0) {
        [alert addAction:action2];
    }

    
    [vc presentViewController:alert animated:YES completion:nil];
}

+ (void)alertControllerWithTitle:(NSString *)title userNameTextField:(AlertFieldBlock)userNameTextField accountTextField:(AlertFieldBlock)accountTextField cancleAction:(AlertBlcokResult)cancleAction sureAction:(AlertBlcokResult)sureAction
{
    YJAlertViewController *alert = [YJAlertViewController alertControllerWithTitle:title message:@"请输入您的姓名和支付宝账号" subMessage:@"注意：支付宝账号必须有实名认证，否则支付宝公司会拒绝转账！" preferredStyle:YJAlertControllerStyleAlert];
    
    YJAlertAction *cancel = [YJAlertAction actionWithTitle:@"取消" style:YJAlertActionStyleCancel handler:^(YJAlertAction * _Nonnull action) {
        
    }];
    
    YJAlertAction *sure = [YJAlertAction actionWithTitle:@"确认" style:YJAlertActionStyleCancel handler:^(YJAlertAction * _Nonnull action) {
        
        if (sureAction) {
            sureAction(alert);
        }
        
    }];
    
    [alert addAction:cancel];
    [alert addAction:sure];
    
    [alert addTextFieldWithConfigurationHandler:^(AlertTextField * _Nonnull textField) {
        
        
        if (userNameTextField) {
            
            userNameTextField(textField);
        }
        
    }];
    [alert addTextFieldWithConfigurationHandler:^(AlertTextField * _Nonnull textField) {
        
        if (accountTextField) {
            
            accountTextField(textField);
        }
        
    }];
    
    [alert show];
}

@end
