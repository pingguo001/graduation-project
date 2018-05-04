//
//  FMListModel.h
//  MakeMoney
//
//  Created by yedexiong on 2017/2/9.
//  Copyright © 2017年 yoke121. All rights reserved.
//  FM列表模型

#import <Foundation/Foundation.h>



@interface FMListModel : NSObject

@property(nonatomic,strong)NSNumber *Id;

@property(nonatomic,copy)NSString *title;

@property(nonatomic,copy)NSString *icon_url;

@property(nonatomic,copy)NSString *play_count;

@property(nonatomic,copy)NSString *brief;

@property(nonatomic,copy)NSString *intro;

//集数
@property(nonatomic,copy)NSString *episode_count;



@end
