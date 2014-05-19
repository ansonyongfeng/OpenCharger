//
//  SecondViewController.m
//  OCMessage
//
//  Created by YongfengHe on 16.05.14.
//  Copyright (c) 2014 Yongfeng He. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.uuid1.delegate = self;
    self.uuid2.delegate = self;
    self.uuid3.delegate = self;
    self.uuid4.delegate = self;
    self.uuid5.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    if (textField.tag == 1) {
        
        return (newLength > 10) ? NO : YES;
    }
    else if (textField.tag == 2 || textField.tag == 3 || textField.tag == 4){
        return (newLength > 4) ? NO : YES;
    }
    else if (textField.tag == 5){
        return (newLength > 12) ? NO : YES;
    }
    else{
        return YES;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(textField == self.uuid1) {
        [self.uuid2 becomeFirstResponder];
    } else if(textField == self.uuid2) {
        [self.uuid3 becomeFirstResponder];
    }else if(textField == self.uuid3) {
        [self.uuid4 becomeFirstResponder];
    }else if(textField == self.uuid4) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.35f];
        CGRect frame = self.view.frame;
        frame.origin.y = -100;
        [self.view setFrame:frame];
        [UIView commitAnimations];
        [self.uuid5 becomeFirstResponder];
    }else{
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.35f];
        CGRect frame = self.view.frame;
        frame.origin.y = 0;
        [self.view setFrame:frame];
        [UIView commitAnimations];
        [textField resignFirstResponder];
    }
    return NO;
}

- (IBAction)saveButtonPressed:(id)sender {
}
@end
