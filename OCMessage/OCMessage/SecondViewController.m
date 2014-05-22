//
//  SecondViewController.m
//  OCMessage
//
//  Created by YongfengHe on 16.05.14.
//  Copyright (c) 2014 Yongfeng He. All rights reserved.
//

#import "SecondViewController.h"
#import "DatabankConnectModel.h"

@interface SecondViewController (){
    DatabankConnectModel        *DBCM;
    NSMutableArray              *objectsItemArray;
}

@end

@implementation SecondViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.uuid1.delegate = self;
    self.ocCode.delegate = self;
    
    //databank
    DBCM = [[DatabankConnectModel alloc] init];
    [DBCM openDb];
    NSString *getItemsQuery = [NSString stringWithFormat:@"SELECT * FROM setting"];
    objectsItemArray = [DBCM getSettingItems:getItemsQuery];
    [DBCM closeDb];
    self.uuid1.text = [[objectsItemArray objectAtIndex:0] objectForKey:@"uuid"];
    self.ocCode.text = [[objectsItemArray objectAtIndex:0] objectForKey:@"occode"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    if (textField.tag == 1) {
        
        return (newLength > 38) ? NO : YES;
    }
    else if (textField.tag == 2){
        return (newLength > 12) ? NO : YES;
    }
    else{
        return YES;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(textField == self.uuid1) {
        [self.ocCode becomeFirstResponder];
    } else if(textField == self.ocCode) {
        [textField resignFirstResponder];
    }else{
        
    }
    return NO;
}

- (IBAction)saveButtonPressed:(id)sender {
    NSString *thisUUID = self.uuid1.text;
    [self initBeacon:thisUUID];
}

- (void)initBeacon:(NSString *)myUUID  {
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:myUUID];
    self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid
                                                                //major:1
                                                                //minor:1
                                                           identifier:@"com.opencharger.myRegion"];
    // Tell location manager to start monitoring for the beacon region
    
    self.beaconRegion.notifyEntryStateOnDisplay = NO;
    [self.locationManager startMonitoringForRegion:self.beaconRegion];
    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
}
@end
