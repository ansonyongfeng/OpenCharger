//
//  AddAndEditTableViewController.m
//  OpenCharger
//
//  Created by Yongfeng on 14-6-1.
//  Copyright (c) 2014年 Yongfeng He. All rights reserved.
//

#import "AddAndEditTableViewController.h"
#import "Messages.h"
#import "CoreDataModel.h"


@interface AddAndEditTableViewController (){
    NSString *messageID;
    NSString *message;
    NSString *entry;
    NSString *power;
    NSString *allday;
    NSString *starts;
    NSArray *fetchedRecordsArray;
    CoreDataModel   *CDM;
    
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
    
    if (self.dataDictionary) {
        NSLog(@"%@", self.dataDictionary);
        messageID   = [self.dataDictionary objectForKey:@"id"];
        message     = [self.dataDictionary objectForKey:@"message"];
        entry       = [self.dataDictionary objectForKey:@"entry"];
        power       = [self.dataDictionary objectForKey:@"power"];
        allday      = [self.dataDictionary objectForKey:@"allday"];
        starts      = [self.dataDictionary objectForKey:@"start"];
        
        [self setValueToView];
    }else{

        message     = @"";
        entry       = @"1";
        power       = @"30";
        allday      = @"1";
        NSDate *currentTime = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"HH:mm"];
        starts      = [dateFormatter stringFromDate: currentTime];
        
        [self setValueToView];
    }
    CDM = [[CoreDataModel alloc] init];
    fetchedRecordsArray = [CDM getAllMessageRecords];
    
    for (int i = 0; i < [fetchedRecordsArray count]; i++)
    {

        Messages *thisLine = [fetchedRecordsArray objectAtIndex:i];
        NSLog(@"%@", thisLine.id);
        NSLog(@"%@", thisLine.message);

    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)saveMessage{
    message     = self.messageTextField.text;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSDate *dateFromString = [[NSDate alloc] init];
    dateFromString = [dateFormatter dateFromString:starts];
    
    NSDictionary *dict = @{
                            @"message" : message,
                            @"entry" : entry,
                            @"power" : power,
                            @"allday" : allday,
                            @"start" : @"12:00",
                            @"active" : @"1",
                            };
    
    [CDM saveData:dict];
    
    if (self.dataDictionary) {
        
    }else{
        message = self.messageTextField.text;
        //NSLog(@"%@, %@, %@, %@, %@, ", message, entry, power, allDay, timing);
        /*DBCM = [[DatabankConnectModel alloc] init];
        [DBCM openDb];
        NSString *insertFavItemsQuery = [NSString stringWithFormat:@"INSERT INTO messages (message, entry, power, allday, timing, active) VALUES ('%@', '%@', '%@', '%@', '%@', '1')", message, entry, power, allDay, starts];
        [DBCM insertItems:insertFavItemsQuery];
        NSLog(@"%@",insertFavItemsQuery);
        [DBCM closeDb];*/
    }

    //[self.navigationController popToRootViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(textField == self.messageTextField) {
        [textField resignFirstResponder];
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
    NSDate *thisDatePickerTime = thisDatePicker.date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    starts      = [dateFormatter stringFromDate: thisDatePickerTime];
    self.timingLabel.text = [dateFormatter stringFromDate: thisDatePickerTime];
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
    
    self.timingLabel.text = starts;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"HH:mm"];
    NSDate *destDate= [dateFormatter dateFromString:starts];
    
    [self.dateTimePicker setDate:destDate];
}

@end
