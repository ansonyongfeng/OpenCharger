//
//  ChargerTableViewController.m
//  OpenCharger
//
//  Created by YongfengHe on 28.05.14.
//  Copyright (c) 2014 Yongfeng He. All rights reserved.
//

#import "ChargerTableViewController.h"
#import "OpenChargerSDK.h"
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
    
    //turn on BLE
    self.OC = [[OpenChargerSDK alloc] init];
    [self.OC controlSetup];
    
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
    double timeout = 3;
    [self.OC findBLEPeripherals:timeout];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeout * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        for (int i=0; i< (unsigned long)[self.OC.peripherals count]; i++) {
            CBPeripheral *seletedPeripheral = [self.OC.peripherals objectAtIndex:i];
            
            //NSString *identifierString = [NSString stringWithFormat:@"%@", seletedPeripheral.identifier];
            //NSArray *uuidArray = [identifierString componentsSeparatedByString:@" "];
            //NSString *seletedUUID = [uuidArray objectAtIndex:2];
        
            NSString *regEx = [NSString stringWithFormat:@".*%@.*", @"OpenCharger"];
            NSRange range = [seletedPeripheral.name rangeOfString:regEx options:NSRegularExpressionSearch];
            
            if (range.location != NSNotFound) {
                NSLog(@"%@",seletedPeripheral);
                [self.OC connectPeripheral:seletedPeripheral];
                [self.OC didDiscoverCharacteristicsBlock:^(id response, NSError *error) {
                    double delayInSeconds = 3.0;
                    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                        [self.OC  notification:[CBUUID UUIDWithString:BS_SERIAL_SERVICE_UUID]
                            characteristicUUID:[CBUUID UUIDWithString:BS_SERIAL_RX_UUID]
                                             p:seletedPeripheral
                                            on:YES];
                        [self.OC  didUpdateValueBlock:^(NSData *data, NSError *error) {
                            //NSString *recv = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                        }];
                        //turn OC on
                        [self.OC sendCodeToOpenCharger:seletedPeripheral openChargerCode:myOpenChargerCode chargeTime:myChargeTime];
                        //NSLog(@"%@%@",myOpenChargerCode, myChargeTime);
                    });
                }];
            }else{
                [self showMessage:@"Invalid UUID"];
            }
        }
    });
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

- (void)showMessage:(NSString *) myMessage{
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Hi"
                                                      message:myMessage
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    
    [message show];
}

@end
