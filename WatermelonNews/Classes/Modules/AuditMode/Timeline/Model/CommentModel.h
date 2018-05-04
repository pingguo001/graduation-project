//
//  CommentModel.h
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/11/7.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 {
 "id": "2702",
 "up_id": "0",
 "item_id": "201",
 "item_type": "1",
 "from_user_id": "0",
 "to_user_id": "0",
 "avatar": "http://static-xigua.lingyongqian.cn/d47801a9b5b219db739bf32995621bd2.jpg",
 "nickname": "海阳",
 "status": "http://121.42.10.73/APP/api.php?method=get_userinfo&uid=1538658020",
 "content": "小时候我妈说，不好好读书就每天去啃门了，惊觉我妈的预言实现了！",
 "upvote_num": "18",
 "created_at": "2017-10-26 18:22:03",
 "updated_at": "2017-11-06 20:06:08"
 }
 */

@interface CommentModel : NSObject

@property (copy, nonatomic) NSString *commentId;
@property (copy, nonatomic) NSString *up_id;
@property (copy, nonatomic) NSString *item_id;
@property (copy, nonatomic) NSString *item_type;
@property (copy, nonatomic) NSString *from_user_id;
@property (copy, nonatomic) NSString *avatar;
@property (copy, nonatomic) NSString *nickname;
@property (copy, nonatomic) NSString *to_user_id;
@property (copy, nonatomic) NSString *status;
@property (copy, nonatomic) NSString *content;
@property (copy, nonatomic) NSString *upvote_num;
@property (copy, nonatomic) NSString *created_at;
@property (copy, nonatomic) NSString *updated_at;
@property (copy, nonatomic) NSString *praise_num;
@property (assign, nonatomic) BOOL is_praise;

@end
