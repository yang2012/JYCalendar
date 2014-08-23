//
//  NSDate+JYCalendar.m
//  JYCalendar
//
//  Created by Justin Yang on 14-1-17.
//  Copyright (c) 2014年 Nanjing University. All rights reserved.
//

#import "NSDate+JYCalendar.h"

@implementation NSDate (JYCalendar)

- (NSInteger)year {
    NSCalendar *gregorian               = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components        = [gregorian components:NSCalendarUnitYear fromDate:self];
    return [components year];
}

- (NSInteger)month {
    NSCalendar *gregorian               = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components        = [gregorian components:NSCalendarUnitMonth fromDate:self];
    return [components month];
}

- (NSInteger)day {
    NSCalendar *gregorian               = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components        = [gregorian components:NSCalendarUnitDay fromDate:self];
    return [components day];
}

- (NSInteger)hour {
    NSCalendar *gregorian               = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components        = [gregorian components:NSCalendarUnitHour fromDate:self];
    return [components hour];
}

- (BOOL)isAM {
    NSCalendar *gregorian               = [[NSCalendar alloc]
                                           initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components        = [gregorian components:NSCalendarUnitHour fromDate:self];
    NSInteger hour = [components hour];
    return hour < 12;
}

- (NSDate *)offsetDay:(int)numDays {
    NSCalendar *gregorian               = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *offsetComponents  = [[NSDateComponents alloc] init];
    [offsetComponents setDay:numDays];
    
    return [gregorian dateByAddingComponents:offsetComponents
                                      toDate:self options:0];
}

+ (NSDate *)dateForDay:(NSUInteger)day month:(NSUInteger)month year:(NSUInteger)year
{
    NSCalendar *gregorian               = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components        = [[NSDateComponents alloc] init];
    components.day                      = day;
    components.month                    = month;
    components.year                     = year;
    return [gregorian dateFromComponents:components];
}

+ (NSDate *)dateStartOfDay:(NSDate *)date {
    NSCalendar *gregorian               = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *components =
    [gregorian               components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [gregorian dateFromComponents:components];
}

- (NSUInteger)week
{
    return [[NSCalendar currentCalendar] ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitWeekOfMonth forDate:self];
}

- (NSUInteger)weekday
{
    NSCalendar *calendar                = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *dateComponents    = [calendar components:NSCalendarUnitWeekday fromDate:self];
    return dateComponents.weekday;
}

- (NSString *)weekdayName {
    NSCalendar *calendar                = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *dateComponents    = [calendar components:NSCalendarUnitWeekday fromDate:self];
    NSString *name = @"";
    switch (dateComponents.weekday) {
        case 1:
            name = NSLocalizedString(@"Sun", @"");
            break;
        case 2:
            name = NSLocalizedString(@"Mon", @"");
            break;
        case 3:
            name = NSLocalizedString(@"Tue", @"");
            break;
        case 4:
            name = NSLocalizedString(@"Wed", @"");
            break;
        case 5:
            name = NSLocalizedString(@"Thi", @"");
            break;
        case 6:
            name = NSLocalizedString(@"Fri", @"");
            break;
        case 7:
            name = NSLocalizedString(@"Sat", @"");
            break;
        default:
            name = @"";
            break;
    }
    
    return name;
}

- (NSString *)monthName
{
    NSCalendar *calendar                = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *dateComponents    = [calendar components:NSCalendarUnitMonth fromDate:self];
    NSString *name = @"";
    switch (dateComponents.month) {
        case 1:
            name = NSLocalizedString(@"Jan", @"");
            break;
        case 2:
            name = NSLocalizedString(@"Feb", @"");
            break;
        case 3:
            name = NSLocalizedString(@"Mar", @"");
            break;
        case 4:
            name = NSLocalizedString(@"Apr", @"");
            break;
        case 5:
            name = NSLocalizedString(@"May", @"");
            break;
        case 6:
            name = NSLocalizedString(@"Jun", @"");
            break;
        case 7:
            name = NSLocalizedString(@"Jul", @"");
            break;
        case 8:
            name = NSLocalizedString(@"Aug", @"");
            break;
        case 9:
            name = NSLocalizedString(@"Sep", @"");
            break;
        case 10:
            name = NSLocalizedString(@"Oct", @"");
            break;
        case 11:
            name = NSLocalizedString(@"Nov", @"");
            break;
        case 12:
            name = NSLocalizedString(@"Dec", @"");
            break;
        default:
            name = @"";
            break;
    }
    
    return name;
}

- (NSString *)description:(NSString *)format {
    if (!format) {
    format                              = @"yyyy-MM-dd";
    }
    NSDateFormatter *dateFormatter      = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSString *dateString                = [dateFormatter stringFromDate:self];
    return dateString;
}


+ (NSDate *)dateFromString:(NSString *)dateString format:(NSString *)format {
    if (!format) {
    format                              = @"yyyy-MM-dd";
    }
    NSDateFormatter *dateFormatter      = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSDate *date                        = [dateFormatter dateFromString:dateString];
    return date;
}

+ (NSDate *)dateFromStringBySpecifyTime:(NSString *)dateString hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second {
    NSArray *arrayDayTime               = [dateString componentsSeparatedByString:@" "];
    NSArray *arrayDay                   = [arrayDayTime[0] componentsSeparatedByString:@"-"];
    
    NSInteger flags                     = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSCalendar *calendar                = [NSCalendar currentCalendar];
    NSDateComponents *tmpDateComponents = [calendar components:flags fromDate:[NSDate date]];
    tmpDateComponents.year              = [arrayDay[0] intValue];
    tmpDateComponents.month             = [arrayDay[1] intValue];
    tmpDateComponents.day               = [arrayDay[2] intValue];
    if ([arrayDayTime count] > 1) {
    NSArray *arrayTime                  = [arrayDayTime[1] componentsSeparatedByString:@":"];
    tmpDateComponents.hour              = [arrayTime[0] intValue];
    tmpDateComponents.minute            = [arrayTime[1] intValue];
    tmpDateComponents.second            = [arrayTime[2] intValue];
    }
    else {
    tmpDateComponents.hour              = hour;
    tmpDateComponents.minute            = minute;
    tmpDateComponents.second            = second;
    }
    return [calendar dateFromComponents:tmpDateComponents];
}

- (NSDateComponents *)dateComponents {
    NSCalendar *calendar                = [NSCalendar currentCalendar];
    NSInteger flags                     = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    return [calendar components:flags fromDate:self];
}

+ (NSDateComponents *)currentDateComponents {
    NSCalendar *calendar                = [NSCalendar currentCalendar];
    NSInteger flags                     = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    return [calendar components:flags fromDate:[NSDate date]];
}

+ (NSDateComponents *)dateComponentsFromNow:(NSInteger)days {
    NSCalendar *calendar                = [NSCalendar currentCalendar];
    NSInteger flags                     = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    return [calendar components:flags fromDate:[[NSDate date] dateByAddingTimeInterval:days * 24 * 60 * 60]];
}

- (NSUInteger)numberOfDaysInMonth
{
    return [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self].length;
}

@end

@implementation NSDate (JYUtility)

- (BOOL)isToday
{
    NSCalendar *cal                     = [NSCalendar currentCalendar];
    NSDateComponents *components        = [cal components:(NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:[NSDate date]];
    NSDate *today                       = [cal dateFromComponents:components];
    components                          = [cal components:(NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:self];
    NSDate *otherDate                   = [cal dateFromComponents:components];
    
    if([today isEqualToDate:otherDate]) {
        return YES;
    } else {
        return NO;
    }
}

+ (NSInteger)dayBetweenStartDate:(NSDate *)startDate endDate:(NSDate *)endDate {
    NSCalendar *calendar    = [[NSCalendar alloc]
                                           initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [calendar components:NSCalendarUnitDay fromDate:startDate toDate:endDate options:0];
    NSUInteger days         = [comps day];
    return days;
}

- (NSDate *)nextDay
{
    return [self offsetDay:1];
}

- (NSDate *)previousDay
{
    return [self offsetDay:-1];
}

- (NSDate *)firstDayOfTheWeek
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitWeekOfYear fromDate:self];
    components.weekday = 1;
    return [calendar dateFromComponents:components];
}

- (NSDate *)lastDayOfTheWeek
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitWeekOfYear fromDate:self];
    components.weekday = 7;
    return [calendar dateFromComponents:components];
}

- (NSDate *)firstDateOfTheMonth
{
    NSDate *firstDate                   = nil;
    [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitMonth startDate:&firstDate interval:NULL forDate:self];
    return firstDate;
}

- (NSDate *)dateByMovingToPreviousMonth
{
    NSDateComponents *component         = [[NSDateComponents alloc] init];
    component.month                     = -1;
    return [[NSCalendar currentCalendar] dateByAddingComponents:component toDate:self options:0];
}

- (NSDate *)dateByMovingToNextMonth
{
    NSDateComponents *component         = [[NSDateComponents alloc] init];
    component.month                     = 1;
    return [[NSCalendar currentCalendar] dateByAddingComponents:component toDate:self options:0];
}

- (NSDate *)dateByMovingToPreviousYear
{
    NSDateComponents *component         = [[NSDateComponents alloc] init];
    component.year                      = -1;
    return [[NSCalendar currentCalendar] dateByAddingComponents:component toDate:self options:0];
}

- (NSDate *)dateByMovingToNextYear
{
    NSDateComponents *component         = [[NSDateComponents alloc] init];
    component.year                      = 1;
    return [[NSCalendar currentCalendar] dateByAddingComponents:component toDate:self options:0];
}

@end

