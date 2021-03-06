//
//  SecondViewController.h
//  OCMessage
//
//  Created by YongfengHe on 16.05.14.
//  Copyright (c) 2014 Yongfeng He. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface SecondViewController : UIViewController<UITextFieldDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *uuid1;
@property (weak, nonatomic) IBOutlet UITextField *ocCode;

@property (strong, nonatomic) CLBeaconRegion *beaconRegion;
@property (strong, nonatomic) CLLocationManager *locationManager;

@end
