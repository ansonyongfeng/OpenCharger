//
//  CoreDataModel.m
//  OpenCharger
//
//  Created by Yongfeng on 14-8-17.
//  Copyright (c) 2014年 Yongfeng He. All rights reserved.
//

#import "CoreDataModel.h"
#import "Messages.h"

@implementation CoreDataModel

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;


-(NSArray*)getAllMessageRecords
{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    // initializing NSFetchRequest
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"OCMessages" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError* error;
    
    // Query on managedObjectContext With Generated fetchRequest
    NSArray *fetchedRecords = [context executeFetchRequest:fetchRequest error:&error];
    
    // Returning Fetched Records
    return fetchedRecords;
}

-(void)saveData: (NSDictionary *)dataDict{
    // Add Entry to PhoneBook Data base and reset all fields
    
    NSLog(@"%@", dataDict);
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    //  1
    Messages *newEntry = [NSEntityDescription insertNewObjectForEntityForName:@"OCMessages" inManagedObjectContext:context];
    //  2
    newEntry.message    = [dataDict objectForKey:@"message"];
    newEntry.entry      = [dataDict objectForKey:@"entry"];
    newEntry.power      = [dataDict objectForKey:@"power"];
    newEntry.allday     = [dataDict objectForKey:@"allday"];
    newEntry.start      = [dataDict objectForKey:@"start"];
    newEntry.active     = [dataDict objectForKey:@"active"];
    
    //  3
    NSError *error;
    if (![_managedObjectContext save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    
}

-(Messages *)getSingleMessageRecord:(NSManagedObjectID *)manageObjectID{
    NSLog(@"AAETVC MOID: %@", manageObjectID);
    NSArray *fetchedRecordsArray = [self getAllMessageRecords];
    for (int i = 0; i < [fetchedRecordsArray count]; i++)
    {
        
        Messages *message = [fetchedRecordsArray objectAtIndex:i];
        NSLog(@"message MOID: %@", [message objectID]);
        if ([message objectID] == manageObjectID) {
            return message;
        }
        return false;
    }
    return false;
}
    

/**********Core Data beginn************/
// 1
- (NSManagedObjectContext *) managedObjectContext {
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    return _managedObjectContext;
}

//2
- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    return _managedObjectModel;
}

//3
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    
    NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"coredata.sqlite"]];
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]
                                   initWithManagedObjectModel:[self managedObjectModel]];
    if(![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                  configuration:nil URL:storeUrl options:nil error:&error]) {
        /*Error for store creation should be handled in here*/
    }
    
    return _persistentStoreCoordinator;
}

- (NSString *)applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

@end
