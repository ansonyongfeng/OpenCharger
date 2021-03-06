//
//  CoreDataModel.h
//  OpenCharger
//
//  Created by Yongfeng on 14-8-17.
//  Copyright (c) 2014年 Yongfeng He. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Messages.h"

@interface CoreDataModel : NSObject

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator ;

-(NSArray *)getAllMessageRecords;

-(void)saveData:(NSDictionary *)dataDict;
-(void)updateData:(NSDictionary *)dataDict MessageID:(NSString *)thisMessageID;
@end
