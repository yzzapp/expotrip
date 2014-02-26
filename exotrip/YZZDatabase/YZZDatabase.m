//
//  YZZDatabase.m
//  yzzdb
//
//  Created by 石戬,还没有对象的87姚勤 on 13-3-26.
//  Copyright (c) 2013年 YzzApp.com. All rights reserved.
//

#import "YZZDatabase.h"
#import <sqlite3.h>

@implementation YZZDatabase

+ (NSString *)dataFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString * fileFullPath = [documentsDirectory stringByAppendingPathComponent:YZZ_K_DB_FILE_NAME];
    if (![[NSFileManager defaultManager] fileExistsAtPath:fileFullPath]) {
        NSString * bundleDB = [[NSBundle mainBundle] pathForResource:YZZ_K_DB_IN_BUNDLE ofType:nil];
        [[NSFileManager defaultManager] copyItemAtPath:bundleDB toPath:fileFullPath error:nil];
    }
    return fileFullPath;
}

+ (sqlite3 *)openDB{
    sqlite3 *database;
    if (sqlite3_open([[self dataFilePath] UTF8String], &database)
        != SQLITE_OK) { sqlite3_close(database);
        NSAssert(0, @"Failed to open database");
    }
    return database;
}

+ (void)closeDB:(sqlite3 *)db {
    sqlite3_close(db);
}

+ (void) execSQL : (NSString *)sql{
    sqlite3 * database = [self openDB];
    char *errorMsg;
    if (sqlite3_exec (database, [sql UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK) {
        sqlite3_close(database);
        NSAssert(0, @"Error creating table: %s", errorMsg);
    }
    [self closeDB:database];
}

+ (NSMutableArray *) execSelect : (NSString *)sql{
    NSMutableArray * array = [[NSMutableArray alloc] init];
    sqlite3 * database = [self openDB];
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
            int count = sqlite3_column_count(statement);
            for (int i = 0; i<count; i++) {
                char * keyChars     = (char *)sqlite3_column_name(statement, i);
                char * valueChars   = (char *)sqlite3_column_text(statement, i);
                NSString * k        = [[NSString alloc] initWithUTF8String:keyChars];
                NSString * v        = [[NSString alloc] initWithUTF8String:valueChars];
                [dic setValue:v forKey:k];
            }
            [array addObject:dic];
        }
        sqlite3_finalize(statement);
    }
    [self closeDB:database];
    return array;
}

@end
