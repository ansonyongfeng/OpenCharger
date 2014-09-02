//
//  CoreDataModel.h
//  OpenCharger
//
//  Created by Yongfeng on 14-8-17.
//  Copyright (c) 2014年 Yongfeng He. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreDataModel : NSObject

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator ;

-(NSArray *)getAllPhoneBookRecords;

@end
