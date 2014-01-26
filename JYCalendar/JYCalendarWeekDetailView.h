//
//  JYCalendarDateDetailView.h
//  JYCalendar
//
//  Created by Justin Yang on 14-1-19.
//  Copyright (c) 2014年 Nanjing University. All rights reserved.
//

@class JYCalendarWeekDetailView;

@protocol JYCalendarWeekDetailViewDelegate <NSObject>

- (void)weekDetailViewDidNavigateToPreviousDay:(JYCalendarWeekDetailView *)detailView;
- (void)weekDetailViewDidNavigateToNextDay:(JYCalendarWeekDetailView *)detailView;

@end

@interface JYCalendarWeekDetailView : UIView

@property (nonatomic, weak) id<JYCalendarWeekDetailViewDelegate> delegate;
@property (nonatomic, strong) NSArray *eventsForWeek;

- (void)showWeekday:(NSInteger)weekday animated:(BOOL)animated;

@end
