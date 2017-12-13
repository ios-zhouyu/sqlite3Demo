//
//  ZYSQLiteDBTool.h
//  sqlite3
//
//  Created by 臣陈 on 2017/12/13.
//  Copyright © 2017年 guidekj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface ZYSQLiteDBTool : NSObject


/** 一个APP拥有数据库即可,可以存放多张表
 插入/更新/删除数据记录

 @param sqlStr 执行的语句
 @param failBlock 失败的回调
 */
+ (void)executeSQLString:(NSString *)sqlStr failBlock:(void (^)(NSString *error))failBlock;


/**
 删除数据表

 @param dbName 数据库名称
 @param sqlStr 删除表的语句
 @param failBlock 失败的回调
 */
+ (void)dropTableWithDBName:(NSString *)dbName sqlString:(NSString *)sqlStr failBlock:(void (^)(NSString *error))failBlock;

/**
 创建数据表

 @param dbName 数据库名称 不传时默认是 DEFAULT.sqlite
 @param sqlStr 创建表的语句
 @param failBlock 失败的回调
 */
+ (void)createTableWithDBName:(NSString *)dbName sqlString:(NSString *)sqlStr failBlock:(void (^)(NSString *error))failBlock;

/**
 打开数据库

 @param dbName 数据库名称
 @param successBlock 成功的回调
 @param failBlock 失败的回调
 */
+ (void)openDBWithDBName:(NSString *)dbName successBlock:(void (^)(sqlite3 *DB))successBlock failBlock:(void (^)(NSString *error))failBlock;


/**
 关闭数据库

 @param failBlock 关闭失败的回调
 */
+ (void)closeDBWithFailBlock:(void (^)(NSString *error))failBlock;
@end
