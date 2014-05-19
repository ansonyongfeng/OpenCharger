//
//  MessageTableViewCell.h
//  OCMessage
//
//  Created by YongfengHe on 19.05.14.
//  Copyright (c) 2014 Yongfeng He. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageTableViewCell : UITableViewCell


@property (weak, nonatomic) NSString *thisID;

@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *entryLabel;
@property (weak, nonatomic) IBOutlet UILabel *powerLabel;
@property (weak, nonatomic) IBOutlet UILabel *timingLabel;
@property (weak, nonatomic) IBOutlet UISwitch *activeSwitch;

@end
