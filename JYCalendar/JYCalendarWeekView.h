//
//  JYCalendarWeekView.h
//  JYCalendar
//
//  Created by Justin Yang on 14-1-19.
//  Copyright (c) 2014年 Nanjing University. All rights reserved.
//

@class JYCalendarWeekView;
@class JYDate;

@protocol JYCalendarWeekViewDelegate <NSObject>

- (void)weekView:(JYCalendarWeekView *)weekView didTapDate:(JYDate *)dateEntity;

@end

@interface JYCalendarWeekView : UIView

@property (nonatomic, weak) id<JYCalendarWeekViewDelegate> delegate;
@property (nonatomic, assign, readonly) NSUInteger week;

- (id)initWithWeek:(NSUInteger)week;

- (void)setUpDates:(NSArray *)dateEntities;

- (void)selectDayAtWeekday:(NSInteger)weekday;
- (void)deselectDayAtWeekday:(NSInteger)weekday;

@end
