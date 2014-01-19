//
//  JYDateEntity.m
//  JYCalendar
//
//  Created by Justin Yang on 14-1-18.
//  Copyright (c) 2014年 Nanjing University. All rights reserved.
//

#import "JYDateEntity.h"
#import "NSDate+JYCalendar.h"

@implementation JYDateEntity

- (NSString *)formatDate
{
    NSString *description = @"";
    if (self.date) {
        description = [NSString stringWithFormat:@"%d", self.date.day];
    }
    return description;
}

@end
