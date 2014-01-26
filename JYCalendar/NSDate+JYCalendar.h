//
//  NSDate+JYCalendar.h
//  JYCalendar
//
//  Created by Justin Yang on 14-1-17.
//  Copyright (c) 2014年 Nanjing University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (JYCalendar)

- (NSInteger)year;
- (NSInteger)month;
- (NSInteger)day;
- (NSInteger)hour;
- (NSUInteger)week;

- (BOOL)isAM;

- (NSUInteger)weekday;
- (NSString *)weekdayName;

- (NSString *)monthName;

- (NSDate *)offsetDay:(int)numDays;

- (NSString *)description:(NSString *)format;

+ (NSDate *)dateForDay:(NSUInteger)day month:(NSUInteger)month year:(NSUInteger)year;

+ (NSDate *)dateFromString:(NSString *)dateString format:(NSString *)format;

- (NSDateComponents *)dateComponents;
+ (NSDateComponents *)currentDateComponents;
+ (NSDateComponents *)dateComponentsFromNow:(NSInteger)days;

- (NSUInteger)numberOfDaysInMonth;

@end

@interface NSDate (JYUtility)

- (BOOL)isToday;

+ (NSInteger)dayBetweenStartDate:(NSDate *)startDate endDate:(NSDate *)endDate;

- (NSDate *)nextDay;
- (NSDate *)previousDay;

- (NSDate *)firstDayOfTheWeek;
- (NSDate *)lastDayOfTheWeek;

- (NSDate *)firstDateOfTheMonth;
- (NSDate *)dateByMovingToPreviousMonth;
- (NSDate *)dateByMovingToNextMonth;

- (NSDate *)dateByMovingToPreviousYear;
- (NSDate *)dateByMovingToNextYear;

@end
