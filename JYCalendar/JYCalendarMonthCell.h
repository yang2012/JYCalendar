//
//  JYCalendarMonthCell.h
//  JYCalendar
//
//  Created by Justin Yang on 14-1-18.
//  Copyright (c) 2014年 Nanjing University. All rights reserved.
//

#import "JYCalendarWeekView.h"
#import "JYEventEntity.h"
#import "JYDateEntity.h"

@class JYCalendarMonthCell;

@protocol JYCalendarMonthCellDelegate <NSObject>

- (void)monthCell:(JYCalendarMonthCell *)monthCell didSelectDate:(JYDateEntity *)dateEntity;
- (NSArray *)monthCell:(JYCalendarMonthCell *)monthCell eventsForDate:(JYDateEntity *)dateEntity;
- (void)monthCell:(JYCalendarMonthCell *)monthCell didSelectEvent:(JYEventEntity *)event;

@end

@interface JYCalendarMonthCell : UICollectionViewCell

@property (nonatomic, weak) id<JYCalendarMonthCellDelegate> delegate;

- (void)setUpMonthWithDateEntities:(NSArray *)dateEntities;

- (void)toggleDetailViewForDate:(JYDateEntity *)dateEntity
                     completion:(void (^)(BOOL showed))finishedBlock;

- (void)hideDetailViewWithCompletion:(void (^)(BOOL showed))finishedBlock;

@end