//
//  HotModel.h
//  MakeMoney
//
//  Created by yedexiong on 16/10/29.
//  Copyright © 2016年 yoke121. All rights reserved.
//  职位模型

#import <Foundation/Foundation.h>



@interface HotModel : NSObject

@property(nonatomic,copy)NSString *title;

@property(nonatomic,copy)NSString *date;

@property(nonatomic,copy)NSString *location;
//报酬
@property(nonatomic,copy)NSString *reward;
//浏览
@property(nonatomic,copy)NSString *browser;

@property(nonatomic,copy)NSString *hr_name;

@property(nonatomic,strong)NSNumber *hr_tel;
//雇佣人数
@property(nonatomic,copy)NSString *hire_count;

@property(nonatomic,copy)NSString *working_time;

@property(nonatomic,copy)NSString *job_description;

@property(nonatomic,copy)NSString *company_name;

//公司规模
@property(nonatomic,copy)NSString *corporate_size;

@property(nonatomic,copy)NSString *company_type;

//公司行业
@property(nonatomic,copy)NSString *industry;

@property(nonatomic,copy)NSString *company_address;

@property(nonatomic,copy)NSString *company_intro;

@property(nonatomic,copy)NSString *channel;

/***********************以下为辅助属性**************************************/

@property(nonatomic,copy)NSMutableAttributedString *price;
//图片名称
@property(nonatomic,copy)NSString *iconImageName;
//职位描述cell高度
@property(nonatomic,assign) CGFloat jopDesCellHeight;
//公司信息cell高度
@property(nonatomic,assign) CGFloat commpanyInfoCellHeight;

@end
