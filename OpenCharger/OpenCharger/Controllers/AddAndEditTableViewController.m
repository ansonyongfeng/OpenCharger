//
//  AddAndEditTableViewController.m
//  OpenCharger
//
//  Created by Yongfeng on 14-6-1.
//  Copyright (c) 2014年 Yongfeng He. All rights reserved.
//

#import "AddAndEditTableViewController.h"

#import "CoreDataModel.h"


@interface AddAndEditTableViewController (){

    NSString *message;
    NSString *entry;
    NSString *power;
    NSString *allday;
    NSString *start;
    NSString *active;
}

@end

@implementation AddAndEditTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveMessage)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    self.messageTextField.delegate = self;
    
    if (self.myMessage) {
        message = self.myMessage.message;
        entry   = self.myMessage.entry;
        power   = self.myMessage.power;
        allday  = self.myMessage.allday;
        start   = self.myMessage.start;
        active  = self.myMessage.active;
        [self setValueToView];
    }else{
        NSDate *currentTime = [NSDate date];
        
        message = self.messageTextField.text;
        entry   = @"1";
        power   = @"30";
        allday  = @"1";
        start   = [self dateToString:currentTime];
        active  = @"1";
        [self setValueToView];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)saveMessage{
    self.messageTextField.text = message;
    CoreDataModel *CDM = [[CoreDataModel alloc] init];
    NSDictionary *dict = @{
                            @"message"  : message,
                            @"entry"    : entry,
                            @"power"    : power,
                            @"allday"   : allday,
                            @"start"    : start,
                            @"active"   : active,
                            };
    if (self.myMessage) {
        [CDM updateData:dict MessageID:self.myMessage.id];
    }else{
        [CDM saveData:dict];
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(textField == self.messageTextField) {
        [textField resignFirstResponder];
        message = self.messageTextField.text;
    }
    return NO;
}

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
    float powerStatus = slider.value;
    self.powerLabel.text = [NSString stringWithFormat:@"%.0f\uFF05", powerStatus];
    power = [NSString stringWithFormat:@"%.0f", powerStatus];
}
- (IBAction)allDaySwitchChanged:(id)sender {
    UISwitch *thisSwitch = (UISwitch *)sender;
    if (thisSwitch.on) {
        allday = @"1";
        self.timingLabel.textColor = [UIColor lightGrayColor];
    }else{
        allday = @"0";
        self.timingLabel.textColor = [UIColor darkGrayColor];
    }
}
- (IBAction)datePickerChanged:(id)sender {
    UIDatePicker *thisDatePicker = (UIDatePicker *)sender;
    start      = [self dateToString:thisDatePicker.date];
    self.timingLabel.text = [self dateToString:thisDatePicker.date];
}

-(NSDate *)stringToDate:(NSString *)dataString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSDate *date = [dateFormatter dateFromString:dataString];
    return date;
}

-(NSString *)dateToString:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    return [dateFormatter stringFromDate: date];
}

- (void)setValueToView{
    self.messageTextField.text = message;
    
    if ([entry isEqualToString:@"1"]) {
        self.entryLabel.text = @"Entry";
        [self.entrySwitch setOn:YES];
    }else{
        NSLog(@"exit");
        self.entryLabel.text = @"Exit";
        [self.entrySwitch setOn:NO];
    }
    
    self.powerSlider.value = [power floatValue];
    self.powerLabel.text = [NSString stringWithFormat:@"%@\uFF05", power];
    
    if ([allday isEqualToString:@"1"]) {
        self.timingLabel.textColor = [UIColor lightGrayColor];
        [self.allDaySwitch setOn:YES];
    }else{
        self.timingLabel.textColor = [UIColor darkGrayColor];
        [self.allDaySwitch setOn:NO];
    }
    
    self.timingLabel.text = start;
    NSDate *myDate= [self stringToDate:start];
    [self.dateTimePicker setDate:myDate];
}

@end
