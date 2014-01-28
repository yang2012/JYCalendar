//
//  JYCalendarMonthCell.m
//  JYCalendar
//
//  Created by Justin Yang on 14-1-18.
//  Copyright (c) 2014年 Nanjing University. All rights reserved.
//

#import "JYCalendarMonthCell.h"
#import "JYCalendarWeekDetailView.h"

#import "JYDate.h"
#import "NSDate+JYCalendar.h"
#import "UIView+JYCalendar.h"

typedef enum {
    JYSlideDirectionTop,
    JYSlideDirectionDown,
    JYSlideDirectionBoth,
    JYSlideDirectionNone,
} JYSlideDirection;

static NSInteger kMaxWeekCount = 6;

@interface JYCalendarMonthCell () <JYCalendarWeekViewDelegate, JYCalendarWeekDetailViewDelegate>

@property (nonatomic, assign) BOOL animating;

@property (nonatomic, strong) JYDate *showedDateEntity;

@property (nonatomic, strong) JYCalendarWeekDetailView *detailView;

@property (nonatomic, strong) NSMutableArray *weekViews;
@property (nonatomic, assign) NSInteger realWeekCount;

@end

@implementation JYCalendarMonthCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _addSubviews];
        
        self.animating        = NO;
        self.showedDateEntity = nil;
        self.clipsToBounds    = YES;
        self.backgroundColor  = [UIColor lightGrayColor];
    }
    return self;
}

- (void)_addSubviews
{
    self.detailView = [[JYCalendarWeekDetailView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.width, 160.0f)];
    self.detailView.delegate = self;
    self.detailView.hidden = YES;
    [self.contentView addSubview:self.detailView];
    
    self.weekViews = [NSMutableArray arrayWithCapacity:kMaxWeekCount];
    for (NSInteger week = 0; week < kMaxWeekCount; week++) {
        JYCalendarWeekView *weekView = [[JYCalendarWeekView alloc] initWithWeek:week];
        weekView.delegate = self;
        [self.contentView addSubview:weekView];
        
        [self.weekViews addObject:weekView];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect frame = self.bounds;
    
    CGFloat widthOfWeekView = frame.size.width - 0.2f;
    CGFloat heightOfWeekView = frame.size.height / self.realWeekCount;
    
    for (NSUInteger index = 0; index < kMaxWeekCount; index++) {
        UIView *view = self.weekViews[index];
        view.frame = CGRectMake(0.0f, heightOfWeekView * index, widthOfWeekView, heightOfWeekView);
    }
    
    self.detailView.width = self.width;
}

- (void)setShowedDateEntity:(JYDate *)showedDateEntity
{
    if (_showedDateEntity) {
        [self _unhighlightDateWith:_showedDateEntity];
    }
    
    _showedDateEntity = showedDateEntity;
    
    if (showedDateEntity) {
        [self _highlightDateWith:showedDateEntity];
    }
}

- (void)setUpMonthWithDateEntities:(NSArray *)dateEntities
{
    NSUInteger dateCount = dateEntities.count;
    self.realWeekCount = dateEntities.count / 7;

    NSInteger weekIndex = 0;
    NSMutableArray *datesForWeek = [NSMutableArray arrayWithCapacity:7];
    for (NSUInteger date = 0; date < dateCount; date++) {
        JYDate *dateEntity = dateEntities[date];
        dateEntity.weekRow = weekIndex;
        [datesForWeek addObject:dateEntity];
        
        if (datesForWeek.count == 7) {
            JYCalendarWeekView *weekView = (JYCalendarWeekView *)self.weekViews[weekIndex];
            [weekView setUpDates:datesForWeek];
            
            // Clear for next week
            [datesForWeek removeAllObjects];
            weekIndex++;
        }
    }
    
    [self setNeedsLayout];
}

- (void)weekView:(JYCalendarWeekView *)weekView didTapDate:(JYDate *)dateEntity
{
    if ([self.delegate respondsToSelector:@selector(monthCell:didSelectDate:)]) {
        [self.delegate monthCell:self didSelectDate:dateEntity];
    }
}

- (void)toggleDetailViewForDate:(JYDate *)dateEntity
                     completion:(void (^)(BOOL))finishedBlock
{
    if (self.animating) {
        // Ignore tap gesture when animating
        return;
    }
    
    if ([self.showedDateEntity.date isEqualToDate:dateEntity.date]) {
        [self _hideDetailViewAnimated:YES completion:finishedBlock];
    } else {
        NSInteger weekRow = dateEntity.weekRow;
        NSInteger currentShowedWeekRow = self.showedDateEntity != nil ? self.showedDateEntity.weekRow : -1;
        
        if (weekRow != currentShowedWeekRow) {
            // Check whether need to hide detail view firstly
            if (self.showedDateEntity) {
                [self _hideDetailViewAnimated:YES completion:^(BOOL finished) {
                    [self _initAndShowDetailViewWithDateEntiry:dateEntity
                                                         atRow:weekRow
                                                    completion:finishedBlock];
                }];
            } else {
                [self _initAndShowDetailViewWithDateEntiry:dateEntity
                                                     atRow:weekRow
                                                completion:finishedBlock];
            }
        } else {
            [self _navigateToDay:dateEntity animated:YES];
            if (finishedBlock) {
                finishedBlock(YES);
            }
        }
    }
}

- (void)hideDetailViewAnimated:(BOOL)animated completion:(void (^)(BOOL))finishedBlock
{
    [self _hideDetailViewAnimated:animated completion:finishedBlock];
}

- (void)_initAndShowDetailViewWithDateEntiry:(JYDate *)dateEntity
                                       atRow:(NSInteger)row
                                  completion:(void (^)(BOOL))finishedBlock
{
    [self _setupDataForDetailViewWithDateEntity:dateEntity];
    [self _navigateToDay:dateEntity animated:NO];
    
    [self _showDetailViewAtRow:row completion:finishedBlock];
}

- (void)_setupDataForDetailViewWithDateEntity:(JYDate *)dateEntity
{
    NSMutableArray *events = [NSMutableArray arrayWithCapacity:7];
    if ([self.delegate respondsToSelector:@selector(monthCell:eventsForDate:)]) {
        NSDate *date = [dateEntity.date firstDayOfTheWeek];
        NSArray *eventsForDay = NULL;
        for (NSInteger dayCount = 0; dayCount < 7; dayCount++) {
            eventsForDay = [self.delegate monthCell:self eventsForDate:date];
            if (eventsForDay == NULL) {
                eventsForDay = [NSArray array];
            }
            [events addObject:eventsForDay];
            
            // next day
            date = [date nextDay];
        }
        
        self.detailView.eventsForWeek = events;
    }
}
             
- (void)_navigateToDay:(JYDate *)dateEntity
              animated:(BOOL)animated
{
    self.showedDateEntity = dateEntity;
    [self.detailView showWeekday:dateEntity.date.weekday animated:animated];
}

- (void)_unhighlightDateWith:(JYDate *)dateEntity
{
    JYCalendarWeekView *weekView = self.weekViews[dateEntity.weekRow];
    [weekView deselectDayAtWeekday:dateEntity.date.weekday - 1];
}

- (void)_highlightDateWith:(JYDate *)dateEntity
{
    JYCalendarWeekView *weekView = self.weekViews[dateEntity.weekRow];
    [weekView selectDayAtWeekday:dateEntity.date.weekday - 1];
}

- (void)_showDetailViewAtRow:(NSInteger)row
                  completion:(void (^)(BOOL finished))finishedBlock
{
    self.animating = YES;
    
    CGFloat heightOfDetailView = self.detailView.bounds.size.height;
    CGFloat halfHeightOfDetailView = heightOfDetailView / 2;
    
    NSMutableArray *newYPositions = [NSMutableArray arrayWithCapacity:kMaxWeekCount];
    NSInteger middleRow = self.realWeekCount / 2;
    if (row < middleRow) {
        for (NSUInteger index = 0; index < kMaxWeekCount; index++) {
            JYCalendarWeekView *weekView = (JYCalendarWeekView *)self.weekViews[index];
            if (index <= row) {
                [newYPositions addObject:@(weekView.y)];
            } else {
                [newYPositions addObject:@(weekView.y + heightOfDetailView)];
            }
        }
        
        JYCalendarWeekView *anchorView = (JYCalendarWeekView *)self.weekViews[row];
        self.detailView.y = anchorView.y + anchorView.height;
    } else if ((self.realWeekCount % 2 == 0 && (row == middleRow || row == middleRow + 1))
               || (self.realWeekCount % 2 != 0 && (row == middleRow))
               ) {
        for (NSUInteger index = 0; index < kMaxWeekCount; index++) {
            JYCalendarWeekView *weekView = (JYCalendarWeekView *)self.weekViews[index];
            if (index <= row) {
                [newYPositions addObject:@(weekView.y - halfHeightOfDetailView)];
            } else {
                [newYPositions addObject:@(weekView.y + halfHeightOfDetailView)];
            }
        }
        
        JYCalendarWeekView *anchorView = (JYCalendarWeekView *)self.weekViews[row + 1];
        self.detailView.y = anchorView.y - halfHeightOfDetailView;
    } else if (row != self.realWeekCount - 1) {
        for (NSUInteger index = 0; index < kMaxWeekCount; index++) {
            JYCalendarWeekView *weekView = (JYCalendarWeekView *)self.weekViews[index];
            if (index > row) {
                [newYPositions addObject:@(weekView.y)];
            } else {
                [newYPositions addObject:@(weekView.y - heightOfDetailView)];
            }
        }
        
        JYCalendarWeekView *anchorView = (JYCalendarWeekView *)self.weekViews[row + 1];
        self.detailView.y = anchorView.y - heightOfDetailView;
    } else {
        for (NSUInteger index = 0; index < self.realWeekCount; index++) {
            JYCalendarWeekView *weekView = (JYCalendarWeekView *)self.weekViews[index];
            [newYPositions addObject:@(weekView.y - heightOfDetailView)];
        }
        
        if (self.realWeekCount != kMaxWeekCount) {
            JYCalendarWeekView *extraWeekView = (JYCalendarWeekView *)self.weekViews[kMaxWeekCount - 1];
            [newYPositions addObject:@(extraWeekView.y)];
        }
        
        self.detailView.y = self.height - heightOfDetailView;
    }

    self.detailView.hidden = NO;
    
    [UIView animateWithDuration:0.3 animations:^{
        for (NSInteger index = 0; index < kMaxWeekCount; index++) {
            JYCalendarWeekView *weekView = (JYCalendarWeekView *)self.weekViews[index];
            weekView.y = [(NSNumber *)newYPositions[index] floatValue];
        }
    } completion:^(BOOL finished) {
        self.animating = NO;
        
        if (finishedBlock) {
            finishedBlock(YES);
        }
    }];
}

- (void)_hideDetailViewAnimated:(BOOL)animated completion:(void (^)(BOOL showed))finishedBlock
{
    self.animating = YES;
    [UIView animateWithDuration:0.3 animations:^{
        CGFloat inset = 0.0f;
        CGFloat heightOfWeekView = self.frame.size.height / self.realWeekCount;
        
        for (NSUInteger index = 0; index < kMaxWeekCount; index++) {
            UIView *view = self.weekViews[index];
            view.y = inset + heightOfWeekView * index;
        }
    } completion:^(BOOL finished) {
        self.animating         = NO;
        self.showedDateEntity  = nil;
        self.detailView.hidden = YES;

        if (finishedBlock) {
            finishedBlock(NO);
        }
    }];
}

#pragma mark - JYCalendarWeekDetailViewDelegate

- (void)weekDetailViewDidNavigateToPreviousDay:(JYCalendarWeekDetailView *)detailView
{
    JYDate *newDateEntity = [[JYDate alloc] init];
    newDateEntity.date = [self.showedDateEntity.date previousDay];
    newDateEntity.weekRow = self.showedDateEntity.weekRow;
    newDateEntity.visible = self.showedDateEntity.visible;
    self.showedDateEntity = newDateEntity;
}

- (void)weekDetailViewDidNavigateToNextDay:(JYCalendarWeekDetailView *)detailView
{
    JYDate *newDateEntity = [[JYDate alloc] init];
    newDateEntity.date = [self.showedDateEntity.date nextDay];
    newDateEntity.weekRow = self.showedDateEntity.weekRow;
    newDateEntity.visible = self.showedDateEntity.visible;
    self.showedDateEntity = newDateEntity;
}

@end
