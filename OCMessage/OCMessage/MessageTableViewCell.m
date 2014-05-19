//
//  MessageTableViewCell.m
//  OCMessage
//
//  Created by YongfengHe on 19.05.14.
//  Copyright (c) 2014 Yongfeng He. All rights reserved.
//

#import "MessageTableViewCell.h"

@implementation MessageTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)activeSwitchChanged:(id)sender {
    UISwitch *thisSwitch = (UISwitch *)sender;
    if (thisSwitch.on) {
        NSLog(@"%@", self.thisID);
        
    }else{
        NSLog(@"%@", self.thisID);
    }
}
@end
