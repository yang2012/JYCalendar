//
//  JYCalendarMonthCell.m
//  JYCalendar
//
//  Created by Justin Yang on 14-1-18.
//  Copyright (c) 2014年 Nanjing University. All rights reserved.
//

#import "JYCalendarMonthCell.h"
#import "JYCalendarDateDetailView.h"
#import "JYDateEntity.h"
#import "NSDate+JYCalendar.h"
#import "UIView+JYCalendar.h"

typedef enum {
    JYSlideDirectionTop,
    JYSlideDirectionDown,
    JYSlideDirectionBoth,
    JYSlideDirectionNone,
} JYSlideDirection;

static NSInteger kMaxWeekCount = 6;

@interface JYCalendarMonthCell () <JYCalendarWeekViewDelegate>

@property (nonatomic, assign) BOOL animating;

@property (nonatomic, strong) NSDate *showedDate;
@property (nonatomic, assign) NSInteger showedWeekRow;
@property (nonatomic, strong) JYCalendarDateDetailView *detailView;

@property (nonatomic, strong) NSMutableArray *weekViews;
@property (nonatomic, assign) NSInteger realWeekCount;

@end

@implementation JYCalendarMonthCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _addSubviews];
        
        self.animating     = NO;
        self.showedDate    = nil;
        self.showedWeekRow = 0;
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)_addSubviews
{
    self.detailView = [[JYCalendarDateDetailView alloc] init];
    self.detailView.hidden = YES;
    [self.contentView addSubview:self.detailView];
    
    self.weekViews = [NSMutableArray arrayWithCapacity:kMaxWeekCount];
    for (NSInteger week = 0; week < kMaxWeekCount; week++) {
        JYCalendarWeekView *weekView = [[JYCalendarWeekView alloc] initWithWeekRow:week + 1];
        weekView.delegate = self;
        [self.contentView addSubview:weekView];
        
        [self.weekViews addObject:weekView];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect frame = self.bounds;
    
    CGFloat widthOfWeekView = frame.size.width;
    CGFloat heightOfWeekView = frame.size.height / self.realWeekCount;
    
    for (NSUInteger index = 0; index < kMaxWeekCount; index++) {
        UIView *view = self.weekViews[index];
        view.frame = CGRectMake(0.0f, heightOfWeekView * index, widthOfWeekView, heightOfWeekView);
    }
    
    self.detailView.frame = CGRectMake(0.0f, 0.0f, frame.size.width, 100.0f);
}

- (void)setUpMonthWithDateEntities:(NSArray *)dateEntities
{
    NSUInteger dateCount = dateEntities.count;
    self.realWeekCount = dateEntities.count / 7;

    NSInteger weekIndex = 0;
    NSMutableArray *datesForWeek = [NSMutableArray arrayWithCapacity:7];
    for (NSUInteger date = 1; date < dateCount + 1; date++) {
        JYDateEntity *dateEntity = dateEntities[date - 1];
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

- (void)weekView:(JYCalendarWeekView *)weekView didTapDate:(NSDate *)date
{
    if ([self.delegate respondsToSelector:@selector(monthCell:didSelectDate:)]) {
        JYDateEntity *dateEntity = [[JYDateEntity alloc] init];
        dateEntity.date = date;
        dateEntity.weekRow = weekView.weekRow;
        [self.delegate monthCell:self didSelectDate:dateEntity];
    }
}

- (void)toggleDetailViewForDate:(JYDateEntity *)dateEntity
                     completion:(void (^)(BOOL))finishedBlock
{
    if (self.animating) {
        // Ignore tap gesture when animating
        return;
    }
    
    if ([self.showedDate isEqualToDate:dateEntity.date]) {
        [self _hideDetailView:finishedBlock];
    } else {
        NSInteger weekRow = dateEntity.weekRow;
        NSInteger currentShowedWeekRow = self.showedWeekRow;
        
        if (weekRow != currentShowedWeekRow) {
            // Check whether need to hide detail view firstly
            [self _hideDetailView:^(BOOL finished) {
                [self _showDetailView:dateEntity atRow:weekRow completion:finishedBlock];
            }];
        } else {
            [self _showDetailView:dateEntity atRow:weekRow completion:finishedBlock];
        }
    }
}

- (void)hideDetailViewWithCompletion:(void (^)(BOOL))finishedBlock
{
    [self _hideDetailView:finishedBlock];
}

- (void)_showDetailView:(JYDateEntity *)dateEntity
                  atRow:(NSInteger)row
             completion:(void (^)(BOOL finished))finishedBlock;
{
    self.showedDate = dateEntity.date;
    
    NSArray *events = nil;
    if ([self.delegate respondsToSelector:@selector(monthCell:eventsForDate:)]) {
        events = [self.delegate monthCell:self eventsForDate:dateEntity];
    } else {
        events = [NSArray array];
    }
    
    [self _showAtRow:row completion:finishedBlock];
}

- (void)_showAtRow:(NSInteger)row
         completion:(void (^)(BOOL finished))finishedBlock;
{
    if (row == self.showedWeekRow) {
        // if at the same row, it need not to slide again
        finishedBlock(YES);
        return;
    }
    
    self.showedWeekRow = row;
    self.animating = YES;
    
    CGFloat heightOfDetailView = self.detailView.bounds.size.height;
    CGFloat halfHeightOfDetailView = heightOfDetailView / 2;
    
    NSMutableArray *newYPositions = [NSMutableArray arrayWithCapacity:kMaxWeekCount];
    NSInteger middleRow = lroundf(self.realWeekCount / 2.0);
    if (row < middleRow) {
        for (NSUInteger index = 0; index < kMaxWeekCount; index++) {
            JYCalendarWeekView *weekView = (JYCalendarWeekView *)self.weekViews[index];
            if (index + 1 <= row) {
                [newYPositions addObject:@(weekView.y)];
            } else {
                [newYPositions addObject:@(weekView.y + heightOfDetailView)];
            }
        }
        
        JYCalendarWeekView *anchorView = (JYCalendarWeekView *)self.weekViews[row - 1];
        self.detailView.y = anchorView.y + anchorView.height;
    } else if ((self.realWeekCount % 2 == 0 && (row == middleRow || row == middleRow + 1))
               || (self.realWeekCount % 2 != 0 && (row == middleRow))
               ) {
        for (NSUInteger index = 0; index < kMaxWeekCount; index++) {
            JYCalendarWeekView *weekView = (JYCalendarWeekView *)self.weekViews[index];
            if (index + 1 <= row) {
                [newYPositions addObject:@(weekView.y - halfHeightOfDetailView)];
            } else {
                [newYPositions addObject:@(weekView.y + halfHeightOfDetailView)];
            }
        }
        
        JYCalendarWeekView *anchorView = (JYCalendarWeekView *)self.weekViews[row];
        self.detailView.y = anchorView.y - halfHeightOfDetailView;
    } else if (row != self.realWeekCount) {
        for (NSUInteger index = 0; index < kMaxWeekCount; index++) {
            JYCalendarWeekView *weekView = (JYCalendarWeekView *)self.weekViews[index];
            if (index + 1 > row) {
                [newYPositions addObject:@(weekView.y)];
            } else {
                [newYPositions addObject:@(weekView.y - heightOfDetailView)];
            }
        }
        
        JYCalendarWeekView *anchorView = (JYCalendarWeekView *)self.weekViews[row];
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

- (void)_hideDetailView:(void (^)(BOOL showed))finishedBlock
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
        self.animating = NO;
        self.showedDate = nil;
        self.showedWeekRow = 0;
        self.detailView.hidden = YES;

        if (finishedBlock) {
            finishedBlock(NO);
        }
    }];
}

@end
