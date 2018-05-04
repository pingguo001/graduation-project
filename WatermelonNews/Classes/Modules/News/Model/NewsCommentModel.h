//
//  NewsCommentModel.h
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/11/16.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsCommentModel : NSObject

@property (copy, nonatomic) NSString *avatar;
@property (copy, nonatomic) NSString *content;
@property (copy, nonatomic) NSString *created_at;
@property (copy, nonatomic) NSString *upvote_num;
@property (copy, nonatomic) NSString *nickname;
@property (copy, nonatomic) NSString *comment_id;
@property (assign, nonatomic) BOOL   is_upvote;
@property (copy, nonatomic) NSString *source;

@end
