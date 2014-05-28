//
//  MessagesTableViewController.m
//  OpenCharger
//
//  Created by YongfengHe on 28.05.14.
//  Copyright (c) 2014 Yongfeng He. All rights reserved.
//

#import "MessagesTableViewController.h"
#import "DatabankConnectModel.h"
#import "MessagesTableViewCell.h"

@interface MessagesTableViewController (){
    DatabankConnectModel        *DBCM;
    MessagesTableViewCell       *MTC;
    NSMutableArray              *objectsItemArray;
}

@end

@implementation MessagesTableViewController

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
    
    //tableview
    self.tableView.dataSource   = self;
    self.tableView.delegate     = self;
    
    //databank
    DBCM = [[DatabankConnectModel alloc] init];
    [DBCM openDb];
    NSString *getItemsQuery = [NSString stringWithFormat:@"SELECT * FROM messages"];
    objectsItemArray = [DBCM getItems:getItemsQuery];
    [DBCM closeDb];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [objectsItemArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"MessageCell";
    MTC = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (MTC == nil) {
        MTC = [[MessagesTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    MTC.thisID = [[objectsItemArray objectAtIndex:indexPath.row] objectForKey:@"id"];
    
    MTC.messageLabel.text = [NSString stringWithFormat:@"%@", [[objectsItemArray objectAtIndex:indexPath.row] objectForKey:@"message"]];
    
    NSString *entry = [[objectsItemArray objectAtIndex:indexPath.row] objectForKey:@"entry"];
    if ([entry isEqualToString:@"1"]) {
        MTC.entryLabel.text = @"Entry";
    }else{
        MTC.entryLabel.text = @"Exit";
    }
    
    NSString *power = [[objectsItemArray objectAtIndex:indexPath.row] objectForKey:@"power"];
    MTC.powerLabel.text = [NSString stringWithFormat:@"Power under %@\uFF05", power];
    
    NSString *allDay = [[objectsItemArray objectAtIndex:indexPath.row] objectForKey:@"allday"];
    NSString *timing = [[objectsItemArray objectAtIndex:indexPath.row] objectForKey:@"timing"];
    if ([allDay isEqualToString:@"1"]) {
        MTC.allDayLabel.text = @"All day";
    }else{
        MTC.allDayLabel.text = timing;
    }
    
    NSString *active = [[objectsItemArray objectAtIndex:indexPath.row] objectForKey:@"active"];
    if ([active isEqualToString:@"1"]) {
        [MTC.activeSwitch setOn:YES animated:YES];
    }else{
        [MTC.activeSwitch setOn:NO animated:YES];
    }
    
    return MTC;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            // Delete the row from the data source
            DBCM = [[DatabankConnectModel alloc] init];
            [DBCM openDb];
            NSString *deleteItemsQuery = [NSString stringWithFormat:@"DELETE FROM messages WHERE id = %@", [[objectsItemArray objectAtIndex:indexPath.row] objectForKey:@"id"]];
            [DBCM deleteItems:deleteItemsQuery];
            [DBCM closeDb];
            
            [objectsItemArray removeObjectAtIndex:indexPath.row];
            [self.tableView reloadData];
            //[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            NSLog(@"%@", @"delete");
        }
        else if (editingStyle == UITableViewCellEditingStyleInsert) {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"Delete";
}
@end
