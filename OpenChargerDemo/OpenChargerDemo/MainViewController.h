//
//  MainViewController.h
//  OpenChargerDemo
//
//  Created by Yongfeng on 14-5-1.
//  Copyright (c) 2014年 Yongfeng He. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CBPeripheral.h>
#import "OpenCharger SDK/OpenChargerSDK.h"
#import "OpenCharger SDK/OCDefines.h"

@interface MainViewController : UIViewController

@property (nonatomic, strong) OpenChargerSDK *OC;

@property (weak, nonatomic) IBOutlet UITextField *uuid1;
@property (weak, nonatomic) IBOutlet UITextField *uuid2;
@property (weak, nonatomic) IBOutlet UITextField *uuid3;
@property (weak, nonatomic) IBOutlet UITextField *uuid4;
@property (weak, nonatomic) IBOutlet UITextField *uuid5;
@property (weak, nonatomic) IBOutlet UITextField *openChargerCode;
@property (weak, nonatomic) IBOutlet UISlider *minsSlider;


@property (weak, nonatomic) IBOutlet UIButton *connectButton;

@end
