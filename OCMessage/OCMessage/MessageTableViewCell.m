//
//  MessageTableViewCell.m
//  OCMessage
//
//  Created by YongfengHe on 19.05.14.
//  Copyright (c) 2014 Yongfeng He. All rights reserved.
//

#import "MessageTableViewCell.h"
#import "DatabankConnectModel.h"

@implementation MessageTableViewCell{
    DatabankConnectModel        *DBCM;
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
    DBCM = [[DatabankConnectModel alloc] init];
    [DBCM openDb];
    if (thisSwitch.on) {
        NSString *getItemsQuery = [NSString stringWithFormat:@"UPDATE messages SET  active = '1' WHERE id = '%@'", self.thisID];
        [DBCM updateItem:getItemsQuery];
        
    }else{
        NSString *getItemsQuery = [NSString stringWithFormat:@"UPDATE messages SET  active = '0' WHERE id = '%@'", self.thisID];
        [DBCM updateItem:getItemsQuery];
    }
    [DBCM closeDb];
}
@end
