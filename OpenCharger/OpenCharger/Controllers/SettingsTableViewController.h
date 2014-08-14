//
//  SettingsTableViewController.h
//  OpenCharger
//
//  Created by YongfengHe on 28.05.14.
//  Copyright (c) 2014 Yongfeng He. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface SettingsTableViewController : UITableViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, CLLocationManagerDelegate>


@property (weak, nonatomic) IBOutlet UITextField *uuidTextField;
@property (weak, nonatomic) IBOutlet UITextField *ocCodeTextField;

@property (strong, nonatomic) CLBeaconRegion *beaconRegion;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLBeacon *beacon;
@property (assign) BOOL isConnectingToBeacon;

@end
