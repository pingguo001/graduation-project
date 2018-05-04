//
//  HotModel.m
//  MakeMoney
//
//  Created by yedexiong on 16/10/29.
//  Copyright © 2016年 yoke121. All rights reserved.
//

#import "HotModel.h"
#import "NSString+TextSzie.h"


@implementation HotModel


-(NSMutableAttributedString *)price
{
    if (_price == nil) {
        if ([self.reward isEqualToString:@"面议"]) {
            return nil;
        }
     
        if (![self.reward containsString:@"/"]) {
            return nil;
        }
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.reward];
       
        NSRange range = [self.reward rangeOfString:@"/"];
        NSInteger count = self.reward.length -range.location;
        count += 1;
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(self.reward.length-count, count)];
        _price = str;
    }
    return _price;
}


-(NSString *)iconImageName
{
    if (_iconImageName == nil) {
        if ([self.channel isEqualToString:@"餐饮工"]) {
            _iconImageName = @"restaurant";
        }else if ([self.channel isEqualToString:@"传单派发"]){
            _iconImageName = @"leaflets";
        }else if ([self.channel isEqualToString:@"促销导购"]){
            _iconImageName = @"shopping_guide";
        }else if ([self.channel isEqualToString:@"服务员"]){
             _iconImageName = @"circle_friends";
        }else if ([self.channel isEqualToString:@"家教助教"]) {
            _iconImageName = @"tutor";
        }else if ([self.channel isEqualToString:@"话务客服"]){
            _iconImageName = @"customer_service";
        }else if ([self.channel isEqualToString:@"校园代理"]){
            _iconImageName = @"campua_agent";
        }else{
            _iconImageName = @"0ther";
        }
    }
    return _iconImageName;
}


-(CGFloat)jopDesCellHeight
{
    if (!_jopDesCellHeight) {
        
        //计算文字内容尺寸
        if (self.job_description.length) {
            CGFloat padding = 15;
            //内容label顶部固定高度
            CGFloat topHeight = 41;
           CGSize size = [self.job_description textSzieWithFont:[UIFont systemFontOfSize:16] andMaxSzie:CGSizeMake(kScreenWidth - 2*padding, MAXFLOAT)];
            
            _jopDesCellHeight = topHeight + size.height +10;
        }
    }
    
    return _jopDesCellHeight;
}

-(CGFloat)commpanyInfoCellHeight
{
    if (!_commpanyInfoCellHeight) {
        if (self.company_intro.length) {
            CGFloat padding = 15;
            //内容label顶部固定高度
            CGFloat topHeight = 201;
            //底部固定高度
            CGFloat bottomHeight = 30;
            //根据内容计算尺寸
            CGSize size = [self.company_intro textSzieWithFont:[UIFont systemFontOfSize:16] andMaxSzie:CGSizeMake(kScreenWidth - 2*padding, MAXFLOAT)];
            _commpanyInfoCellHeight = topHeight + size.height + bottomHeight;
        }else{
            _commpanyInfoCellHeight = 261;
        }
    }
   return  _commpanyInfoCellHeight;
}


@end
