//
//  MainViewController.m
//  OpenChargerDemo
//
//  Created by Yongfeng on 14-5-1.
//  Copyright (c) 2014年 Yongfeng He. All rights reserved.
//

#import "MainViewController.h"
#import "OpenCharger SDK/OCDefines.h"

@interface MainViewController (){
    NSString    *myUUID;
    NSString    *myOpenChargerCode;
    NSString    *myChargeTime;
}

@end

@implementation MainViewController

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
    self.OC = [[OpenChargerSDK alloc] init];
    [self.OC controlSetup];
    
    self.uuid1.delegate = self;
    self.uuid2.delegate = self;
    self.uuid3.delegate = self;
    self.uuid4.delegate = self;
    self.uuid5.delegate = self;
    self.openChargerCode.delegate = self;
    
    //Battery
    [self loadBatteryStatus];
    
    //Slider
    [self.minsSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSLog(@"%ld",(long)textField.tag);
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    if (textField.tag == 1) {
        
        return (newLength > 10) ? NO : YES;
    }
    else if (textField.tag == 2 || textField.tag == 3 || textField.tag == 4){
        return (newLength > 4) ? NO : YES;
    }
    else if (textField.tag == 5){
        return (newLength > 12) ? NO : YES;
    }
    else{
        return YES;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(textField == self.uuid1) {
        [self.uuid2 becomeFirstResponder];
    } else if(textField == self.uuid2) {
        [self.uuid3 becomeFirstResponder];
    }else if(textField == self.uuid3) {
        [self.uuid4 becomeFirstResponder];
    }else if(textField == self.uuid4) {
        [self.uuid5 becomeFirstResponder];
    }else if(textField == self.uuid5) {
        [self.openChargerCode becomeFirstResponder];
    }
    else{
        [textField resignFirstResponder];
    }
    return NO;
}

-(void)loadBatteryStatus{
    [[UIDevice currentDevice] setBatteryMonitoringEnabled:YES];
    float batteryLevel = [[UIDevice currentDevice] batteryLevel];
    batteryLevel *= 100;
    self.powerStatusLabel.text = [NSString stringWithFormat:@"%.0f\uFF05", batteryLevel];
    float chargeTime = 1.20*(100-batteryLevel);
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
    self.minsSlider.value = ceil(chargeTime);
    NSLog(@"%@", myChargeTime);
}

- (IBAction)sliderValueChanged:(id)sender {
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


- (IBAction)connectButtonPressed:(id)sender {
    //set myUUID
    myUUID = [NSString stringWithFormat:@"%@-%@-%@-%@-%@", self.uuid1.text, self.uuid2.text, self.uuid3.text, self.uuid4.text, self.uuid5.text];
    //set myOpenChargerCode
    myOpenChargerCode = self.openChargerCode.text;
    double timeout = 3;
    [self.OC findBLEPeripherals:timeout];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeout * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        //NSLog(@"/%lu", (unsigned long)[self.OC.peripherals count]);
        //NSString *thisUUID = @"B4560D2B-EFBA-D6CC-9E96-FFDB6572A859";
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
                        NSLog(@"%@%@",myOpenChargerCode, myChargeTime);
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
@end
