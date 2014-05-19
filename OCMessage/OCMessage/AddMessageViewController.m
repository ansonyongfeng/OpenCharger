//
//  AddMessageViewController.m
//  OCMessage
//
//  Created by YongfengHe on 19.05.14.
//  Copyright (c) 2014 Yongfeng He. All rights reserved.
//

#import "AddMessageViewController.h"
#import "DatabankConnectModel.h"

@interface AddMessageViewController (){
    NSString    *message;
    NSString    *entry;
    NSString    *power;
    NSString    *allDay;
    NSString    *timing;
    DatabankConnectModel    *DBCM;
}

@end

@implementation AddMessageViewController

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
    
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveMessage)];
    self.navigationItem.rightBarButtonItem = anotherButton;
    
    self.messageTextField.delegate = self;
    
    //default data
    message     = @"";
    entry       = @"1";
    power       = @"30";
    allDay      = @"1";
    NSDate *currentTime = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    timing      = [dateFormatter stringFromDate: currentTime];
    self.timingLabel.text = timing;
    //NSLog(@"%@, %@, %@, %@, %@, ", message, entry, power, allDay, timing);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(textField == self.messageTextField) {
        [textField resignFirstResponder];
    }
    return NO;
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
- (IBAction)entrySwitchChanged:(id)sender {
    UISwitch *thisSwitch = (UISwitch *)sender;
    if (thisSwitch.on) {
        entry = @"1";
        self.entryLabel.text = @"Entry";
    }else{
        entry = @"0";
        self.entryLabel.text = @"Exit";
    }
}
- (IBAction)powerSliderChanged:(id)sender {
    UISlider *slider = (UISlider *)sender;
    float chargeTime = slider.value;
    self.powerLabel.text = [NSString stringWithFormat:@"%.0f\uFF05", chargeTime];
    power = [NSString stringWithFormat:@"%.0f", chargeTime];
}
- (IBAction)allDaySwitchChanged:(id)sender {
    UISwitch *thisSwitch = (UISwitch *)sender;
    if (thisSwitch.on) {
        allDay = @"1";
        self.timingLabel.textColor = [UIColor lightGrayColor];
    }else{
        allDay = @"0";
        self.timingLabel.textColor = [UIColor darkGrayColor];
    }
}
- (IBAction)datePickerChange:(id)sender {
    UIDatePicker *thisDatePicker = (UIDatePicker *)sender;
    NSDate *thisDatePickerTime = thisDatePicker.date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    timing      = [dateFormatter stringFromDate: thisDatePickerTime];
    self.timingLabel.text = [dateFormatter stringFromDate: thisDatePickerTime];
}

-(void)saveMessage{
    message = self.messageTextField.text;
    //NSLog(@"%@, %@, %@, %@, %@, ", message, entry, power, allDay, timing);
    DBCM = [[DatabankConnectModel alloc] init];
    [DBCM openDb];
    NSString *insertFavItemsQuery = [NSString stringWithFormat:@"INSERT INTO messages (message, entry, power, allday, timing, active) VALUES ('%@', '%@', '%@', '%@', '%@', '1')", message, entry, power, allDay, timing];
    [DBCM insertItems:insertFavItemsQuery];
    NSLog(@"%@",insertFavItemsQuery);
    [DBCM closeDb];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
