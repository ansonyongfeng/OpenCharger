//
//  Messages.h
//  OpenCharger
//
//  Created by Yongfeng on 14-8-17.
//  Copyright (c) 2014年 Yongfeng He. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Messages : NSManagedObject

@property (nonatomic, retain) NSString  * id;
@property (nonatomic, retain) NSString  * message;
@property (nonatomic, retain) NSString  * entry;
@property (nonatomic, retain) NSString  * power;
@property (nonatomic, retain) NSString  * allday;
@property (nonatomic, retain) NSString  * start;
@property (nonatomic, retain) NSString  * active;

@end
