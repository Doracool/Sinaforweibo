//
//  DataBaseEngine.m
//  SoftLink
//
//  Created by qingyun on 16/1/28.
//  Copyright © 2016年 河南青云信息技术有限公司. All rights reserved.
//

#import "DataBaseEngine.h"
#import "NSString+Documents.h"
#import "FMDB.h"
#import "StatusModel.h"

#define KDbName @"status.db"
#define KTableName @"status"

static NSArray *statusColumns;
@implementation DataBaseEngine


+(void)initialize{
    if (self == [DataBaseEngine class]) {
        //将db文件copy到docunment
        [self copyFile2Documents];
        statusColumns = [self tableColumn:KTableName];
    }
}

+(void)copyFile2Documents{
    NSString *source = [[NSBundle mainBundle] pathForResource:@"status" ofType:@"db"];
    NSString *toPath = [NSString DocumentsFilePath:KDbName];
    
    NSError *error;
    //如果在document文件不存在才能copy
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:toPath]) {
        [fileManager copyItemAtPath:source toPath:toPath error:&error];
    }
    
}

//从数据库中查询数据
+(NSArray *)selectedStatuses
{
    //创建数据库对象
    FMDatabase *db = [FMDatabase databaseWithPath:[NSString DocumentsFilePath:KDbName]];
    [db open];
    
    NSString *sqlString = @"select * from status order by id desc limit 20";
    
    FMResultSet *resultSet = [db executeQuery:sqlString];
    
    NSMutableArray *statuses = [NSMutableArray array];
    
    while ([resultSet next]) {
        //将查询出的每一条记录，转化为一个字典
        NSDictionary *status = [resultSet resultDictionary];
        NSMutableDictionary *muStatus = [NSMutableDictionary dictionary];
        [status enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[NSData class]]) {
                obj = [NSKeyedUnarchiver unarchiveObjectWithData:obj];
            }
            if (![obj isKindOfClass:[NSNull class]]) {
                [muStatus setObject:obj forKey:key];
            }
        }];
        StatusModel *statusModel = [[StatusModel alloc] initWithDictionary:muStatus];
        
        [statuses addObject:statusModel];
    }
    return statuses;
}

//  保存网络上的数据
+(void)saveStatuses:(NSArray *)statuses
{
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[NSString DocumentsFilePath:KDbName]];
    //执行插入操作
    [queue inDatabase:^(FMDatabase *db) {
        [statuses enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *status = obj;
            //创建sql语句执行插入操作
            //查询出table的column 字典的所有字段 并且查询出子集
            
            NSArray *allKey = status.allKeys;
            
            //对比数组之间有没有相同的
            NSArray *contentKey = [self contentFromArray:allKey And:statusColumns];
            
            //根据主键 ,拼接sql语句
            NSString *sqlString = [self sqlStringWithColumn:contentKey];
            
            
            //筛选出要插入的字典,字典中值的类型 oc的对象 转换为二进制数据
            
            NSMutableDictionary *muStatus = [NSMutableDictionary dictionary];
            [status enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                //只保存要插入的key
                if ([contentKey containsObject:key]) {
                    //处理对象
                    if ([obj isKindOfClass:[NSArray class]] || [obj isKindOfClass:[NSDictionary class]]) {
                        obj = [NSKeyedArchiver archivedDataWithRootObject:obj];
                    }
                    //排除null对象
                    if (![contentKey isKindOfClass:[NSNull class]]) {
                        [muStatus setObject:obj forKey:key];
                    }
                }
            }];
            
            //执行插入
            [db executeUpdate:sqlString withParameterDictionary:muStatus];
            
        }];
    }];
}


+(NSArray *)tableColumn:(NSString *)tableName{
    //创建db
    FMDatabase *db = [FMDatabase databaseWithPath:[NSString DocumentsFilePath:KDbName]];
    [db open];
    //查询结果
    FMResultSet *resultSet = [db getTableSchema:tableName];
    
    //创建一个可变数组接受结果
    NSMutableArray *columns = [NSMutableArray array];
    while ([resultSet next]) {
        //从结果中去出字段的名字
        NSString *column = [resultSet objectForColumnName:@"name"];
        [columns addObject:column];
    }
    return columns;
}

+(NSArray *)contentFromArray:(NSArray *)array1 And:(NSArray *)array2{
    NSMutableArray *result = [NSMutableArray array];
    
    [array1 enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //是array中的对象,并且array2也包含有 则为两者共有的
        if ([array2 containsObject:obj]) {
            [result addObject:obj];
        }
    }];
    return result;
}

+(NSString *)sqlStringWithColumn:(NSArray *)columns
{
    //insert into tableName (a, b, c) values (:a, :b, :c)
    NSString *column = [columns componentsJoinedByString:@", "];
    
    NSString *value = [columns componentsJoinedByString:@", :"];
    value = [@":" stringByAppendingString:value];
    
    return [NSString stringWithFormat:@"insert into %@(%@) values(%@)",KTableName,column,value];
}
@end
