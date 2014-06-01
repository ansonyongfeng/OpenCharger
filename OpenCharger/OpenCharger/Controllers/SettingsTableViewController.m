//
//  SettingsTableViewController.m
//  OpenCharger
//
//  Created by YongfengHe on 28.05.14.
//  Copyright (c) 2014 Yongfeng He. All rights reserved.
//

#import "SettingsTableViewController.h"
#import "DatabankConnectModel.h"

@interface SettingsTableViewController ()

@end

@implementation SettingsTableViewController{
    DatabankConnectModel        *DBCM;
    NSMutableArray              *objectsItemArray;
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
    DBCM = [[DatabankConnectModel alloc] init];
    [DBCM openDb];
    NSString *getItemsQuery = [NSString stringWithFormat:@"SELECT * FROM setting"];
    objectsItemArray = [DBCM getSettingItems:getItemsQuery];
    [DBCM closeDb];
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
        DBCM = [[DatabankConnectModel alloc] init];
        [DBCM openDb];
        
        NSString *updateItemQuery = [NSString stringWithFormat:@"UPDATE setting SET uuid = '%@', occode = '%@' WHERE id = 1", self.uuidTextField.text, self.ocCodeTextField.text];
        [DBCM updateItem:updateItemQuery];
        [DBCM closeDb];
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
