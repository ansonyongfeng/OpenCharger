//
//  AppDelegate.m
//  OpenCharger
//
//  Created by YongfengHe on 28.05.14.
//  Copyright (c) 2014 Yongfeng He. All rights reserved.
//

#import "AppDelegate.h"
#import "DatabankConnectModel.h"

@implementation AppDelegate{
    CLLocationManager *locationManager;
    DatabankConnectModel        *DBCM;
    NSMutableArray              *objectsItemArray;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // This location manager will be used to notify the user of region state transitions.
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    
    // Override point for customization after application launch.
    return YES;
}

/*- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    NSMutableString *alertMessage = [[NSMutableString alloc] init];
    //databank
    DBCM = [[DatabankConnectModel alloc] init];
    [DBCM openDb];
    NSString *getItemsQuery = [NSString stringWithFormat:@"SELECT * FROM messages WHERE active = 1"];
    objectsItemArray = [DBCM getItems:getItemsQuery];
    [DBCM closeDb];
    
    [[UIDevice currentDevice] setBatteryMonitoringEnabled:YES];
    float batteryLevel = [[UIDevice currentDevice] batteryLevel];
    batteryLevel *= 100;
    
    // A user can transition in or out of a region while the application is not running.
    // When this happens CoreLocation will launch the application momentarily, call this delegate method
    // and we will let the user know via a local notification.
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    
    if(state == CLRegionStateInside)
    {
        alertMessage = [NSMutableString stringWithFormat:@"ni hao"];
         notification.alertBody = alertMessage;
         notification.soundName = UILocalNotificationDefaultSoundName;
        for (NSDictionary* key in objectsItemArray) {
            float thisPowerLevel = [[key objectForKey:@"power"] floatValue];
            NSString *thisAllDay = [key objectForKey:@"allday"];
            if ([[key objectForKey:@"entry"] isEqualToString:@"1"] && batteryLevel < thisPowerLevel) {
                
                if ([thisAllDay isEqualToString:@"1"]) {
                    alertMessage = [key objectForKey:@"message"];
                    notification.alertBody = alertMessage;
                    notification.soundName = UILocalNotificationDefaultSoundName;
                }
                
            }
        }
    }
    else if(state == CLRegionStateOutside)
    {
        for (NSDictionary* key in objectsItemArray) {
            float thisPowerLevel = [[key objectForKey:@"power"] floatValue];
            NSString *thisAllDay = [key objectForKey:@"allday"];
            if ([[key objectForKey:@"entry"] isEqualToString:@"0"] && batteryLevel < thisPowerLevel) {
                if ([thisAllDay isEqualToString:@"1"]) {
                    alertMessage = [key objectForKey:@"message"];
                    notification.alertBody = alertMessage;
                    notification.soundName = UILocalNotificationDefaultSoundName;
                }
            }
        }
    }
    else
    {
        return;
    }
    
    // If the application is in the foreground, it will get a callback to application:didReceiveLocalNotification:.
    // If its not, iOS will display the notification to the user.
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
}*/
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
