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

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * message;

@end
