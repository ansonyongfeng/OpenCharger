//
//  MessagesTableViewCell.h
//  OpenCharger
//
//  Created by YongfengHe on 28.05.14.
//  Copyright (c) 2014 Yongfeng He. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Messages.h"

@interface MessagesTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel    *messageLabel;
@property (weak, nonatomic) IBOutlet UISwitch   *activeSwitch;
@property (weak, nonatomic) IBOutlet UILabel    *entryLabel;
@property (weak, nonatomic) IBOutlet UILabel    *powerLabel;
@property (weak, nonatomic) IBOutlet UILabel    *allDayLabel;
@property (weak, nonatomic) IBOutlet UILabel    *activeLabel;

@property (strong, nonatomic) Messages          *myMessage;

@end
