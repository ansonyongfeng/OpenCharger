//
//  MessagesTableViewController.m
//  OpenCharger
//
//  Created by YongfengHe on 28.05.14.
//  Copyright (c) 2014 Yongfeng He. All rights reserved.
//

#import "MessagesTableViewController.h"
#import "MessagesTableViewCell.h"
#import "AddAndEditTableViewController.h"
#import "Messages.h"
#import "CoreDataModel.h"

@interface MessagesTableViewController (){
    MessagesTableViewCell           *MTC;
    AddAndEditTableViewController   *AAETVC;
    NSArray                         *objectsItemArray;
    CoreDataModel                   *CDM;
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

- (void)viewWillAppear:(BOOL)animated{
    //tableview
    self.tableView.dataSource   = self;
    self.tableView.delegate     = self;
    
    //coredata
    CDM = [[CoreDataModel alloc] init];
    objectsItemArray = [CDM getAllMessageRecords];
    
    [self.tableView reloadData];
    
    //NSLog(@"%@", objectsItemArray);

}

- (void)viewDidLoad
{
    [super viewDidLoad];
            
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStylePlain target:self action:@selector(addMessage)];
    self.navigationItem.rightBarButtonItem = rightButton;
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
    
    Messages *messages = [objectsItemArray objectAtIndex:indexPath.row];
    
    MTC.myMessage = messages;
    
    MTC.messageLabel.text = messages.message;
    
    NSString *entry = messages.entry;
    if ([entry  isEqual: @"1"]) {
        MTC.entryLabel.text = @"entry";
    }else{
        MTC.entryLabel.text = @"exit";
    }
    
    NSString *power = messages.power;
    MTC.powerLabel.text = [NSString stringWithFormat:@"battery < %@\uFF05", power];
    
    NSString *allDay = messages.allday;
    //NSString *timing = messages.timing;
    if ([allDay isEqualToString:@"1"]) {
        MTC.allDayLabel.text = @"all-day";
    }else{
        MTC.allDayLabel.text = messages.start;
    }
    
    NSString *active = messages.active;
    if ([active isEqualToString:@"1"]) {
        [MTC.activeSwitch setOn:YES animated:YES];
        MTC.activeLabel.text = @"active";
    }else{
        [MTC.activeSwitch setOn:NO animated:YES];
        MTC.activeLabel.text = @"inactive";
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

- (void)addMessage{
    AAETVC  = [self.storyboard instantiateViewControllerWithIdentifier:@"AddAndEdit"];
    [self.navigationController pushViewController:AAETVC animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Messages *message = [objectsItemArray objectAtIndex:indexPath.row];
    AAETVC  = [self.storyboard instantiateViewControllerWithIdentifier:@"AddAndEdit"];
    AAETVC.myMessage = message;
    [self.navigationController pushViewController:AAETVC animated:YES];
}


@end
