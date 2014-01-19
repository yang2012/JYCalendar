//
//  JYCalendarMonthCell.m
//  JYCalendar
//
//  Created by Justin Yang on 14-1-18.
//  Copyright (c) 2014年 Nanjing University. All rights reserved.
//

#import "JYCalendarMonthCell.h"
#import "JYCalendarDateView.h"

static const NSInteger kNumOfWeek = 5;

@implementation JYCalendarMonthCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        
        for (NSUInteger week = 0; week < kNumOfWeek; week++) {
            for (NSUInteger day = 1; day < 8; day++) {
                JYCalendarDateView *dateView = [[JYCalendarDateView alloc] init];
                dateView.tag = week * 7 + day;
                
                CGFloat hue = (CGFloat)day / 7;
                dateView.backgroundColor = [UIColor
                                            colorWithHue:hue saturation:1.0f brightness:0.8f alpha:1.0f
                                            ];
                
                [self addSubview:dateView];
            }
        }
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect frame = self.bounds;
    
    CGFloat inset            = 2.0f;
    CGFloat widthOfDateView  = frame.size.width / 7.0;
    CGFloat heightOfDateView = frame.size.height / kNumOfWeek;
    
    for (NSUInteger week = 0; week < kNumOfWeek; week++) {
        for (NSUInteger day = 1; day < 8; day++) {
            NSInteger tag = week * 7 + day;
            UIView *view  = [self viewWithTag:tag];
            
            view.frame    = CGRectMake(inset + widthOfDateView * (day - 1), inset + heightOfDateView * week, widthOfDateView - inset * 2, heightOfDateView - inset * 2);
        }
    }
}



- (void)setUpDatesForMonth:(NSArray *)dateEntities
              withDelegate:(id<JYCalendarDateViewDelegate>)delegate
{
    NSUInteger dateCount = dateEntities.count;
    for (NSUInteger date = 1; date < dateCount + 1; date++) {
        JYDateEntity *dateEntity = dateEntities[date - 1];
        
        JYCalendarDateView *dateView = (JYCalendarDateView *)[self viewWithTag:date];
        dateView.dateEntity = dateEntity;
        dateView.delegate = delegate;
    }
}

@end
