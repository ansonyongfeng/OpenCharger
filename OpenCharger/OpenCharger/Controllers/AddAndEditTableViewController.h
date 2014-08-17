//
//  AddAndEditTableViewController.h
//  OpenCharger
//
//  Created by Yongfeng on 14-6-1.
//  Copyright (c) 2014年 Yongfeng He. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AddAndEditTableViewController : UITableViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *messageTextField;
@property (weak, nonatomic) IBOutlet UILabel *entryLabel;
@property (weak, nonatomic) IBOutlet UISwitch *entrySwitch;
@property (weak, nonatomic) IBOutlet UILabel *powerLabel;
@property (weak, nonatomic) IBOutlet UISlider *powerSlider;
@property (weak, nonatomic) IBOutlet UISwitch *allDaySwitch;
@property (weak, nonatomic) IBOutlet UILabel *timingLabel;
@property (weak, nonatomic) IBOutlet UIDatePicker *dateTimePicker;

@property (strong, nonatomic) NSDictionary  *dataDictionary;

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator ;

@end
