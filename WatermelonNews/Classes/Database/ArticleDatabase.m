//
//  ArticleDatabase.m
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/9/15.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "ArticleDatabase.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"

#define TABLE_CREATE         @"CREATE TABLE IF NOT EXISTS t_showArticle (articleId text PRIMARY KEY, read text, upload text, category text, type text, raw text,createtime text, readtime text);"

#define TABLE_INSERT         @"insert into t_showArticle (articleId, read,upload,category,type,raw,createtime,readtime) values ('%@', '%@', '%@','%@', '%@', '%@', '%@', '%@')"

#define TABLE_QUERY_ISREAD @"select * from t_showArticle where articleId = '%@' and read = '1'"

#define TABLE_QUERY_NOUPLOAD @"select * from t_showArticle where category = '%@' and upload = '0' and type = %@"

#define TABLE_QUERY_ISREADDATA @"select * from t_showArticle where read = '1' order by readtime desc"

#define TABLE_UPDATE_READ    @"update t_showArticle set read = '%@', readtime = '%@' where articleId = '%@'"

#define TABLE_UPDATE_UPLOAD  @"update t_showArticle set upload = '%@' where articleId = '%@'"

#define TABLE_DELETE_DAY @"delete from t_showArticle where date('now', '-7 day') >= date(createtime)"

@implementation ArticleDatabase
{
    FMDatabase *_db;
    NSString *_fileName;
}

+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    static ArticleDatabase *articleManage;
    dispatch_once(&onceToken, ^{
        articleManage = [ArticleDatabase new];
        [articleManage createShowArticleTable];
    });
    return articleManage;
}

//创建表
- (void)createShowArticleTable
{
    //获得数据库文件的路径
    NSString *doc =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES)[0];
    NSString *fileName = [doc stringByAppendingPathComponent:@"ShowArticle.sqlite"];
    WNLog(@"%@", fileName);
    _fileName = fileName;
    //获得数据库
    _db = [FMDatabase databaseWithPath:fileName];
    
    if ([_db open])
    {
        //创表
        BOOL result = [_db executeUpdate:TABLE_CREATE];
        if (result)
        {
            WNLog(@"创建表成功");
        }
    }
    [_db close];
    return;
}

//移除磁盘中的文章数据
- (void)deleteArticleInfoFromDisk
{
    //获得数据库文件的路径
    NSString *doc =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES)[0];
    NSString *fileName = [doc stringByAppendingPathComponent:@"ShowArticle.sqlite"];
    BOOL isHave = [[NSFileManager defaultManager] fileExistsAtPath:fileName];
    
    if (!isHave) {
        WNLog(@"没有本地文件");
        return ;
    }else {
        WNLog(@"有本地文件");
        BOOL isDelete = [[NSFileManager defaultManager]  removeItemAtPath:fileName error:nil];
        if (isDelete) {
            WNLog(@"本地信息删除成功");
        }else {
            WNLog(@"本地信息删除失败");
        }
    }
    [self createShowArticleTable];
}

/*****************************  增  ****************************/

/**
 插入文章
 
 @param model 文章模型
 */
- (BOOL)insertShowArticleModel:(NewsArticleModel *)model
{
    if ([_db open]){
        
        NSString *sql = [NSString stringWithFormat:TABLE_INSERT,model.articleId, @"0", @"0", model.category, model.type, [model mj_JSONString], model.created_at, @"0"];
        BOOL res = [_db executeUpdate:sql];
        
        [_db close];
        WNLog(@"插入结果:%d", res);
        return res;
    }
    WNLog(@"已插入或插入失败");
    return NO;
}

/*****************************  删  ****************************/

/**
 删除7天前的所有数据
 */
- (void)deleteOverdueArticle
{
    if ([_db open]) {
        BOOL res = [_db executeUpdate:TABLE_DELETE_DAY];
        WNLog(@"删除7天前：%d", res);
        [_db close];
    }
}


/*****************************  改  ****************************/

/**
 更新id已上传
 
 @param articleIds 上传过的id数组
 */
- (void)updateArticleIdDidUploadWithArticleIds:(NSArray *)articleIds
{
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:_fileName];
    
    for (NSString *articleId in articleIds) {
     
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [queue inDatabase:^(FMDatabase *db) {
                NSString *sql = [NSString stringWithFormat:TABLE_UPDATE_UPLOAD,@"1",articleId];
                BOOL res = [db executeUpdate:sql];
                WNLog(@"更新上传状态%d", res);
            }];
        });
    }
}

/**
 更新id已读
 
 @param articleId 已读的id
 */
- (void)updateArticleIdDidReadWithArticleIds:(NSString *)articleId
{
    if ([_db open]) {
        
        
        NSString *sql = [NSString stringWithFormat:TABLE_UPDATE_READ, @"1", [NSString stringWithFormat:@"%ld",time(0)], articleId];
        BOOL res = [_db executeUpdate:sql];
        WNLog(@"更新已读状态：%d", res);
        [_db close];
    }
}


/*****************************  查  ****************************/

/**
 查询是否已读
 
 @param articleId 文章id
 @return 是否
 */
- (BOOL)queryAritcleIsRead:(NSString *)articleId
{
    BOOL exist = FALSE;
    if([_db open]){

        NSString *sql = [NSString stringWithFormat:TABLE_QUERY_ISREAD,articleId];
        FMResultSet *result = [_db executeQuery:sql];
        while ([result next]) {
            exist = TRUE;
        }
    }
    [_db close];
    return exist;
}


/**
 查询未上传的所有文章/视频数据
 
 @return 返回数据
 */
- (NSArray *)queryNoUploadAritcleWithCategory:(NSString *)category type:(NSString *)type
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    if([_db open]){
        NSString *sql = [NSString stringWithFormat:TABLE_QUERY_NOUPLOAD,category, type];
        
        FMResultSet *result = [_db executeQuery:sql];
        while ([result next]) {
            [array addObject:@([[result stringForColumn:@"articleId"] integerValue])];
        }
    }
    [_db close];
    return array;
}

/**
 查询读过的文章
 
 @return 展示
 */
- (NSArray *)queryDidReadAritcle
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    if([_db open]){
        NSString *sql = TABLE_QUERY_ISREADDATA;
        
        FMResultSet *result = [_db executeQuery:sql];
        while ([result next]) {
            [array addObject:[result stringForColumn:@"raw"]];
            if (array.count == 10) {
                break;
            }
        }
    }
    [_db close];
    return array;
}

@end
