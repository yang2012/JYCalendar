//
//  JYCalendarUtil.m
//  JYCalendar
//
//  Created by Justin Yang on 14-1-17.
//  Copyright (c) 2014年 Nanjing University. All rights reserved.
//

#import "JYCalendarUtil.h"
#import "NSDate+JYCalendar.h"

@implementation JYCalendarUtil

+ (NSArray *)daysInMonth:(NSDate *)date
{
    NSMutableArray *days             = [NSMutableArray array];
    
    NSUInteger numDays               = [date numberOfDaysInMonth];
    NSDateComponents *component      = [date dateComponents];
    
    for (int day = 1; day < numDays + 1; day++) {
        [days addObject:[NSDate dateForDay:day month:component.month year:component.year]];
    }
    
    return days;
}

+ (NSArray *)daysInLastWeekOfPreviousMonth:(NSDate *)date
{
    NSMutableArray *days             = [NSMutableArray array];
    
    NSDate *dateOfPreviousMonth      = [date dateByMovingToPreviousMonth];
    NSInteger numOfDays              = [dateOfPreviousMonth numberOfDaysInMonth];
    NSUInteger numPartialDays        = [JYCalendarUtil _numberOfDaysInPreviousPartialWeek:[date firstDateOfTheMonth]];
    NSDateComponents *component      = [dateOfPreviousMonth dateComponents];
    
    for (int i = numOfDays - (numPartialDays - 1); i < numOfDays + 1; i++) {
        [days addObject:[NSDate dateForDay:i month:component.month year:component.year]];
    }
    
    return days;
}

+ (NSArray *)daysInFirstWeekOfNextMonth:(NSDate *)date
{
    NSMutableArray *days             = [NSMutableArray array];
    
    NSDateComponents *component      = [[date dateByMovingToNextMonth] dateComponents];
    NSUInteger numPartialDays        = [JYCalendarUtil _numberOfDaysInNextPartialWeek:date];
    for (int i = 1; i < numPartialDays + 1; i++) {
        [days addObject:[NSDate dateForDay:i month:component.month year:component.year]];
    }
    
    return days;
}

+ (NSUInteger)_numberOfDaysInPreviousPartialWeek:(NSDate *)date
{
    int num = [date week] - 1;
    if (num == 0) {
        num = 7;
    }
    return num;
}

+ (NSUInteger)_numberOfDaysInNextPartialWeek:(NSDate *)date
{
    NSDateComponents *component      = [date dateComponents];
    component.day                    = [date numberOfDaysInMonth];
    NSDate *lastDayOfTheMonth        = [[NSCalendar currentCalendar] dateFromComponents:component];
    
    int num = 7 - [lastDayOfTheMonth week];
    if (num == 0) {
        num = 7;
    }
    return num;
}

@end
