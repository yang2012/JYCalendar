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

static const NSInteger kNumOfWeek = 5;

typedef enum {
    JYSlideDirectionTop,
    JYSlideDirectionDown,
    JYSlideDirectionBoth,
    JYSlideDirectionNone,
} JYSlideDirection;

@interface JYCalendarMonthCell () <JYCalendarWeekViewDelegate>

@property (nonatomic, assign) BOOL animating;
@property (nonatomic, strong) NSDate *showedDate;
@property (nonatomic, assign) NSInteger showedWeekRow;
@property (nonatomic, strong) JYCalendarDateDetailView *detailView;

@property (nonatomic, strong) JYCalendarWeekView *firstWeekView;
@property (nonatomic, strong) JYCalendarWeekView *secondWeekView;
@property (nonatomic, strong) JYCalendarWeekView *thirdWeekView;
@property (nonatomic, strong) JYCalendarWeekView *fourthWeekView;
@property (nonatomic, strong) JYCalendarWeekView *fifthWeekView;

@end

@implementation JYCalendarMonthCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        
        [self _addSubviews];
    }
    return self;
}

- (void)_addSubviews
{
    self.detailView = [[JYCalendarDateDetailView alloc] init];
    self.detailView.hidden = YES;
    [self addSubview:self.detailView];
    
    self.firstWeekView = [[JYCalendarWeekView alloc] initWithWeekRow:1];
    self.firstWeekView.delegate = self;
    self.firstWeekView.tag = [self _tagForWeekView:1];
    [self addSubview:self.firstWeekView];
    
    self.secondWeekView = [[JYCalendarWeekView alloc] initWithWeekRow:2];
    self.secondWeekView.delegate = self;
    self.secondWeekView.tag = [self _tagForWeekView:2];
    [self addSubview:self.secondWeekView];
    
    self.thirdWeekView = [[JYCalendarWeekView alloc] initWithWeekRow:3];
    self.thirdWeekView.delegate = self;
    self.thirdWeekView.tag = [self _tagForWeekView:3];
    [self addSubview:self.thirdWeekView];
    
    self.fourthWeekView = [[JYCalendarWeekView alloc] initWithWeekRow:4];
    self.fourthWeekView.delegate = self;
    self.fourthWeekView.tag = [self _tagForWeekView:4];
    [self addSubview:self.fourthWeekView];
    
    self.fifthWeekView = [[JYCalendarWeekView alloc] initWithWeekRow:5];
    self.fifthWeekView.delegate = self;
    self.fifthWeekView.tag = [self _tagForWeekView:5];
    [self addSubview:self.fifthWeekView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect frame = self.bounds;
    
    CGFloat widthOfWeekView = frame.size.width;
    CGFloat heightOfWeekView = frame.size.height / kNumOfWeek;
    
    for (NSUInteger week = 1; week < kNumOfWeek + 1; week++) {
        NSInteger tag = [self _tagForWeekView:week];
        UIView *view = [self viewWithTag:tag];
        view.frame = CGRectMake(0.0f, heightOfWeekView * (week - 1), widthOfWeekView, heightOfWeekView);
    }
    
    self.detailView.frame = CGRectMake(0.0f, 0.0f, frame.size.width, 100.0f);
}

- (void)setUpDatesForMonth:(NSArray *)dateEntities
{
    NSUInteger dateCount = dateEntities.count;
    NSInteger week = 1;
    NSMutableArray *datesForWeek = [NSMutableArray arrayWithCapacity:7];
    for (NSUInteger date = 1; date < dateCount + 1; date++) {
        JYDateEntity *dateEntity = dateEntities[date - 1];
        [datesForWeek addObject:dateEntity];
        
        if (datesForWeek.count == 7) {
            NSInteger tag = [self _tagForWeekView:week];
            JYCalendarWeekView *weekView = (JYCalendarWeekView *)[self viewWithTag:tag];
            [weekView setUpDates:datesForWeek];
            
            // Clear for next week
            [datesForWeek removeAllObjects];
            week++;
        }
    }
}

- (void)weekView:(JYCalendarWeekView *)weekView didTapDate:(NSDate *)date
{
    if (self.animating) {
        // Ignore tap gesture when animating
        return;
    }
    
    if (self.showedDate && [self.showedDate isEqualToDate:date]) {
        [self _hideDetailView:nil];
    } else {
        NSInteger weekRow = weekView.weekRow;
        NSInteger currentShowedWeekRow = self.showedWeekRow;

        if (self.showedDate) {
            if (weekRow != currentShowedWeekRow) {
                // Check whether need to hide detail view firstly
                [self _hideDetailView:^(BOOL finished) {
                    [self _showDetailViewAtRow:weekRow];
                }];
            }
        } else {
            [self _showDetailViewAtRow:weekRow];
        }
        
        [self _updateDetailView:date];
    }
}

- (void)_showDetailViewAtRow:(NSInteger)row
{
    self.showedWeekRow = row;
    [self _slideWithBaseRow:row];
}

- (void)_updateDetailView:(NSDate *)date
{
    self.showedDate = date;
    NSLog(@"%@", date);
}

- (void)_slideWithBaseRow:(NSInteger)row
{
    self.animating = YES;
    
    CGFloat heightOfDetailView = self.detailView.bounds.size.height;
    CGFloat halfHeightOfDetailView = heightOfDetailView / 2;
    
    CGFloat yPositionOfFirstWeek, yPositionOfSecondWeek, yPositionOfThirdWeek, yPositionOfFourthWeek, yPositionOfFifthWeek;
    
    if (row == 1) {
        yPositionOfFirstWeek = self.firstWeekView.y;
        yPositionOfSecondWeek = self.secondWeekView.y + heightOfDetailView;
        yPositionOfThirdWeek = self.thirdWeekView.y + heightOfDetailView;
        yPositionOfFourthWeek = self.fourthWeekView.y + heightOfDetailView;
        yPositionOfFifthWeek = self.fifthWeekView.y + heightOfDetailView;
        
        self.detailView.y = self.firstWeekView.y + self.firstWeekView.height;
    } else if (row == 2) {
        yPositionOfFirstWeek = self.firstWeekView.y;
        yPositionOfSecondWeek = self.secondWeekView.y;
        yPositionOfThirdWeek = self.thirdWeekView.y + heightOfDetailView;
        yPositionOfFourthWeek = self.fourthWeekView.y + heightOfDetailView;
        yPositionOfFifthWeek = self.fifthWeekView.y + heightOfDetailView;
        
        self.detailView.y = self.secondWeekView.y + self.secondWeekView.height;
    } else if (row == 3) {
        yPositionOfFirstWeek = self.firstWeekView.y - halfHeightOfDetailView;
        yPositionOfSecondWeek = self.secondWeekView.y - halfHeightOfDetailView;
        yPositionOfThirdWeek = self.thirdWeekView.y - halfHeightOfDetailView;
        yPositionOfFourthWeek = self.fourthWeekView.y + halfHeightOfDetailView;
        yPositionOfFifthWeek = self.fifthWeekView.y + halfHeightOfDetailView;
        
        self.detailView.y = self.fourthWeekView.y - halfHeightOfDetailView;
    } else if (row == 4) {
        yPositionOfFirstWeek = self.firstWeekView.y - heightOfDetailView;
        yPositionOfSecondWeek = self.secondWeekView.y - heightOfDetailView;
        yPositionOfThirdWeek = self.thirdWeekView.y - heightOfDetailView;
        yPositionOfFourthWeek = self.fourthWeekView.y - heightOfDetailView;
        yPositionOfFifthWeek = self.fifthWeekView.y;
        
        self.detailView.y = self.fifthWeekView.y - self.fourthWeekView.height;
    } else {
        yPositionOfFirstWeek = self.firstWeekView.y - heightOfDetailView;
        yPositionOfSecondWeek = self.secondWeekView.y - heightOfDetailView;
        yPositionOfThirdWeek = self.thirdWeekView.y - heightOfDetailView;
        yPositionOfFourthWeek = self.fourthWeekView.y - heightOfDetailView;
        yPositionOfFifthWeek = self.fifthWeekView.y - heightOfDetailView;
        
        self.detailView.y = self.height - heightOfDetailView;
    }
    
    self.detailView.hidden = NO;
    
    [UIView animateWithDuration:1.0 animations:^{
        self.firstWeekView.y  = yPositionOfFirstWeek;
        self.secondWeekView.y = yPositionOfSecondWeek;
        self.thirdWeekView.y  = yPositionOfThirdWeek;
        self.fourthWeekView.y = yPositionOfFourthWeek;
        self.fifthWeekView.y  = yPositionOfFifthWeek;
    } completion:^(BOOL finished) {
        self.animating = NO;
    }];
}

- (void)_hideDetailView:(void (^)(BOOL finished))finishedBlock
{
    self.showedDate = nil;
    self.animating = YES;
    [UIView animateWithDuration:1.0 animations:^{
        CGFloat inset = 2.0f;
        CGFloat heightOfWeekView = self.frame.size.height / kNumOfWeek;
        
        for (NSUInteger week = 1; week < kNumOfWeek + 1; week++) {
            NSInteger tag = [self _tagForWeekView:week];
            UIView *view = [self viewWithTag:tag];
            view.y = inset + heightOfWeekView * (week - 1);
        }
    } completion:^(BOOL finished) {
        self.animating = NO;

        self.detailView.hidden = YES;

        if (finishedBlock) {
            finishedBlock(finished);
        }
    }];
}

- (NSInteger)_tagForWeekView:(NSUInteger)week;
{
    return week;
}

@end