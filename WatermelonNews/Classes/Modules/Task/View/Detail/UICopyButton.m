//
//  UICopyButton.m
//  Store-Dev07
//
//  Created by 刘永杰 on 2017/6/14.
//  Copyright © 2017年 yoke121. All rights reserved.
//

#import "UICopyButton.h"

@implementation UICopyButton

-(BOOL)canBecomeFirstResponder
{
    return YES;
}

//绑定事件
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self attachPressHandler];
        
    }
    return self;
}
//同上
-(void)awakeFromNib
{
    [super awakeFromNib];
    [self attachPressHandler];
}



// 可以响应的方法(copy)
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    return (action == @selector(copy:));
}

//button添加长按手势
-(void)attachPressHandler
{
    self.userInteractionEnabled = YES;  //用户交互的总开关
    UILongPressGestureRecognizer *touch = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self addGestureRecognizer:touch];
}

-(void)handleTap:(UIGestureRecognizer*) recognizer
{
    
    [self becomeFirstResponder];
    self.backgroundColor = [UIColor lightGrayColor];
    
    //结束后出现复制
    if (recognizer.state == UIGestureRecognizerStateEnded) {

        [[UIMenuController sharedMenuController] setTargetRect:self.frame inView:self.superview];
        [[UIMenuController sharedMenuController] setMenuVisible:YES animated: YES];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismiss) name:@"UIMenuControllerDidHideMenuNotification" object:nil];
        
    }
}

- (void)dismiss{

    self.backgroundColor = [UIColor whiteColor];

}

-(void)copy:(id)sender
{
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    pboard.string = self.titleLabel.text;
    if (self.backResult) {
        
        self.backResult(0);
    }
}

@end
