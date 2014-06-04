//
//  SearchTableViewController.m
//  OpenCharger
//
//  Created by Yongfeng on 14-6-4.
//  Copyright (c) 2014年 Yongfeng He. All rights reserved.
//

#import "SearchTableViewController.h"
#import "SearchTableViewCell.h"
#import "ActivityIndicatorViewController.h"
#import "ChargerTableViewController.h"

@interface SearchTableViewController (){
    SearchTableViewCell             *cell;
    NSMutableArray                  *objectsItemArray;
    ActivityIndicatorViewController *AIVC;
    ChargerTableViewController      *CTVC;
}

@end

@implementation SearchTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    AIVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ActivityIndicator"];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Search" style:UIBarButtonItemStylePlain target:self action:@selector(searchOpenCharger)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    //turn on BLE
    self.OC = [[OpenChargerSDK alloc] init];
    [self.OC controlSetup];

    [self.OC didPowerOnBlock:^(id response, NSError *error) {
        [self searchOpenCharger];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if(self.OC.peripherals!=nil)
    {
        return [self.OC.peripherals count];
    }
    else
    {
		return 0;
	}
}

- (void)searchOpenCharger{
    [self.view addSubview:AIVC.view];
    double timeout = 3;
    [self.OC findBLEPeripherals:timeout];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeout * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.tableView reloadData];
        [AIVC.view removeFromSuperview];
        
    });
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"SearchCell";
    cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[SearchTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    CBPeripheral *thisPeripheral = [self.OC.peripherals objectAtIndex:indexPath.row];
    cell.nameLabel.text = thisPeripheral.name;
    
    NSString *identifierString = [NSString stringWithFormat:@"%@", thisPeripheral.identifier];
    NSArray *uuidArray = [identifierString componentsSeparatedByString:@" "];
    NSString *thisUUID = [uuidArray objectAtIndex:2];
    cell.uuidLabel.text = thisUUID;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CTVC  = [self.storyboard instantiateViewControllerWithIdentifier:@"ChargerTable"];
    CTVC.OC = self.OC;
    CTVC.thisPeripheral = [self.OC.peripherals objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:CTVC animated:YES];
}

@end
