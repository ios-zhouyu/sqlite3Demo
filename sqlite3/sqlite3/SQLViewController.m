
//
//  SQLViewController.m
//  sqlite3
//
//  Created by 臣陈 on 2017/12/13.
//  Copyright © 2017年 guidekj. All rights reserved.
//

#import "SQLViewController.h"
#import "ZYSQLiteDBTool.h"

// 监测打印的日志在对应文件的哪个位置的方法
#ifdef DEBUG
#define NSLog( s, ... ) printf("在文件: <%p %s:(第%d行) > 调用方法: %s \n%s\n", self, [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, __PRETTY_FUNCTION__, [[NSString stringWithFormat:(s), ##__VA_ARGS__] UTF8String] );
#else
#define NSLog( s, ... )
#endif

@interface SQLViewController ()

@end

@implementation SQLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"ZYSQLiteDBTool";
    
    [self demo4];
}

//删除数据
- (void)demo6{
    NSString *sqlStr = @"DELETE FROM EXPORT_PERSON WHERE NAME = 'sumit'";
    [ZYSQLiteDBTool deleteDataFromTableWithDBName:@"EXPORT.sqlite" sqlString:sqlStr failBlock:^(NSString *error) {
        NSLog(@"-------%@",error);
    }];
}

//更新数据
- (void)demo5{
    NSString *sqlStr = @"UPDATE EXPORT_PERSON SET DESCRIPTION = '喜欢运动,旅游' WHERE NAME = '周玉'";
    [ZYSQLiteDBTool updateDataSetTableWithDBName:@"EXPORT.sqlite" sqlString:sqlStr failBlock:^(NSString *error) {
        NSLog(@"-------%@",error);
    }];
}

//插入数据
- (void)demo4{
//    NSString *sqlStr = @"INSERT INTO EXPORT_PERSON (NAME , SEX , AGE , DESCRIPTION) VALUES('周玉','男',28,'开朗乐观')";
//    NSString *sqlStr = @"INSERT INTO EXPORT_PERSON (NAME , SEX , AGE , DESCRIPTION) VALUES('王鹏飞','女',27,'开朗乐观')";
//    NSString *sqlStr = @"INSERT INTO EXPORT_PERSON (NAME , SEX , AGE , DESCRIPTION) VALUES('李梅','女',20,'年轻可爱😊')";
    NSString *sqlStr = @"INSERT INTO EXPORT_PERSON (NAME , SEX , AGE , DESCRIPTION) VALUES('sumit','男',15,'小朋友的年纪')";
    [ZYSQLiteDBTool insertDataIntoTableWithDBName:@"EXPORT.sqlite" sqlString:sqlStr failBlock:^(NSString *error) {
        NSLog(@"-------%@",error);
    }];
}

//删除表
- (void)demo3{
    NSString *sqlStr = @"DROP TABLE EXPORT_PERSON";
    [ZYSQLiteDBTool dropTableWithDBName:@"EXPORT.sqlite" sqlString:sqlStr failBlock:^(NSString *error) {
        NSLog(@"--------%@",error);
    }];
}

//创建表
- (void)demo2{
    NSString *sqlStr = @"CREATE TABLE IF NOT EXISTS EXPORT_PERSON (ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, NAME TEXT, SEX TEXT, AGE INTEGER, DESCRIPTION TEXT);";
    [ZYSQLiteDBTool createTableWithDBName:@"EXPORT.sqlite" sqlString:sqlStr failBlock:^(NSString *error) {
        NSLog(@"%@",error);
    }];
}

//打开数据库
- (void)demo1{
    [ZYSQLiteDBTool openDBWithDBName:@"EXPORT.sqlite" successBlock:^(sqlite3 *DB) {
        NSLog(@"数据库打开成功");
    } failBlock:^(NSString *error) {
        NSLog(@"%@",error);
    }];
}


@end
