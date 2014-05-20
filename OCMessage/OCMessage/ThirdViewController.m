//
//  ThirdViewController.m
//  OCMessage
//
//  Created by Yongfeng on 14-5-20.
//  Copyright (c) 2014年 Yongfeng He. All rights reserved.
//

#import "ThirdViewController.h"
#import "DatabankConnectModel.h"
#import "OpenCharger SDK/OCDefines.h"

@interface ThirdViewController (){
    NSString    *myUUID;
    NSString    *myOpenChargerCode;
    NSString    *myChargeTime;
    DatabankConnectModel        *DBCM;
    NSMutableArray              *objectsItemArray;
}

@end

@implementation ThirdViewController

-(void)viewWillAppear:(BOOL)animated{
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //databank
    myChargeTime = @"0060";
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
- (IBAction)minSliderChanged:(id)sender {
    UISlider *slider = (UISlider *)sender;
    float chargeTime = slider.value;
    self.chargeTimeLabel.text = [NSString stringWithFormat:@"%.0f mins", chargeTime];
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
- (IBAction)chargeButtonPressed:(id)sender {
    double timeout = 3;
    [self.OC findBLEPeripherals:timeout];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeout * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        for (int i=0; i< (unsigned long)[self.OC.peripherals count]; i++) {
            CBPeripheral *seletedPeripheral = [self.OC.peripherals objectAtIndex:i];
            NSString *identifierString = [NSString stringWithFormat:@"%@", seletedPeripheral.identifier];
            NSArray *uuidArray = [identifierString componentsSeparatedByString:@" "];
            NSString *seletedUUID = [uuidArray objectAtIndex:2];
            if ([myUUID isEqualToString:seletedUUID]) {
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
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Information"
                                                                message:@"UUID is not correct!"
                                                               delegate:self
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:@"OK", nil];
                [alert show];
            }
        }
    });
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
