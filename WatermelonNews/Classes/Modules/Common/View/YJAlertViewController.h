//
//  YJAlertViewController.h
//  Store-Dev07
//
//  Created by 刘永杰 on 2017/6/16.
//  Copyright © 2017年 yoke121. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlertTextField.h"
#import "AlertTextView.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, YJAlertActionStyle) {
    YJAlertActionStyleDefault = 0,
    YJAlertActionStyleCancel,
    YJAlertActionStyleDestructive
};

typedef NS_ENUM(NSInteger, YJAlertControllerStyle) {
    YJAlertControllerStyleActionSheet = 0,
    YJAlertControllerStyleAlert
};

@interface YJAlertAction : NSObject

+ (instancetype)actionWithTitle:(nullable NSString *)title style:(YJAlertActionStyle)style handler:(void (^ __nullable)(YJAlertAction *action))handler;

@property (nullable, nonatomic, readonly) NSString *title;

@end


@interface YJButton : UIButton

@property (strong, nonatomic) YJAlertAction *action;

@end


@interface YJAlertViewController : UIViewController

+ (instancetype)alertControllerWithTitle:(nullable NSString *)title message:(nullable NSString *)message subMessage:(nullable NSString *)subMessage preferredStyle:(YJAlertControllerStyle)preferredStyle;

- (void)addAction:(YJAlertAction *)action;

- (void)addTextFieldWithConfigurationHandler:(void (^ __nullable)(AlertTextField *textField))configurationHandler;

- (void)addTextViewWithConfigurationHandler:(void (^ __nullable)(AlertTextView *textView))configurationHandler;


- (void)show;

- (void)dismiss;


@end

NS_ASSUME_NONNULL_END

