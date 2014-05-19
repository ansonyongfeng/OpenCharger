//
//  FirstViewController.m
//  OCMessage
//
//  Created by YongfengHe on 16.05.14.
//  Copyright (c) 2014 Yongfeng He. All rights reserved.
//

#import "FirstViewController.h"
#import "AddMessageViewController.h"

@interface FirstViewController (){
    AddMessageViewController *AMVC;
}

@end

@implementation FirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStylePlain target:self action:@selector(addMessage)];
    self.navigationItem.rightBarButtonItem = anotherButton;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addMessage{
    AMVC = [self.storyboard instantiateViewControllerWithIdentifier:@"Add"];
    [self.navigationController pushViewController:AMVC animated:YES];
}

@end
