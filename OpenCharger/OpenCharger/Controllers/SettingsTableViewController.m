//
//  SettingsTableViewController.m
//  OpenCharger
//
//  Created by YongfengHe on 28.05.14.
//  Copyright (c) 2014 Yongfeng He. All rights reserved.
//

#import "SettingsTableViewController.h"


@interface SettingsTableViewController ()

@end

@implementation SettingsTableViewController{
    NSMutableArray  *objectsItemArray;
    NSUUID          *iBeacon1uuid;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    style = UITableViewStyleGrouped;
    if (self) {
        // Custom initialization
        NSLog(@"self");
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    //databank
    /*DBCM = [[DatabankConnectModel alloc] init];
    [DBCM openDb];
    NSString *getItemsQuery = [NSString stringWithFormat:@"SELECT * FROM setting"];
    objectsItemArray = [DBCM getSettingItems:getItemsQuery];
    [DBCM closeDb];*/
    self.uuidTextField.text = [[objectsItemArray objectAtIndex:0] objectForKey:@"uuid"];
    self.ocCodeTextField.text = [[objectsItemArray objectAtIndex:0] objectForKey:@"occode"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveSetting)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    self.uuidTextField.delegate = self;
    self.ocCodeTextField.delegate = self;
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self initRegion];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)saveSetting{
    NSUUID *thisUUID= [[NSUUID alloc] initWithUUIDString:self.uuidTextField.text];
    
    if (thisUUID) {
        //update db
        /*DBCM = [[DatabankConnectModel alloc] init];
        [DBCM openDb];
        
        NSString *updateItemQuery = [NSString stringWithFormat:@"UPDATE setting SET uuid = '%@', occode = '%@' WHERE id = 1", self.uuidTextField.text, self.ocCodeTextField.text];
        [DBCM updateItem:updateItemQuery];
        [DBCM closeDb];*/
        //init iBeacon
        [self initBeacon:thisUUID];
        [self showMessage:@"Settings already configured"];
    }else{
        [self showMessage:@"Invalid UUID"];
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(textField == self.uuidTextField) {
        [self.ocCodeTextField becomeFirstResponder];
    }else{
        [textField resignFirstResponder];
    }
    return NO;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    if (textField.tag == 1) {
        
        return (newLength > 36) ? NO : YES;
    }
    else if (textField.tag == 2 || textField.tag == 3 || textField.tag == 4){
        return (newLength > 12) ? NO : YES;
    }
    else{
        return YES;
    }
}

- (void)initRegion {
    //test iPad
    //iBeacon1uuid = [[NSUUID alloc] initWithUUIDString:@"B9407F30-F5F8-466E-AFF9-25556B57FE61"];
    //my iBeacon
    //estimote B9407F30-F5F8-466E-AFF9-25556B57FE6D
    
    iBeacon1uuid = [[NSUUID alloc] initWithUUIDString:@"BA96930E-34B5-40BD-E8B9-8DB2823B07CC"];
    self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:iBeacon1uuid identifier:@"Welcome"];
    self.beaconRegion.notifyOnEntry = YES;
    self.beaconRegion.notifyOnExit = YES;
    
    // launch app when display is turned on and inside region
    self.beaconRegion.notifyEntryStateOnDisplay = YES;
    
    if ([CLLocationManager isMonitoringAvailableForClass:[CLBeaconRegion class]])
    {
        [self.locationManager startMonitoringForRegion:self.beaconRegion];
        [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
        
        NSLog(@"iBeacon Yes 1");
    }
    NSLog(@"iBeacon Yes 2");
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (![CLLocationManager locationServicesEnabled]) {
        NSLog(@"Couldn't turn on ranging: Location services are not enabled.");
    }
    
    if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorized) {
        NSLog(@"Couldn't turn on monitoring: Location services not authorised.");
    }
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region{
    if ([region.identifier isEqualToString:@"Welcome"]){
        //do something
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.alertBody = @"Herzlich Willkommen! Tolle Angebote warten auf Sie.";
        notification.soundName = UILocalNotificationDefaultSoundName;
        notification.alertAction = [NSString stringWithFormat:@"welcome"];
        
        [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
        
        if ((notification.alertAction = @"welcome")) {
            
            NSLog(@"push");
            
        }
    }else if ([region.identifier isEqualToString:@"ArielColor"]){
        //do something
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.alertBody = @"Sie mögen Frische? Ariel gibts auch mit Febreze!";
        notification.soundName = UILocalNotificationDefaultSoundName;
        notification.alertAction = [NSString stringWithFormat:@"ArielColor1"];
        
        [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
        
        if ((notification.alertAction = @"ArielColor1")) {
            
            
            
        }
    }else if ([region.identifier isEqualToString:@"Febreze"]){
        //do something
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.alertBody = @"Frische Luft? Gibt's hier auch zum Mitnehmen. Mit Febreze!";
        notification.soundName = UILocalNotificationDefaultSoundName;
        notification.alertAction = [NSString stringWithFormat:@"Febreze1"];
        NSLog(@"feb");
        [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
        
        if ((notification.alertAction = @"Febreze1")) {
            
        }
    }
}

- (void)initBeacon:(NSUUID *)myUUID  {
    NSLog(@"Beacon setted");
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:myUUID
                         //major:1
                         //minor:1
                                                           identifier:@"com.opencharger.myRegion"];
    // Tell location manager to start monitoring for the beacon region
    
    self.beaconRegion.notifyEntryStateOnDisplay = NO;
    [self.locationManager startMonitoringForRegion:self.beaconRegion];
    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
}

- (void)showMessage:(NSString *) myMessage{
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Hi"
                                                      message:myMessage
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    
    [message show];
}


@end
