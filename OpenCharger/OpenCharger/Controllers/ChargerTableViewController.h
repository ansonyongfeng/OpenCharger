//
//  ChargerTableViewController.h
//  OpenCharger
//
//  Created by YongfengHe on 28.05.14.
//  Copyright (c) 2014 Yongfeng He. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OpenChargerSDK.h"
#import "OpenChargerDefines.h"

@interface ChargerTableViewController : UITableViewController<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *powerLabel;
@property (weak, nonatomic) IBOutlet UISlider *powerSlider;

@property (nonatomic, strong) OpenChargerSDK *OC;

@property (nonatomic, strong) CBPeripheral  *thisPeripheral;

@property (weak, nonatomic) IBOutlet UISwitch *powerSwitch;
@end
