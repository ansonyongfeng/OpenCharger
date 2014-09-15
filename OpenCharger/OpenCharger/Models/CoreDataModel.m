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
    //NSLog(@"%@", dataDict);
    NSManagedObjectContext *context = [self managedObjectContext];
    //  1
    Messages *newEntry = [NSEntityDescription insertNewObjectForEntityForName:@"OCMessages" inManagedObjectContext:context];
    //get last and new message ID
    NSString *newMessageID = [[NSString alloc] init];
    NSArray *messagesRecordsArray = [self getAllMessageRecords];
    if ([messagesRecordsArray count] < 1) {
        newMessageID = @"1";
    }else{
        Messages *lastMessage = [messagesRecordsArray lastObject];
        NSString *lastMessageID = [[NSString alloc] init];
        lastMessageID   = lastMessage.id;
        newMessageID    = [NSString stringWithFormat:@"%d", [lastMessageID intValue] +1 ];
    }
    //  2
    newEntry.id         = newMessageID;
    newEntry.message    = [dataDict objectForKey:@"message"];
    newEntry.entry      = [dataDict objectForKey:@"entry"];
    newEntry.power      = [dataDict objectForKey:@"power"];
    newEntry.allday     = [dataDict objectForKey:@"allday"];
    newEntry.start      = [dataDict objectForKey:@"start"];
    newEntry.active     = [dataDict objectForKey:@"active"];
    //  3
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
}

-(void)updateData:(NSDictionary *)dataDict MessageID:(NSString *)thisMessageID{
    NSArray *fetchedRecordsArray = [self getAllMessageRecords];
    NSManagedObjectContext *context = [self managedObjectContext];
    for (int i = 0; i < [fetchedRecordsArray count]; i++)
    {
        Messages *message = [fetchedRecordsArray objectAtIndex:i];
        if ([message.id isEqual: thisMessageID]) {
            message.message    = [dataDict objectForKey:@"message"];
            message.entry      = [dataDict objectForKey:@"entry"];
            message.power      = [dataDict objectForKey:@"power"];
            message.allday     = [dataDict objectForKey:@"allday"];
            message.start      = [dataDict objectForKey:@"start"];
            message.active     = [dataDict objectForKey:@"active"];
        }
    }
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't update: %@", [error localizedDescription]);
    }
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
