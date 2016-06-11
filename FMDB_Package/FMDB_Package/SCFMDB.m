//
//  SCFMDB.m
//  FMDB_Package
//
//  Created by tsc on 16/6/7.
//  Copyright © 2016年 tsc. All rights reserved.
//

#import "SCFMDB.h"

#define DBFilePath ([NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) lastObject])

@interface SCFMDB ()

@property (nonatomic, strong) NSMutableDictionary *tables;

@end

@implementation SCFMDB

static SCFMDB *shareManager = nil;
static FMDatabase *_db = nil ;   //数据库对象

+ (instancetype)sharedInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareManager = [[SCFMDB alloc] init];
    });
    return shareManager;
}

- (BOOL)initFMDB:(NSString *)databaseName {
  
    NSString *filePath = [DBFilePath stringByAppendingPathComponent:databaseName];
    
    _db = [FMDatabase databaseWithPath:filePath];
    
    return !_db ? false:true;
}

- (BOOL)createTable:(NSString *)tableName Fields:(NSMutableDictionary *) fields {

    //非数字，非空（这里没有判断完全）
    assert(![tableName integerValue] && tableName);
    assert(fields && [fields count]);
    [self.tables setObject:fields forKey:tableName]; //表名<---->字段(名和类型)
    
    if ([_db open]) {

        NSMutableString *fieldString = [NSMutableString string];
        
        [fields enumerateKeysAndObjectsUsingBlock:^(NSArray * _Nonnull key, NSArray *  _Nonnull type, BOOL * _Nonnull stop) {
            
            [key enumerateObjectsUsingBlock:^(NSString *  _Nonnull key, NSUInteger idx, BOOL * _Nonnull stop) {
                [fieldString appendString:key];
                [fieldString appendString:@" "];
                
                [fieldString appendString:type[idx]];
                [fieldString appendString:@","];
                idx ++;
            }];
        }];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path = [paths objectAtIndex:0];
        NSLog(@"path:%@", path);
        
        fieldString = (NSMutableString *)[fieldString substringWithRange:NSMakeRange(0, fieldString.length -1)];
        
        NSString *SQL = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (%@);",tableName,fieldString];

        return [_db executeUpdate:SQL];
    }
    return false;
}

- (BOOL)insertRecord:(NSArray *)values toTable:(NSString *)tableName {
    
    NSDictionary *fieldAndStyle = self.tables[tableName];
    
    NSArray *keys = fieldAndStyle.allKeys;
    
    NSMutableString *keyString = [NSMutableString string];

    NSMutableString *valueString = [NSMutableString string];
    
    NSMutableString *placeHolderString = [NSMutableString string];
    
    __block NSInteger index = 0;
    [keys[0] enumerateObjectsUsingBlock:^(NSString *  _Nonnull key, NSUInteger idx, BOOL * _Nonnull stop) {
        
        //这里的主键索引 名是id（这里也未考虑全面）
        if (![key isEqualToString:@"id"]) {
            
            NSString *temp = [NSString stringWithFormat:@"'%@'",values[index]];
            [valueString appendString:temp];
            [valueString appendString:@","];
            
            [keyString appendString:key];
            [keyString appendString:@","];
            
            [placeHolderString appendString:@"?"];
            [placeHolderString appendString:@","];
            index ++;
        }
 
    }];
    
    valueString = (NSMutableString *)[valueString substringToIndex:valueString.length - 1];
    
    keyString = (NSMutableString *)[keyString substringToIndex:keyString.length - 1];
    
    placeHolderString = (NSMutableString *)[placeHolderString substringToIndex:placeHolderString.length - 1];

    NSString *SQL = [NSString stringWithFormat:@"INSERT INTO %@ (%@) VALUES (%@)",tableName,keyString,valueString];
    
    if ([_db open]) {
        return [_db executeUpdate:SQL,valueString];
    }
    else
        return false;

}

- (BOOL)updateFields:(NSDictionary *)fields toTable:(NSString *)tableName condition:(NSString *)condition {
   
    //非数字，非空（这里没有判断完全）
    assert(![tableName integerValue] && tableName);
    assert(fields && [fields count]);
    
    if ([_db open]) {
        
        NSDictionary *fieldAndType = self.tables[tableName];
        
        NSArray *keys = fieldAndType.allKeys[0];
        NSArray *types = fieldAndType.allValues[0];
        
        NSMutableString *setString = [NSMutableString string];
        
        [fields enumerateKeysAndObjectsUsingBlock:^(NSString *  _Nonnull key, NSString *  _Nonnull value, BOOL * _Nonnull stop) {
            
            NSInteger idx = [keys indexOfObject:key]; //查找在数组中是第几项
            NSString *temp = nil;
            //除了text类型要加引号之外，其它类型都不加
            if([types[idx] compare:@"text" options:NSCaseInsensitiveSearch])
            {
                temp = [NSString stringWithFormat:@"%@ = '%@' ",key,value];
            }
            else {
                temp = [NSString stringWithFormat:@"%@ = %@ ",key,value];
            }

            [setString appendString:temp];
            [setString appendString:@"AND "];
        }];
        
        setString = [NSMutableString stringWithString:[setString substringToIndex:setString.length - 4]];
        
        [setString appendString:@"where "];
        
        [setString appendString:condition];
        
        NSString *SQL = [NSString stringWithFormat:@"UPDATE %@ SET %@ ",tableName,setString];
        
        return [_db executeUpdate:SQL];
    }
    else
        return false;
}

- (BOOL)deleteRecord:(NSString *)condition fromTable:(NSString *)tableName {
    
    if ([_db open]) {
        
        NSString *SQL = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ ",tableName,condition];

        return [_db executeUpdate:SQL];
    }
    else
        return false;
    
    
}

- (FMResultSet *)queryRecord:(NSString *)condition inTable:(NSString *)tableName {
    
    if ([_db open]) {
        
        NSString *SQL = [NSString stringWithFormat:@"SELECT * FROM %@ where %@ ;",tableName,condition];
        
        return [_db executeQuery:SQL];
    }
    else
        return nil;
}

#pragma mark -- 懒加载

- (NSMutableDictionary *)tables {
    if (!_tables) {
        _tables = [NSMutableDictionary dictionary];
    }
    return _tables;
}

@end
