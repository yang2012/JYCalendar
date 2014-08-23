//
//  JYCalendarUtil.h
//  JYCalendar
//
//  Created by Justin Yang on 14-1-17.
//  Copyright (c) 2014年 Nanjing University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JYCalendarUtil : NSObject

+ (NSArray *)daysInMonth:(NSDate *)date;
+ (NSArray *)daysInLastWeekOfPreviousMonth:(NSDate *)date;
+ (NSArray *)daysInFirstWeekOfNextMonth:(NSDate *)date;


@end
