//
//  MessagesTableViewCell.m
//  OpenCharger
//
//  Created by YongfengHe on 28.05.14.
//  Copyright (c) 2014 Yongfeng He. All rights reserved.
//

#import "MessagesTableViewCell.h"
#import "CoreDataModel.h"

@implementation MessagesTableViewCell{

}

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
    CoreDataModel   *CDM = [[CoreDataModel alloc] init];
    NSDictionary    *dict = [[NSDictionary alloc] init];
    if (thisSwitch.on) {
        dict = @{
                    @"message"  : self.myMessage.message,
                    @"entry"    : self.myMessage.entry,
                    @"power"    : self.myMessage.power,
                    @"allday"   : self.myMessage.allday,
                    @"start"    : self.myMessage.start,
                    @"active"   : @"1",
                    };
        self.activeLabel.text = @"active";
        
    }else{
        dict = @{
                 @"message"  : self.myMessage.message,
                 @"entry"    : self.myMessage.entry,
                 @"power"    : self.myMessage.power,
                 @"allday"   : self.myMessage.allday,
                 @"start"    : self.myMessage.start,
                 @"active"   : @"0",
                 };
        self.activeLabel.text = @"inactive";
    }
    [CDM updateData:dict MessageID:self.myMessage.id];
}

@end
