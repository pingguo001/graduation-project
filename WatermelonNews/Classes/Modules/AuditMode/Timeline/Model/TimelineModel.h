//
//  TimelineModel.h
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/11/7.
//  Copyright © 2017年 刘永杰. All rights reserved.
//
/*
{
    abstract = "\U73af\U987e\U56db\U5468\Uff0c\U8eab\U8fb9\U7684\U5973\U751f\U6709\U7740\U4e00\U5934\U4e4c\U9ed1\U7684\U957f\U53d1\Uff0c\U9f50\U5218\U6d77\Uff0c\U8d70\U5230\U54ea\U513f\U7537\U751f\U7684\U76ee\U5149\U8ddf\U5230\U54ea\U513f\U3002";
    category = hot;
    channel = "07d3fe79fb1a8f854ec930ef062b26a1.jpg";
    "comment_num" = 0;
    "comment_url" = "";
    content = "3689f223cb6c6508656fbdc49ad50609.html";
    cover = "[\"ddd0812d09edb214b167f8eeb17db1b3.jpg\",\"89134db9483a9c48535582754f3bab37.jpg\",\"108be3cf44c02cd6b7046c2e028161df.jpg\"]";
    "created_at" = "2017-11-07 18:14:47";
    id = 3056;
    "original_time" = "2017-09-18 01:34:17";
    "read_num" = 0;
    source = "http://121.42.10.73/APP/api.php?method=get_userinfo&uid=4028759887";
    "source_detail" = "\U5e74\U7cd5\U5988\U5988";
    status = 0;
    tag = 500078;
    title = "\U6709\U8fd9\U4e9b\U7279\U70b9\U7684\U5973\U751f\U9002\U5408\U7559\U957f\U53d1\Uff0c\U4f60\U6709\U5417\Uff1f";
    "updated_at" = "2017-11-07 18:14:47";
    url = "http://www.toutiao.com/a6466925631694176781/";
}
 */

#import <Foundation/Foundation.h>

@interface TimelineModel : NSObject

@property (copy, nonatomic) NSString *abstract;
@property (copy, nonatomic) NSString *category;
@property (copy, nonatomic) NSString *channel;
@property (copy, nonatomic) NSString *comment_num;
@property (copy, nonatomic) NSString *comment_url;
@property (copy, nonatomic) NSString *content;
@property (copy, nonatomic) NSString *cover;
@property (copy, nonatomic) NSString *ID;
@property (copy, nonatomic) NSString *original_time;
@property (copy, nonatomic) NSString *read_num;
@property (copy, nonatomic) NSString *source;
@property (copy, nonatomic) NSString *source_detail;
@property (copy, nonatomic) NSString *status;
@property (copy, nonatomic) NSString *tag;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *url;
@property (copy, nonatomic) NSString *updated_at;
@property (copy, nonatomic) NSString *praise_num;
@property (assign, nonatomic) BOOL is_praise;
@property (assign, nonatomic) BOOL is_myself;
@property (copy, nonatomic) NSString *transpond;


@end
