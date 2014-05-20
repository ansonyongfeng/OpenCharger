//
//  ThirdViewController.h
//  OCMessage
//
//  Created by Yongfeng on 14-5-20.
//  Copyright (c) 2014年 Yongfeng He. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OpenCharger SDK/OpenChargerSDK.h"
#import "OpenCharger SDK/OCDefines.h"

@interface ThirdViewController : UIViewController

@property (nonatomic, strong) OpenChargerSDK *OC;

@property (weak, nonatomic) IBOutlet UILabel *chargeTimeLabel;
@end
