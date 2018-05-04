//
//  EZFMDB.m
//  Kratos
//
//  Created by Zhangziqi on 3/29/16.
//  Copyright © 2016 lyq. All rights reserved.
//

#import "EZFMDB.h"

@implementation EZFMDBTableScheme

@end

@implementation EZFMDBColumnScheme

+ (EZFMDBColumnScheme *)schemeWithName:(NSString *)argName
                                  type:(EZFMDBColumnType)argType
                                 index:(EZFMDBColumnIndex)argIndex {
    EZFMDBColumnScheme *scheme = [[EZFMDBColumnScheme alloc] init];
    scheme.columnName = argName;
    scheme.columnType = argType;
    scheme.columnIndex = argIndex;
    return scheme;
}

@end

@implementation FMDatabase (EZFMDatabase)

- (void)createTable:(EZFMDBTableScheme *)argScheme {
    
    NSString *createTableSQL = [self createTableSql:argScheme];
    
    NSDictionary *existTable = [self findWithSql:@"select * from sqlite_master where type='table' and name=?",
                                argScheme.tableName];
    if (existTable == nil) {
        [self executeUpdate:createTableSQL];
    }
    else if (![existTable[@"sql"] isEqualToString:createTableSQL]) {
        [self executeUpdate:[NSString stringWithFormat:@"ALTER TABLE %@ RENAME TO tmp_%@",
                             argScheme.tableName,
                             argScheme.tableName]];
        [self executeUpdate:createTableSQL];
        NSArray *allData = [self selectWithSql:[NSString stringWithFormat:@"SELECT * FROM tmp_%@", argScheme.tableName]];
        NSString *insertSql = [self insertSql:argScheme];
        for (NSDictionary *dataItem in allData) {
            NSMutableDictionary *dataDictionary = [NSMutableDictionary dictionary];
            for (EZFMDBColumnScheme *columnItem in argScheme.columnScheme) {
                if (dataItem[columnItem.columnName] == nil) {
                    [dataDictionary setObject:@"" forKey:columnItem.columnName];
                }
                else {
                    [dataDictionary setObject:dataItem[columnItem.columnName] forKey:columnItem.columnName];
                }
            }
            [self executeUpdate:insertSql withParameterDictionary:dataDictionary];
        }
        [self executeUpdate:[NSString stringWithFormat:@"DROP TABLE tmp_%@",argScheme.tableName]];
    }
}

- (NSString *)createTableSql:(EZFMDBTableScheme *)argScheme {
    NSString *createTableSQL = @"";
    NSMutableArray *createColumnSQL = [NSMutableArray array];
    for (EZFMDBColumnScheme *columnItem in argScheme.columnScheme) {
        NSString *typeString;
        if (columnItem.columnType == EZFMDBColumnTypeInteger) {
            typeString = @" INTEGER";
        }
        else if (columnItem.columnType == EZFMDBColumnTypeText) {
            typeString = @" TEXT";
        }
        else if (columnItem.columnType == EZFMDBColumnTypeReal) {
            typeString = @" REAL";
        }
        else if (columnItem.columnType == EZFMDBColumnTypeBLOB) {
            typeString = @" BLOB";
        }
        else if (columnItem.columnType == EZFMDBColumnTypeNull) {
            typeString = @" NULL";
        }
        NSString *indexString = @"";
        if (columnItem.columnIndex == EZFMDBColumnIndexPrimaryKey) {
            indexString = @" PRIMARY KEY";
        }
        else if (columnItem.columnIndex == EZFMDBColumnIndexUnique) {
            indexString = @" UNIQUE";
        }
        [createColumnSQL addObject:[NSString stringWithFormat:@"%@%@%@",
                                    columnItem.columnName,
                                    typeString,
                                    indexString]];
    }
    createTableSQL = [NSString stringWithFormat:@"CREATE TABLE %@ (%@)",
                      argScheme.tableName,
                      [createColumnSQL componentsJoinedByString:@","]];
    return createTableSQL;
}

- (NSString *)insertSql:(EZFMDBTableScheme *)argScheme {
    NSMutableArray *columnString = [NSMutableArray array];
    for (EZFMDBColumnScheme *columnItem in argScheme.columnScheme) {
        [columnString addObject:[NSString stringWithFormat:@":%@", columnItem.columnName]];
    }
    return [NSString stringWithFormat:@"INSERT OR IGNORE INTO %@ (%@) VALUES (%@)",
            argScheme.tableName,
            [[columnString componentsJoinedByString:@","] stringByReplacingOccurrencesOfString:@":" withString:@""],
            [columnString componentsJoinedByString:@","]];
}

/**
 * 所有select方法都依赖此方法
 **/
- (NSArray *)selectWithSql:(NSString *)argSql withVAList:(va_list)args {
    NSMutableArray *resultArray = [NSMutableArray array];
    FMResultSet *rs = [self executeQuery:argSql withVAList:args];
    while ([rs next]) {
        [resultArray addObject:[rs resultDictionary]];
    }
    return [resultArray copy];
}

- (NSArray *)selectWithSql:(NSString *)argSql,... {
    va_list args;
    va_start(args, argSql);
    NSArray *result = [self selectWithSql:argSql withVAList:args];
    va_end(args);
    return [result copy];
}

- (NSDictionary *)findWithSql:(NSString *)argSql,... {
    va_list args;
    va_start(args, argSql);
    NSArray *result = [self selectWithSql:argSql withVAList:args];
    va_end(args);
    if (result != nil && [result count] > 0) {
        return [result firstObject];
    }
    else {
        return nil;
    }
}

- (void)selectWithCallback:(void (^)(NSArray *))argCallback withSql:(NSString *)argSql, ...{
    va_list args;
    va_start(args, argSql);
    NSArray *result = [self selectWithSql:argSql withVAList:args];
    va_end(args);
    if (argCallback != nil) {
        dispatch_async(dispatch_get_main_queue(), ^{
            argCallback(result);
        });
    }
}

- (void)selectWithCallbackOnQueryThread:(void (^)(NSArray *result, FMDatabase *db))argCallback
                                withSql:(NSString *)argSql, ... {
    va_list args;
    va_start(args, argSql);
    NSArray *result = [self selectWithSql:argSql withVAList:args];
    va_end(args);
    if (argCallback != nil) {
        argCallback(result, self);
    }
}

- (void)findWithCallback:(void (^)(NSDictionary *))argCallback withSql:(NSString *)argSql, ... {
    va_list args;
    va_start(args, argSql);
    NSArray *result = [self selectWithSql:argSql withVAList:args];
    va_end(args);
    if (argCallback != nil) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (result != nil && [result count] > 0) {
                argCallback([result firstObject]);
            }
            else {
                argCallback(nil);
            }
        });
    }
}

- (void)findWithCallbackOnQueryThread:(void (^)(NSDictionary *result, FMDatabase *db))argCallback
                              withSql:(NSString *)argSql, ... {
    va_list args;
    va_start(args, argSql);
    NSArray *result = [self selectWithSql:argSql withVAList:args];
    va_end(args);
    if (argCallback != nil) {
        if (result != nil && [result count] > 0) {
            argCallback([result firstObject], self);
        }
        else {
            argCallback(nil, self);
        }
    }
}

@end

@interface EZDatabaseQueue (){
    dispatch_queue_t _async_queue;
}

@property (strong, nonatomic) NSDictionary *queueBlock;

@end

@implementation EZDatabaseQueue

- (void)inDatabase:(void (^)(FMDatabase *db))block {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _async_queue = dispatch_queue_create([[NSString stringWithFormat:@"EZdb.%@", self] UTF8String], NULL);
    });
    dispatch_async(_async_queue, ^{
        [super inDatabase:block];
    });
}

- (void)inDatabaseRunOnMainThread:(void (^)(FMDatabase *))block {
    [super inDatabase:block];
}

@end

@implementation EZFMDB

/**
 * 返回指定数据库实例单例
 **/
+ (EZDatabaseQueue *)instanceWithPath:(NSString *)argPath {
    static NSMutableDictionary *pool;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        pool = [NSMutableDictionary dictionary];
    });
    if (pool[argPath] == nil) {
        NSString *newPath = argPath;
        if ([argPath rangeOfString:@"/var"].location > 0 && [argPath rangeOfString:@"/Users"].location > 0) {
            NSString *bundlePath = [[[NSBundle mainBundle] bundlePath] stringByReplacingOccurrencesOfString:[[[NSBundle mainBundle] bundlePath] lastPathComponent] withString:@""];
            newPath = [bundlePath stringByAppendingString:argPath];//补全包地址
        }
        EZDatabaseQueue *queueObject = [EZDatabaseQueue databaseQueueWithPath:newPath];
        if (queueObject != nil) {
            [pool setObject:queueObject forKey:argPath];
        }
    }
    return pool[argPath];
}

+ (EZDatabaseQueue *)defaultDatabase {
    return [EZFMDB instanceWithPath:@"tmp/EZDefault.sqlite"];
}

@end
