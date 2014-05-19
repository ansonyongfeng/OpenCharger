//
//  DatabankConnectModel.h
//  LebenMap
//
//  Created by Ministry-MacMini on 05.09.13.
//  Copyright (c) 2013 He Yongfeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "sqlite3.h"

@interface DatabankConnectModel : NSObject

-(void) openDb;
-(void) closeDb;

-(void) insertItems:(NSString *)query;
-(void) emptyTable:(NSString *)tableName;
-(void) deleteItems:(NSString *)query;


-(NSMutableArray *) getItems:(NSString *)query;

@end
