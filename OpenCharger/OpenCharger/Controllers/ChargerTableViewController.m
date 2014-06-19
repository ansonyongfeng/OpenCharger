//
//  ChargerTableViewController.m
//  OpenCharger
//
//  Created by YongfengHe on 28.05.14.
//  Copyright (c) 2014 Yongfeng He. All rights reserved.
//

#import "ChargerTableViewController.h"
#import "DatabankConnectModel.h"

@interface ChargerTableViewController (){
    NSString    *myChargeTime;
    NSString    *myUUID;
    NSString    *myOpenChargerCode;
    DatabankConnectModel        *DBCM;
    NSMutableArray              *objectsItemArray;
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
    
    //databank
    DBCM = [[DatabankConnectModel alloc] init];
    [DBCM openDb];
    NSString *getItemsQuery = [NSString stringWithFormat:@"SELECT * FROM setting"];
    objectsItemArray = [DBCM getSettingItems:getItemsQuery];
    [DBCM closeDb];
    myUUID = [[objectsItemArray objectAtIndex:0] objectForKey:@"uuid"];
    myOpenChargerCode = [[objectsItemArray objectAtIndex:0] objectForKey:@"occode"];
    NSLog(@"%@, %@", myUUID, myOpenChargerCode);
    
    //connect to OpenCharger
    NSLog(@"%@",self.thisPeripheral);
    [self.OC connectPeripheral:self.thisPeripheral];
    [self.OC didDiscoverCharacteristicsBlock:^(id response, NSError *error) {
        double delayInSeconds = 3.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self.OC  notification:[CBUUID UUIDWithString:BS_SERIAL_SERVICE_UUID]
                characteristicUUID:[CBUUID UUIDWithString:BS_SERIAL_RX_UUID]
                                 p:self.thisPeripheral
                                on:YES];
            [self.OC  didUpdateValueBlock:^(NSData *data, NSError *error) {
                //NSString *recv = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            }];
        });
    }];
    
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
- (IBAction)powerSwitchChanged:(id)sender {
    UISwitch *thisSwitch = (UISwitch *)sender;
    if (thisSwitch.on) {
        [self.OC sendCodeToOpenCharger:self.thisPeripheral openChargerCode:myOpenChargerCode chargeTime:myChargeTime];
    }else{
        [self.OC turnOffOpenCharger:self.thisPeripheral];
    }
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
