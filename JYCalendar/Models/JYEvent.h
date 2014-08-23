//
//  JYEventEntity.h
//  JYCalendar
//
//  Created by Justin Yang on 14-1-20.
//  Copyright (c) 2014年 Nanjing University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JYEvent : NSObject

@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;

@end
