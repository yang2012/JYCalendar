//
//  JYCalendarWeekView.h
//  JYCalendar
//
//  Created by Justin Yang on 14-1-19.
//  Copyright (c) 2014年 Nanjing University. All rights reserved.
//

@class JYCalendarWeekView;

@protocol JYCalendarWeekViewDelegate <NSObject>

- (void)weekView:(JYCalendarWeekView *)weekView didTapDate:(NSDate *)date;

@end

@interface JYCalendarWeekView : UIView

@property (nonatomic, weak) id<JYCalendarWeekViewDelegate> delegate;
@property (nonatomic, assign, readonly) NSUInteger weekRow;

- (id)initWithWeekRow:(NSUInteger)weekRow;

- (void)setUpDates:(NSArray *)dateEntities;

@end
