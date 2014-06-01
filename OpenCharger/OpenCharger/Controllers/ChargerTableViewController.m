//
//  ChargerTableViewController.m
//  OpenCharger
//
//  Created by YongfengHe on 28.05.14.
//  Copyright (c) 2014 Yongfeng He. All rights reserved.
//

#import "ChargerTableViewController.h"
#import "OpenChargerSDK.h"

@interface ChargerTableViewController (){
    NSString    *myChargeTime;
}

@end

@implementation ChargerTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    style = UITableViewStyleGrouped;
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [self calculatePower];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)powerMinsSliderChanged:(id)sender {
    UISlider *slider = (UISlider *)sender;
    float chargeTime = slider.value;
    self.powerLabel.text = [NSString stringWithFormat:@"%.0f mins", chargeTime];
    if (chargeTime < 10) {
        myChargeTime = [NSString stringWithFormat:@"000%.0f", chargeTime];
    }
    else if (chargeTime < 100){
        myChargeTime = [NSString stringWithFormat:@"00%.0f", chargeTime];
    }
    else if (chargeTime < 1000){
        myChargeTime = [NSString stringWithFormat:@"0%.0f", chargeTime];
    }else{
        myChargeTime = [NSString stringWithFormat:@"%.0f", chargeTime];
    }
}
- (IBAction)calculateButtonPressed:(id)sender {
    [self calculatePower];

}
- (IBAction)turnOnButtonPressed:(id)sender {
}

- (void)calculatePower{
    [[UIDevice currentDevice] setBatteryMonitoringEnabled:YES];
    float batteryLevel = [[UIDevice currentDevice] batteryLevel];
    batteryLevel *= 100;
    self.powerLabel.text = [NSString stringWithFormat:@"%.0f\uFF05", batteryLevel];
    float chargeTime = 1.80*(100-batteryLevel);
    self.powerLabel.text = [NSString stringWithFormat:@"%.0f mins", chargeTime];
    if (chargeTime < 10) {
        myChargeTime = [NSString stringWithFormat:@"000%.0f", chargeTime];
    }
    else if (chargeTime < 100){
        myChargeTime = [NSString stringWithFormat:@"00%.0f", chargeTime];
    }
    else if (chargeTime < 1000){
        myChargeTime = [NSString stringWithFormat:@"0%.0f", chargeTime];
    }else{
        myChargeTime = [NSString stringWithFormat:@"%.0f", chargeTime];
    }
    self.powerSlider.value = ceil(chargeTime);
}

@end
