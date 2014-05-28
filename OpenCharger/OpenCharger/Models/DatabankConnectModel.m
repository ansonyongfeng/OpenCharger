//
//  DatabankConnectModel.m
//  LebenMap
//
//  Created by Ministry-MacMini on 05.09.13.
//  Copyright (c) 2013 He Yongfeng. All rights reserved.
//

#import "DatabankConnectModel.h"

@implementation DatabankConnectModel{
    sqlite3 *database;
    NSString *dbPath;
    sqlite3_stmt *statement;
    
}

-(void) openDb {
    // Den Pfad zur Documents-Directory in path speichern
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    dbPath = [documentsDirectory stringByAppendingPathComponent:@"opencharger.sqlite3"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // Die Datenbank aus dem Bundle in die Documents-Directory kopieren
    NSString *pathInMainBundle = [[NSBundle mainBundle] pathForResource:@"opencharger" ofType:@"sqlite3"];
    if (![fileManager fileExistsAtPath:dbPath]) {
        NSLog(@"Datenabnk noch nicht vorhanden");
        [fileManager copyItemAtPath:pathInMainBundle toPath:dbPath error:nil];
    }
    
    // Die Datenbank öffnen
    int result = sqlite3_open([dbPath UTF8String], &database);
    if (result != SQLITE_OK) {
        sqlite3_close(database);
        NSLog(@"Fehler beim Öffnen der Datenbank");
        return;
    }
    NSLog(@"Datenbank erfolgreich geöffnet");
}

-(void) closeDb {
    sqlite3_close(database);
    NSLog(@"Datenbank erfolgreich geschlossen");
}

-(NSMutableArray *) getItems:(NSString *)query {
    NSMutableArray *items = [[NSMutableArray alloc] init];
    const char *sql = [query UTF8String];
    if (sqlite3_prepare_v2(database, sql, -1, &statement, nil) == SQLITE_OK) {
        
        while (sqlite3_step(statement) == SQLITE_ROW) {
            NSString *OID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
            NSString *message = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
            NSString *entry = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
            NSString *power = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
            NSString *allday = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
            NSString *timing = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
            NSString *active = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
            
            NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys: OID, @"id", message, @"message", entry, @"entry", power, @"power", allday, @"allday", timing, @"timing", active, @"active", nil];
            [items addObject:dict];
        }
        sqlite3_finalize(statement);
    }
    return items;
}

-(NSMutableArray *) getSettingItems:(NSString *)query {
    NSMutableArray *items = [[NSMutableArray alloc] init];
    const char *sql = [query UTF8String];
    if (sqlite3_prepare_v2(database, sql, -1, &statement, nil) == SQLITE_OK) {
        
        while (sqlite3_step(statement) == SQLITE_ROW) {
            NSString *OID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
            NSString *uuid = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
            NSString *occode = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
            
            NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys: OID, @"id", uuid, @"uuid", occode, @"occode", nil];
            [items addObject:dict];
        }
        sqlite3_finalize(statement);
    }
    return items;
}

-(NSMutableArray *) getFavItems:(NSString *)query {
    NSMutableArray *items = [[NSMutableArray alloc] init];
    const char *sql = [query UTF8String];
    if (sqlite3_prepare_v2(database, sql, -1, &statement, nil) == SQLITE_OK) {
        
        while (sqlite3_step(statement) == SQLITE_ROW) {
            NSString *OID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
            NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys: OID, @"id", nil];
            [items addObject:dict];
        }
        
        sqlite3_finalize(statement);
    }
    
    return items;
}

-(void) insertItems: (NSString *) query {
    const char *sql = [query UTF8String];
    if (sqlite3_prepare_v2(database, sql, -1, &statement, nil) == SQLITE_OK) {
        if (sqlite3_step(statement)) {
            NSLog(@"insert true");
        }
        sqlite3_finalize(statement);
    }
    else{
        NSLog(@"insert false");
    }
}

-(void) deleteItems: (NSString *) query {
    const char *sql = [query UTF8String];
    if (sqlite3_prepare_v2(database, sql, -1, &statement, nil) == SQLITE_OK) {
        if (sqlite3_step(statement)) {
            NSLog(@"delete true");
        }
        sqlite3_finalize(statement);
    }
    else{
        NSLog(@"delete false");
    }
}

-(void) emptyTable:(NSString *)tableName{
    NSString *queryOne = [NSString stringWithFormat:@"DELETE FROM %@",tableName];
    NSString *queryTwo = [NSString stringWithFormat:@"VACUUM"];
    const char *sqlOne = [queryOne UTF8String];
    const char *sqlTwo = [queryTwo UTF8String];
    if (sqlite3_prepare_v2(database, sqlOne, -1, &statement, nil) == SQLITE_OK) {
        if (sqlite3_step(statement)) {
            if (sqlite3_prepare_v2(database, sqlTwo, -1, &statement, nil) == SQLITE_OK) {
                if (sqlite3_step(statement)) {
                    NSLog(@"empty true");
                }
                sqlite3_finalize(statement);
            }
        }
    }
    else{
        NSLog(@"empty false");
    }
}

-(void) updateItem: (NSString *) query {
    const char *sql = [query UTF8String];
    if (sqlite3_prepare_v2(database, sql, -1, &statement, nil) == SQLITE_OK) {
        if (sqlite3_step(statement)) {
            NSLog(@"updateItem true");
        }
        sqlite3_finalize(statement);
    }
    else{
        NSLog(@"updateItem false");
    }
}

@end
