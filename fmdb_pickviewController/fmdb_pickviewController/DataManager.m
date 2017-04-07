//
//  DataManager.m
//  fmdb_pickviewController
//
//  Created by lcy on 16/4/7.
//  Copyright © 2016年 ZG. All rights reserved.
//

#import "DataManager.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "FMDatabaseQueue.h"
#import "ResidenceModel.h"
static FMDatabase * dataBase;

@implementation DataManager


/*
    1.单例模式可以保证系统中一个类只有一个实例而且该实例易于外界访问，从而方便对实例个数的控制并节约系统资源。
    2.多线程下的隐患 在多线程的情况下，如果两个线程几乎同时调用sharedInstance()方法会发生什么呢？有可能会创建出两个该类的实例。为了防止这种情况 我们通常会加上锁
    3.dispatch_once iOS 4.0 引进了 GCD ，其中的 **dispatchonce**，它即使是在多线程环境中也能安全地工作，非常安全。dispatchonce是用来确保指定的任务将在应用的生命周期期间，仅执行一次。以下是一个典型的源代码以初始化的东西。它可以优雅通过使用dispatch_once来创建一个单例。
 */


/*
 ================initialize方法===============

 Duck* duck1 = [[Duck alloc] init];
 
 Duck* duck2 = [[Duck alloc] init];
 
 Duck* duck3 = [[Duck alloc] init];
 
 控制台打印：
 2008-03-23 20:03:25.871 initialize_example[30253:10b] Duck initialize
 
 2008-03-23 20:03:25.872 initialize_example[30253:10b] Duck init
 
 2008-03-23 20:03:25.873 initialize_example[30253:10b] Duck init
 
 2008-03-23 20:03:25.873 initialize_example[30253:10b] Duck init
 我们可以看到，虽然我们创建了3个Duck的实例，但是initialize仅仅被调用了一次。
 
 ========================================
 Duck* duck1 = [[Duck alloc] init];
 Duck* duck2 = [[Duck alloc] init];
 Duck* duck3 = [[Duck alloc] init];
 //Chicken是duck的子类
 Chicken* chicken = [[Chicken alloc] init];
 
 控制台打印：
 2008-03-23 20:13:34.698 initialize_example[30408:10b] Duck initialize
 
 2008-03-23 20:13:34.699 initialize_example[30408:10b] Duck init
 
 2008-03-23 20:13:34.700 initialize_example[30408:10b] Duck init
 
 2008-03-23 20:13:34.700 initialize_example[30408:10b] Duck init
 
 2008-03-23 20:13:34.700 initialize_example[30408:10b] Duck initialize：class:Chicken
 
 2008-03-23 20:13:34.701 initialize_example[30408:10b] Duck init
 
 看来如果一个子类没有实现initialize方法，那么超类会调用这个方法两次，一次为自己，而一次为子类。
 
 ========================================
 如果你希望确定只用了initialize一次用来实现某些单独运行的工作（比如数据库的创建🔴）
 */

/*
 1.FMDB:
 (1)OC的方法封装SQLite的c语言的API,只适用于OC，跨平台不好
 (2)面向对象，轻量级，灵活
（3）多线程安全的数据库操作方法
 
 2.三个重要的类
 （1）FMDatabase
 一个FMDatabase对象就代表一个单独的SQLite数据库
 用来执行SQL语句
 
 （2）FMResultSet
 使用FMResultSet执行查询后的结果集
 
 （3）FMDatabaseQueue
 用于在多线程中执行多个查询或更新，它是线程安全的:
 FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:aPath];
 
 [queue inDatabase:^(FMDatabase *db) {
 [db executeUpdate:@"INSERT INTO myTable VALUES (?)", @1];
 [db executeUpdate:@"INSERT INTO myTable VALUES (?)", @2];
 [db executeUpdate:@"INSERT INTO myTable VALUES (?)", @3];
 
 FMResultSet *rs = [db executeQuery:@"select * from foo"];
 while ([rs next]) {
 …
 }
 }];
 
 
 */
#pragma mark // 创建单例对象
+ (id)sharedInstance
{
    static DataManager * manager = nil;
    // coding  dispatch ，选择dispath_once,即可以出来下面的代码块；
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        if (!manager) {
            manager = [[DataManager alloc] init];
        }
    });
    return  manager;
}


#pragma mark // 创建数据库
+(void)initialize{
    
    NSString * fileName = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject] stringByAppendingString:@"Residence.sqlite"];
    NSLog(@"🔴%@", fileName);
    dataBase = [FMDatabase databaseWithPath:fileName];
    [dataBase open];
    
    BOOL result = [dataBase executeUpdate:@"CREATE TABLE IF NOT EXISTS t_residence (ID integer PRIMARY KEY AUTOINCREMENT,residence text NOT NULL);"];
    
    if (result) {
        NSLog(@"创建表格成功");
    }
}

- (void)addResidence:(ResidenceModel*)residence{
    
    FMResultSet *rs =[dataBase executeQuery:@"SELECT COUNT(residence) AS countNum FROM t_residence WHERE residence = ?",residence.residence];
    while (rs.next)
    {
        NSInteger count = [rs intForColumn:@"countNum"];
        
        if (count > 0) {
            NSLog(@"已经存在");
        }
        else
        {
            //executeUpdateWithForamat：不确定的参数用%@，%d等来占位 （参数为原始数据类型，执行语句不区分大小写）
            [dataBase executeUpdateWithFormat:@"INSERT INTO t_residence(residence) VALUES (%@);", residence.residence];
        }
    }
}


- (void)deleteResidence:(ResidenceModel*)residence{
    FMResultSet *rs =[dataBase executeQuery:@"SELECT COUNT(residence) AS countNum FROM t_residence WHERE residence = ?",residence.residence];
    while (rs.next) {
        NSInteger count = [rs intForColumn:@"countNum"];
        
        if (count > 0) {
            //executeUpdateWithForamat：不确定的参数用%@，%d等来占位 （参数为原始数据类型，执行语句不区分大小写）
            [dataBase executeUpdateWithFormat:@"delete from t_residence where residence = %@;", residence.residence];
            NSLog(@"数据库有，可以执行删除");
        }
        else
        {
            NSLog(@"数据库没有，不能删除");
        }
    }
}

- (void)updateResidence:(ResidenceModel*)residence :(NSString*)newString{
    FMResultSet *rs =[dataBase executeQuery:@"SELECT COUNT(residence) AS countNum FROM t_residence WHERE residence = ?",residence.residence];
    while (rs.next) {
        NSInteger count = [rs intForColumn:@"countNum"];
        
        if (count > 0) {
            //executeUpdateWithForamat：不确定的参数用%@，%d等来占位 （参数为原始数据类型，执行语句不区分大小写）
            [dataBase executeUpdateWithFormat:@"update t_residence set residence = %@ where residence = %@", newString,residence.residence];
            NSLog(@"数据库有，可以执行修改");
        }
        else
        {
            NSLog(@"数据库没有，不能修改");
        }
        
        
    }
    
}

- (NSArray *)residenceArray{
    FMResultSet *set = [dataBase executeQuery:@"SELECT * FROM t_residence;"];
    NSMutableArray *residenceArray = [NSMutableArray array];
    while (set.next) {
        ResidenceModel * r = [[ResidenceModel alloc] init];
        r.residence = [set stringForColumn:@"residence"];
        [residenceArray addObject:r];
    }
    return residenceArray;
}





@end
