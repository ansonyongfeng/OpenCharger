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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSLog(@"%d",textField.tag);
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)sliderValueChenged:(id)sender {
}

- (IBAction)connectButtonPressed:(id)sender {
    double timeout = 3;
    //add ActivityIndicatorViewController Subview
    [self.OC findBLEPeripherals:timeout];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeout * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        //NSLog(@"/%lu", (unsigned long)[self.OC.peripherals count]);
        NSString *thisUUID = @"B4560D2B-EFBA-D6CC-9E96-FFDB6572A859";
        for (int i=0; i< (unsigned long)[self.OC.peripherals count]; i++) {
            CBPeripheral *seletedPeripheral = [self.OC.peripherals objectAtIndex:i];
            NSString *identifierString = [NSString stringWithFormat:@"%@", seletedPeripheral.identifier];
            NSArray *uuidArray = [identifierString componentsSeparatedByString:@" "];
            NSString *seletedUUID = [uuidArray objectAtIndex:2];
            if ([thisUUID isEqualToString:seletedUUID]) {
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
                        [self.OC sendCodeToOpenCharger:seletedPeripheral openChargerCode:@"123456789012" chargeTime:@"0002"];
                    });
                }];
            }
        }
    });
}
@end
