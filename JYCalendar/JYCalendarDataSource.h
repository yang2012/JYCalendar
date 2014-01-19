//
//  JYCalendarDataSource.h
//  JYCalendar
//
//  Created by Justin Yang on 14-1-17.
//  Copyright (c) 2014年 Nanjing University. All rights reserved.
//

@protocol JYCalendarDataSource <NSObject, UITableViewDataSource>

- (void)presentingDatesFrom:(NSDate *)fromDate to:(NSDate *)toDate;
- (void)loadItemsFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate;
- (void)removeAllItems;

@end

@interface JYCalendarDataSource : NSObject <JYCalendarDataSource>

@end
