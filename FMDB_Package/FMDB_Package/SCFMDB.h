//
//  SCFMDB.h
//  FMDB_Package
//
//  Created by tsc on 16/6/7.
//  Copyright © 2016年 tsc. All rights reserved.
//  注：里面只是常用的简单语句，复杂的语句没有封装,像union ,left join 等

#import <Foundation/Foundation.h>
#import "FMDB.h"

@interface SCFMDB : NSObject

/**
 *  创建单例
 *
 *  @return 返回单例对象
 */
+ (instancetype)sharedInstance;

/**
 *  初始化数据库
 *
 *  @param databaseName 数据库名称
 *
 *  @return 成功与否
 */
- (BOOL)initFMDB:(NSString *)databaseName;

/**
 *  利用表名和字段字符串创建数据表
 *
 *  @param tableName 表名
 *  @param fields    字段字典
 *
 *  @return 成功与否
 */

- (BOOL)createTable:(NSString *)tableName Fields:(NSMutableDictionary *) fields;

/**
 *  插入一条记录
 *
 *  @param tableName 表名
 *  @param dict    字段字典
 *
 *  @return 成功与否
 */
- (BOOL)insertRecord:(NSDictionary *)dict toTable:(NSString *)tableName;

/**
 *  更新记录
 *
 *  @param fields 要更改的字段和数值
 *  @param tableName    表名
 *  @param condition    筛选条件
 *
 *  @return 成功与否
 */
- (BOOL)updateFields:(NSDictionary *)fields toTable:(NSString *)tableName condition:(NSString *)condition;

/**
 *  删除记录
 *
 *  @param tableName 表名
 *  @param condition    删除条件
 *
 *  @return 成功与否
 */
- (BOOL)deleteRecord:(NSString *)condition fromTable:(NSString *)tableName;

/**
 *  查找记录或查找是否成功
 *
 *  @param table 表名
 *  @param condition  筛选条件
 *
 *  @return 查找的记录集
 */
- (FMResultSet *)queryRecord:(NSString *)condition inTable:(NSString *)tableName;

@end
