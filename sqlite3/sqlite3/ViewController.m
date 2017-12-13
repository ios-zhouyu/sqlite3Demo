//
//  ViewController.m
//  sqlite3
//
//  Created by 周玉 on 2017/12/13.
//  Copyright © 2017年 guidekj. All rights reserved.
//

#import "ViewController.h"
#import <sqlite3.h>

#define KUIScreenWidth [UIScreen mainScreen].bounds.size.width
#define KUIScreenHeight [UIScreen mainScreen].bounds.size.height

#define FILE_NAME @"saas.sqlite"
static sqlite3 *db = nil;

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
//{
//    sqlite3 *_db;
//}
/*
 *
 */
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"sqlite3";
    
    [self setUpUI];
    
    //DDB
//    [self openDB];
//    [self closeDB];
    
    //DDL
//    [self createTable];
//    [self dropTable];
    
    //DML
//    [self insertData];
//    [self updateData];
//    [self deleteData];
    
    //DQL
    [self queryData];
}

#pragma mark 查询
- (void)queryData{
    sqlite3 *newDB = [self openDB];
    sqlite3_stmt *statement = nil;
    NSString *sqlStr = @"SELECT * FROM SAAS_PERSON";
    int result = sqlite3_prepare_v2(newDB, sqlStr.UTF8String, -1, &statement, NULL);
    if (result == SQLITE_OK) {
        //遍历查询结果
        if (!(sqlite3_step(statement) == SQLITE_DONE)) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                int ID = sqlite3_column_int(statement, 0);
                const unsigned char *name = sqlite3_column_text(statement, 1);
                const unsigned char *sex = sqlite3_column_text(statement, 2);
                int age = sqlite3_column_int(statement, 3);
                const unsigned char *description = sqlite3_column_text(statement, 4);
                NSLog(@"ID = %d , name = %@ , sex = %@ , age = %d , description = %@",ID,[NSString stringWithUTF8String:(const char *)name],[NSString stringWithUTF8String:(const char *)sex],age,[NSString stringWithUTF8String:(const char *)description]);
            }
        } else {
            NSLog(@"查询语句完成");
        }
    } else {
        NSLog(@"查询语句不合法");
    }
    sqlite3_finalize(statement);
    [self closeDB];
}

#pragma mark 删除数据记录
- (void)deleteData{
    sqlite3 *newDB = [self openDB];
    sqlite3_stmt *statement = nil;
    NSString *sqlStr = @"DELETE FROM SAAS_PERSON WHERE NAME = '王鹏飞'";
    int result = sqlite3_prepare_v2(newDB, sqlStr.UTF8String, -1, &statement, NULL);
    if (result == SQLITE_OK) {
        if (sqlite3_step(statement) == SQLITE_DONE) {
            NSLog(@"删除操作完成");
        }
    } else {
        NSLog(@"删除操作不合法");
    }
    sqlite3_finalize(statement);
    [self closeDB];
}

#pragma mark 更新数据记录
- (void)updateData{
    sqlite3 *newDB = [self openDB];
    sqlite3_stmt *statement = nil;
    NSString *sqlStr = @"UPDATE SAAS_PERSON SET DESCRIPTION = '喜欢运动,旅游' WHERE NAME = '周玉'";
    int result = sqlite3_prepare_v2(newDB, sqlStr.UTF8String, -1, &statement, NULL);
    if (result == SQLITE_OK) {
        if (sqlite3_step(statement) == SQLITE_DONE) {
            NSLog(@"更新信息完成");
        }
    } else {
        //[logging] no such column: DESCRIPT (KEY拼写错误) --- 更新信息不合法
        NSLog(@"更新信息不合法");
    }
    sqlite3_finalize(statement);
    [self closeDB];
}

#pragma mark 新增数据记录
- (void)insertData{
    sqlite3 *newDB = [self openDB];
    sqlite3_stmt *statement = nil;
//    NSString *sqlStr = @"INSERT INTO SAAS_PERSON (NAME , SEX , AGE , DESCRIPTION) VALUES('周玉','男',28,'开朗乐观')";
//    NSString *sqlStr = @"INSERT INTO SAAS_PERSON (NAME , SEX , AGE , DESCRIPTION) VALUES('王鹏飞','女',27,'开朗乐观')";
//    NSString *sqlStr = @"INSERT INTO SAAS_PERSON (NAME , SEX , AGE , DESCRIPTION) VALUES('李梅','女',20,'年轻可爱😊')";
    NSString *sqlStr = @"INSERT INTO SAAS_PERSON (NAME , SEX , AGE , DESCRIPTION) VALUES('sumit','男',15,'小朋友的年纪')";
    //检验合法性
    int result = sqlite3_prepare_v2(newDB, sqlStr.UTF8String, -1, &statement, NULL);
    if (result == SQLITE_OK) {
        //判断语句执行完毕
        if (sqlite3_step(statement) == SQLITE_DONE) {
            NSLog(@"插入的信息完成");
        }
    } else {
        NSLog(@"插入的信息不合法");
    }
    
    sqlite3_finalize(statement);
    [self closeDB];
}

#pragma mark 创建表
- (void)createTable{
    sqlite3 *newDB = [self openDB];
    //    char *sql = "CREATE TABLE IF NOT EXISTS t_person (ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, NAME TEXT , SEX TEXT,AGE INTEGER,DESCRIPTION TEXT);";
    NSString *sqlStr = @"CREATE TABLE IF NOT EXISTS SAAS_PERSON (ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, NAME TEXT , SEX TEXT,AGE INTEGER,DESCRIPTION TEXT);";
    char *error = NULL;
    
    int result = sqlite3_exec(newDB, sqlStr.UTF8String, NULL, NULL, &error);
    if (result == SQLITE_OK) {
        NSLog(@"创建表成功");
    } else {
        NSLog(@"创建表失败 = %s",error);
    }
    [self closeDB];
}

#pragma mark 删除表
- (void)dropTable{
    sqlite3 *newDB = [self openDB];
    NSString *sqlStr = @"DROP TABLE t_person";
    char *error = NULL;
    int result = sqlite3_exec(newDB, sqlStr.UTF8String, NULL, NULL, &error);
    if (result == SQLITE_OK) {
        NSLog(@"删除表成功");
    } else {
        NSLog(@"删除表失败 = %s",error);
    }
    [self closeDB];
}

#pragma mark 打开或者创建数据库
- (sqlite3 *)openDB {
    if (!db) {
        //1.获取document文件夹的路径
        //参数1:文件夹的名字 参数2:查找域 参数3:是否使用绝对路径
        NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        //获取数据库文件的路径
        NSString *dbPath = [documentPath stringByAppendingPathComponent:@"saas.sqlite"];
        NSLog(@"%@",dbPath);
        //判断document中是否有sqlite文件
        int result = sqlite3_open([dbPath UTF8String], &db);
        if (result == SQLITE_OK) {
            NSLog(@"打开数据库");
            
        }else{
            [self closeDB];
            NSLog(@"打开数据库失败");
        }
    }
    return db;
}

#pragma mark 关闭数据库
- (void)closeDB{
    int result = sqlite3_close(db);
    if (result == SQLITE_OK) {
        NSLog(@"数据库关闭成功");
        db = nil;
    } else {
        NSLog(@"数据库关闭失败");
    }
}

#pragma mark tableView的数据源和代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)setUpUI {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KUIScreenWidth, KUIScreenHeight - 64) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

@end
