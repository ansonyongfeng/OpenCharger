//
//  AddAndEditTableViewController.m
//  OpenCharger
//
//  Created by Yongfeng on 14-6-1.
//  Copyright (c) 2014年 Yongfeng He. All rights reserved.
//

#import "AddAndEditTableViewController.h"
#import "DatabankConnectModel.h"
#import "Messages.h"


@interface AddAndEditTableViewController (){
    NSString *messageID;
    NSString *message;
    NSString *entry;
    NSString *power;
    NSString *allDay;
    NSString *starts;
    DatabankConnectModel    *DBCM;
    NSArray *fetchedRecordsArray;
    
}

@end

@implementation AddAndEditTableViewController

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

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
        allDay      = [self.dataDictionary objectForKey:@"allday"];
        starts      = [self.dataDictionary objectForKey:@"timing"];
        
        [self setValueToView];
    }else{

        message     = @"";
        entry       = @"1";
        power       = @"30";
        allDay      = @"1";
        NSDate *currentTime = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"HH:mm"];
        starts      = [dateFormatter stringFromDate: currentTime];
        
        [self setValueToView];
    }
    
    fetchedRecordsArray = [self getAllPhoneBookRecords];
    
    for (int i = 0; i < [fetchedRecordsArray count]; i++)
    {
        Messages *thisLine = [fetchedRecordsArray objectAtIndex:i];
        NSLog(@"%@", thisLine.message);

    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)saveCoreData{
    // Add Entry to PhoneBook Data base and reset all fields
    
    //  1
    Messages *newEntry = [NSEntityDescription insertNewObjectForEntityForName:@"Messages" inManagedObjectContext:self.managedObjectContext];
    //  2
    
    newEntry.message = @"hello world";

    //  3
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }

}

/**********Core Data beginn************/
// 1
- (NSManagedObjectContext *) managedObjectContext {
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    
    return _managedObjectContext;
}

//2
- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    return _managedObjectModel;
}

//3
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"coredata.sqlite"]];
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]
                                   initWithManagedObjectModel:[self managedObjectModel]];
    if(![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                  configuration:nil URL:storeUrl options:nil error:&error]) {
        /*Error for store creation should be handled in here*/
    }
    
    return _persistentStoreCoordinator;
}

- (NSString *)applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

-(NSArray*)getAllPhoneBookRecords
{
    // initializing NSFetchRequest
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Messages" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError* error;
    
    // Query on managedObjectContext With Generated fetchRequest
    NSArray *fetchedRecords = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    // Returning Fetched Records
    return fetchedRecords;
}
/**********Core Data end************/

- (void)saveMessage{
    message     = self.messageTextField.text;
    
    if (self.dataDictionary) {
        DBCM = [[DatabankConnectModel alloc] init];
        [DBCM openDb];
        
        NSString *updateItemQuery = [NSString stringWithFormat:@"UPDATE messages SET message = '%@', entry = '%@', power = '%@', allday = '%@', timing = '%@' WHERE id = %@", message, entry, power, allDay, starts, messageID];
        [DBCM updateItem:updateItemQuery];
        [DBCM closeDb];
    }else{
        message = self.messageTextField.text;
        //NSLog(@"%@, %@, %@, %@, %@, ", message, entry, power, allDay, timing);
        DBCM = [[DatabankConnectModel alloc] init];
        [DBCM openDb];
        NSString *insertFavItemsQuery = [NSString stringWithFormat:@"INSERT INTO messages (message, entry, power, allday, timing, active) VALUES ('%@', '%@', '%@', '%@', '%@', '1')", message, entry, power, allDay, starts];
        [DBCM insertItems:insertFavItemsQuery];
        NSLog(@"%@",insertFavItemsQuery);
        [DBCM closeDb];
    }
    [self saveCoreData];
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
        allDay = @"1";
        self.timingLabel.textColor = [UIColor lightGrayColor];
    }else{
        allDay = @"0";
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
    
    if ([allDay isEqualToString:@"1"]) {
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
