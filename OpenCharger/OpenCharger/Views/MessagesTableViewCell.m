//
//  MessagesTableViewCell.m
//  OpenCharger
//
//  Created by YongfengHe on 28.05.14.
//  Copyright (c) 2014 Yongfeng He. All rights reserved.
//

#import "MessagesTableViewCell.h"


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
    /*UISwitch *thisSwitch = (UISwitch *)sender;
    DBCM = [[DatabankConnectModel alloc] init];
    [DBCM openDb];
    if (thisSwitch.on) {
        NSString *getItemsQuery = [NSString stringWithFormat:@"UPDATE messages SET  active = '1' WHERE id = '%@'", self.thisID];
        [DBCM updateItem:getItemsQuery];
        
    }else{
        NSString *getItemsQuery = [NSString stringWithFormat:@"UPDATE messages SET  active = '0' WHERE id = '%@'", self.thisID];
        [DBCM updateItem:getItemsQuery];
    }*/
}

@end
