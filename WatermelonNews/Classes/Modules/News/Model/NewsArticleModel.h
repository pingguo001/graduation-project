//
//  NewsArticleModel.h
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/8/23.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
{
    "id": "1808",
    "created_at": "2017-08-17 14:37:49",
    "title": "中国乘客醉酒闹事自残 德国飞北京航班迫降莫斯科",
    "source": "参考消息网",
    "url": "http://139.129.162.59:8333/article/detail?id=1808",
    "comment_num": "1985",
    "cover": [
              "http://139.129.162.59:8333/pic/18cf0f1e53a0bb676743ba014c3430a7.jpg"
              ]
}
*/

@interface NewsArticleModel : NSObject

@property (copy, nonatomic) NSString *articleId;
@property (copy, nonatomic) NSString *encryptId; //加密id
@property (strong, nonatomic) NSString *created_at;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *source;
@property (copy, nonatomic) NSString *url;
@property (copy, nonatomic) NSString *video_url;
@property (copy, nonatomic) NSString *comment_num;
@property (strong, nonatomic) NSArray *cover;
@property (copy, nonatomic) NSString *type;
@property (assign, nonatomic) BOOL isRead;
@property (copy, nonatomic) NSString *category;
@property (copy, nonatomic) NSString *duration;
@property (copy, nonatomic) NSString *cover_image;

@end
