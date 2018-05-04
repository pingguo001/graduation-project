//
//  ConversationViewController.h
//  soosoa
//
//  Created by 刘永杰 on 2017/1/19.
//  Copyright © 2017年 liq. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>

@interface ConversationViewController : RCConversationViewController

@property (copy, nonatomic) NSString *avatar;
@property (copy, nonatomic) NSString *nickName;

@end
