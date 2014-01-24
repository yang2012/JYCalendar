//
//  JYCalendarWeekView.m
//  JYCalendar
//
//  Created by Justin Yang on 14-1-19.
//  Copyright (c) 2014年 Nanjing University. All rights reserved.
//

#import "JYCalendarWeekView.h"
#import "JYCalendarDateView.h"

@interface JYCalendarWeekView () <JYCalendarDateViewDelegate>

@property (nonatomic, assign) NSUInteger weekRow;

@end

@implementation JYCalendarWeekView

- (id)initWithWeekRow:(NSUInteger)weekRow
{
    self = [super init];
    
    if (self) {
        self.weekRow = weekRow;
        
        self.backgroundColor = [UIColor lightGrayColor];
        
        [self _addDateViews];
    }
    
    return self;
}

- (void)_addDateViews
{
    for (NSUInteger day = 1; day < 8; day++) {
        JYCalendarDateView *dateView = [[JYCalendarDateView alloc] init];
        dateView.tag = [self _tagForDateView:day];
        dateView.delegate = self;
        
        dateView.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:dateView];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect frame = self.bounds;
    
    CGFloat inset            = 0.25f;
    CGFloat widthOfDateView  = frame.size.width / 7.0;
    CGFloat heightOfDateView = frame.size.height;
    
    for (NSUInteger day = 1; day < 8; day++) {
        NSInteger tag = [self _tagForDateView:day];
        JYCalendarDateView *view  = (JYCalendarDateView *)[self viewWithTag:tag];
        view.frame    = CGRectMake(inset + widthOfDateView * (day - 1), inset, widthOfDateView - inset * 2, heightOfDateView - inset * 2);
        
        if (day == 1) {
            view.textColor = [UIColor colorWithHue:1.0f saturation:1.0f brightness:1.0f alpha:0.7f];
        } else {
            view.textColor = [UIColor blackColor];
        }
        
        view.showWeekDay = (self.weekRow == 1);

    }
}

- (void)setUpDates:(NSArray *)dateEntities
{
    NSInteger count = dateEntities.count;
    for (NSInteger day = 1; day < count + 1; day++) {
        JYDateEntity *dateEntity = dateEntities[day - 1];

        NSInteger tag = [self _tagForDateView:day];
        JYCalendarDateView *dateView = (JYCalendarDateView *)[self viewWithTag:tag];
        dateView.dateEntity = dateEntity;
    }
}

- (void)didTapAtdateView:(JYCalendarDateView *)dateView
{
    if ([self.delegate respondsToSelector:@selector(weekView:didTapDate:)]) {
        [self.delegate weekView:self didTapDate:dateView.dateEntity.date];
    }
}

- (NSInteger)_tagForDateView:(NSInteger)day
{
    return self.weekRow * 7 + day;
}

@end
