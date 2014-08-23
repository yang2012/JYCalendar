//
//  JYDateEntity.m
//  JYCalendar
//
//  Created by Justin Yang on 14-1-18.
//  Copyright (c) 2014年 Nanjing University. All rights reserved.
//

#import "JYDate.h"
#import "NSDate+JYCalendar.h"

@implementation JYDate

- (NSString *)formatDate
{
    NSString *description = @"";
    if (self.date) {
        description = [NSString stringWithFormat:@"%ld", (long)self.date.day];
    }
    return description;
}

@end
