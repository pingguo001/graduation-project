//
//  ElectricizeContentController.h
//  MakeMoney
//
//  Created by yedexiong on 2017/2/9.
//  Copyright © 2017年 yoke121. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    ChannelTypeFinance = 0, //理财
    ChannelTypeChuanYe,  //创业
    ChannelTypeJingGuan //经管
    
}ChannelType;

@interface ElectricizeContentController : UIViewController

-(instancetype)initWithChannelType:(ChannelType)type;

@end
