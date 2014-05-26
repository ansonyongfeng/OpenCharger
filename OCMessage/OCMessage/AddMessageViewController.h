//
//  AddMessageViewController.h
//  OCMessage
//
//  Created by YongfengHe on 19.05.14.
//  Copyright (c) 2014 Yongfeng He. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddMessageViewController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *messageTextField;
@property (weak, nonatomic) IBOutlet UILabel *entryLabel;
@property (weak, nonatomic) IBOutlet UILabel *powerLabel;
@property (weak, nonatomic) IBOutlet UILabel *timingLabel;

@property (weak, nonatomic) IBOutlet UISlider *powerSlider;

@property (weak, nonatomic) NSDictionary *inputData;

@property (weak, nonatomic) IBOutlet UISwitch *entrySwitch;
@property (weak, nonatomic) IBOutlet UISwitch *allDaySwitch;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@end
