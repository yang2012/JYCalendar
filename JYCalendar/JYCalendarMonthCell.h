//
//  JYCalendarMonthCell.h
//  JYCalendar
//
//  Created by Justin Yang on 14-1-18.
//  Copyright (c) 2014年 Nanjing University. All rights reserved.
//

#import "JYCalendarWeekView.h"
#import "JYEvent.h"
#import "JYDate.h"

@class JYCalendarMonthCell;

@protocol JYCalendarMonthCellDelegate <NSObject>

- (void)monthCell:(JYCalendarMonthCell *)monthCell didSelectDate:(JYDate *)dateEntity;
- (NSArray *)monthCell:(JYCalendarMonthCell *)monthCell eventsForDate:(NSDate *)date;
- (void)monthCell:(JYCalendarMonthCell *)monthCell didSelectEvent:(JYEvent *)event;

@end

@interface JYCalendarMonthCell : UICollectionViewCell

@property (nonatomic, weak) id<JYCalendarMonthCellDelegate> delegate;

- (void)setUpMonthWithDateEntities:(NSArray *)dateEntities;

- (void)toggleDetailViewForDate:(JYDate *)dateEntity
                     completion:(void (^)(BOOL showed))finishedBlock;

- (void)hideDetailViewAnimated:(BOOL)animated completion:(void (^)(BOOL showed))finishedBlock;

@end