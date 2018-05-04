//
//  ArticleDatabase.h
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/9/15.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewsArticleModel.h"

@interface ArticleDatabase : NSObject

+ (instancetype)sharedManager;

//移除磁盘中的文章数据
- (void)deleteArticleInfoFromDisk;

/*****************************  增  ****************************/

/**
 插入文章/视频

 @param model 文章模型
 */
- (BOOL)insertShowArticleModel:(NewsArticleModel *)model;

/*****************************  删  ****************************/

/**
 删除7天前的所有数据
 */
- (void)deleteOverdueArticle;


/*****************************  改  ****************************/

/**
 更新id已上传

 @param articleIds 上传过的id数组
 */
- (void)updateArticleIdDidUploadWithArticleIds:(NSArray *)articleIds;

/**
 更新id已读
 
 @param articleId 已读的id
 */
- (void)updateArticleIdDidReadWithArticleIds:(NSString *)articleId;

/*****************************  查  ****************************/

/**
 查询是否已读

 @param articleId 文章id
 @return 是否
 */
- (BOOL)queryAritcleIsRead:(NSString *)articleId;


/**
 查询未上传的所有数据

 @return 返回数据
 */
- (NSArray *)queryNoUploadAritcleWithCategory:(NSString *)category type:(NSString *)type;

/**
 查询读过的文章

 @return 展示
 */
- (NSArray *)queryDidReadAritcle;


@end
