//
//  ZYSQLiteDBTool.m
//  sqlite3
//
//  Created by 臣陈 on 2017/12/13.
//  Copyright © 2017年 guidekj. All rights reserved.
//

#import "ZYSQLiteDBTool.h"

static ZYSQLiteDBTool *instance;

@interface ZYSQLiteDBTool()
/**
 *
 */
@property (nonatomic, assign) sqlite3 *db;
@end

@implementation ZYSQLiteDBTool

//单利
+ (instancetype)shareZYSQLiteDBTool{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ZYSQLiteDBTool alloc] init];
    });
    return instance;
}

//MARK: 插入/更新/删除数据记录
+ (void)executeSQLString:(NSString *)sqlStr failBlock:(void (^)(NSString *error))failBlock{
    __block sqlite3 *sqlDB;
    [self openDBWithDBName:nil successBlock:^(sqlite3 *DB) {
        sqlDB = DB;
    } failBlock:nil];
    sqlite3_stmt *statement = nil;
    const char *error = NULL;
    int result = sqlite3_prepare_v2(sqlDB, sqlStr.UTF8String, -1, &statement, &error);
    if (result == SQLITE_OK) {
        if (sqlite3_step(statement) == SQLITE_DONE) {
            NSLog(@"数据插入成功");
        }
    } else {
        failBlock([NSString stringWithUTF8String:(const char *)error]);
    }
    sqlite3_finalize(statement);
    [self closeDBWithFailBlock:nil];
}


//MARK: 删除数据表
+ (void)dropTableWithDBName:(NSString *)dbName sqlString:(NSString *)sqlStr failBlock:(void (^)(NSString *error))failBlock{
    
    if (dbName == nil) {
        dbName = @"DEFAULT.sqlite";
    }
    
    __block sqlite3 *sqlDB;
    [self openDBWithDBName:dbName successBlock:^(sqlite3 *DB) {
        sqlDB = DB;
    } failBlock:nil];
    char *error = NULL;
    int result = sqlite3_exec(sqlDB, sqlStr.UTF8String, NULL, NULL, &error);
    if (result == SQLITE_OK) {
        NSLog(@"删除数据库成功");
    } else {
        failBlock([NSString stringWithUTF8String:(const char *)error]);
    }
    [self closeDBWithFailBlock:nil];
}

//MARK: 创建数据表
+ (void)createTableWithDBName:(NSString *)dbName sqlString:(NSString *)sqlStr failBlock:(void (^)(NSString *error))failBlock {
    
    if (dbName == nil) {
        dbName = @"DEFAULT.sqlite";
    }
    
    __block sqlite3 *sqlDB;
    [self openDBWithDBName:dbName successBlock:^(sqlite3 *DB) {
        sqlDB = DB;
    } failBlock:nil];
    
    char *error = NULL;
    int result = sqlite3_exec(sqlDB, sqlStr.UTF8String, NULL, NULL, &error);
    if (result == SQLITE_OK) {
        NSLog(@"创建表成功");
    } else {
        NSLog(@"创建表失败");
        failBlock([NSString stringWithUTF8String:(const char *)error]);
    }
    [self closeDBWithFailBlock:nil];
}

//MARK: 打开数据库
+ (void)openDBWithDBName:(NSString *)dbName successBlock:(void (^)(sqlite3 *DB))successBlock  failBlock:(void (^)(NSString *error))failBlock{
    [[ZYSQLiteDBTool shareZYSQLiteDBTool] openDBWithDBName:dbName successBlock:^(sqlite3 *DB) {
        successBlock(DB);
    } failBlock:^(NSString *error) {
        failBlock(error);
    }];
}
- (void)openDBWithDBName:(NSString *)dbName successBlock:(void (^)(sqlite3 *DB))successBlock failBlock:(void (^)(NSString *error))failBlock{
    if (!_db) {
        NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *dbPath = [documentPath stringByAppendingPathComponent:dbName];
        NSLog(@"%@",dbPath);
        int result = sqlite3_open(dbPath.UTF8String, &_db);
        if (result == SQLITE_OK) {
            NSLog(@"数据库打开成功");
            successBlock(_db);
        } else {
            NSLog(@"数据库打开失败");
            failBlock([NSString stringWithUTF8String:sqlite3_errmsg(_db)]);
        }
    }
}

//MARK: 关闭数据库
+ (void)closeDBWithFailBlock:(void (^)(NSString *error))failBlock{
    [[ZYSQLiteDBTool shareZYSQLiteDBTool] closeDBWithFailBlock:^(NSString *error) {
        failBlock(error);
    }];
}
- (void)closeDBWithFailBlock:(void (^)(NSString *error))failBlock{
    int result = sqlite3_close(_db);
    if (result == SQLITE_OK) {
        NSLog(@"数据库关闭成功");
        _db = nil;
    } else {
        failBlock([NSString stringWithUTF8String:(const char *)sqlite3_errmsg]);
        NSLog(@"数据库关闭失败 = %@",[NSString stringWithUTF8String:(const char *)sqlite3_errmsg]);
    }
}

@end
