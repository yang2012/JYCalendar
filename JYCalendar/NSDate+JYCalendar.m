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
    NSDateComponents *components        = [gregorian components:NSYearCalendarUnit fromDate:self];
    return [components year];
}

- (NSInteger)month {
    NSCalendar *gregorian               = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components        = [gregorian components:NSMonthCalendarUnit fromDate:self];
    return [components month];
}

- (NSInteger)day {
    NSCalendar *gregorian               = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components        = [gregorian components:NSDayCalendarUnit fromDate:self];
    return [components day];
}

- (NSInteger)hour {
    NSCalendar *gregorian               = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components        = [gregorian components:NSHourCalendarUnit fromDate:self];
    return [components hour];
}

- (NSDate *)offsetDay:(int)numDays {
    NSCalendar *gregorian               = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *offsetComponents  = [[NSDateComponents alloc] init];
    [offsetComponents setDay:numDays];
    
    return [gregorian dateByAddingComponents:offsetComponents
                                      toDate:self options:0];
}

+ (NSDate *)dateForDay:(unsigned int)day month:(unsigned int)month year:(unsigned int)year
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
    [gregorian               components:(NSYearCalendarUnit | NSMonthCalendarUnit |
                                         NSDayCalendarUnit) fromDate:date];
    return [gregorian dateFromComponents:components];
}

- (NSUInteger)weekDay
{
    return [[NSCalendar currentCalendar] ordinalityOfUnit:NSDayCalendarUnit inUnit:NSWeekCalendarUnit forDate:self];
}

- (NSString *)weekString {
    NSCalendar *calendar                = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *dateComponents    = [calendar components:NSCalendarUnitWeekday fromDate:self];
    switch (dateComponents.weekday) {
        case 1: {
            return NSLocalizedString(@"sunday", @"");
        }
            break;
            
        case 2: {
            return NSLocalizedString(@"monday", @"");
        }
            break;
            
        case 3: {
            return NSLocalizedString(@"tuesday", @"");
        }
            break;
            
        case 4: {
            return NSLocalizedString(@"wednesday", @"");
        }
            break;
            
        case 5: {
            return NSLocalizedString(@"thursday", @"");
        }
            break;
            
        case 6: {
            return NSLocalizedString(@"friday", @"");
        }
            break;
            
        case 7: {
            return NSLocalizedString(@"saturday", @"");
        }
            break;
            
        default:
            break;
    }
    
    return @"";
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
    
    NSInteger flags                     = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
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
    NSInteger flags                     = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    return [calendar components:flags fromDate:self];
}

+ (NSDateComponents *)currentDateComponents {
    NSCalendar *calendar                = [NSCalendar currentCalendar];
    NSInteger flags                     = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    return [calendar components:flags fromDate:[NSDate date]];
}

+ (NSDateComponents *)dateComponentsFromNow:(NSInteger)days {
    NSCalendar *calendar                = [NSCalendar currentCalendar];
    NSInteger flags                     = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    return [calendar components:flags fromDate:[[NSDate date] dateByAddingTimeInterval:days * 24 * 60 * 60]];
}

- (NSUInteger)numberOfDaysInMonth
{
    return [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:self].length;
}

@end

@implementation NSDate (JYUtility)

- (BOOL)isToday
{
    NSCalendar *cal                     = [NSCalendar currentCalendar];
    NSDateComponents *components        = [cal components:(NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:[NSDate date]];
    NSDate *today                       = [cal dateFromComponents:components];
    components                          = [cal components:(NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:self];
    NSDate *otherDate                   = [cal dateFromComponents:components];
    
    if([today isEqualToDate:otherDate]) {
        return YES;
    } else {
        return NO;
    }
}

+ (NSInteger)dayBetweenStartDate:(NSDate *)startDate endDate:(NSDate *)endDate {
    NSCalendar *calendar                = [[NSCalendar alloc]
                                           initWithCalendarIdentifier:NSGregorianCalendar];
    unsigned int unitFlags              = NSDayCalendarUnit;
    NSDateComponents *comps             = [calendar components:unitFlags fromDate:startDate toDate:endDate options:0];
    int days                            = [comps day];
    return days;
}

- (NSDate *)firstDateOfTheMonth
{
    NSDate *firstDate                   = nil;
    [[NSCalendar currentCalendar] rangeOfUnit:NSMonthCalendarUnit startDate:&firstDate interval:NULL forDate:self];
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

@end

