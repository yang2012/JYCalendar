//
//  JYCalendarDateView.m
//  JYCalendar
//
//  Created by Justin Yang on 14-1-18.
//  Copyright (c) 2014年 Nanjing University. All rights reserved.
//

#import "JYCalendarDateView.h"
#import "NSDate+JYCalendar.h"
#import "UIView+JYCalendar.h"

@interface JYCalendarDateView ()

@property (nonatomic, strong) UILabel *dayLabelView;
@property (nonatomic, strong) UILabel *weekLabelView;
@property (nonatomic, assign) BOOL showed;

@end

@implementation JYCalendarDateView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _addSubviews];
        self.showWeekDay = NO;
        self.showed      = NO;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}

- (void)_addSubviews
{
    self.dayLabelView = [[UILabel alloc] initWithFrame:CGRectMake(3.0f, 0.0f, 0.0f, 0.0f)];
    self.dayLabelView.textAlignment = NSTextAlignmentLeft;
    self.dayLabelView.font = [UIFont systemFontOfSize:13.0f];
    [self addSubview:self.dayLabelView];
    
    self.weekLabelView = [[UILabel alloc] init];
    self.weekLabelView.y = 4.0f;
    self.weekLabelView.textAlignment = NSTextAlignmentRight;
    self.weekLabelView.font = [UIFont systemFontOfSize:9.0f];
    [self addSubview:self.weekLabelView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.weekLabelView.x = self.width - self.weekLabelView.width - 3.0f;
}

- (void)setDateEntity:(JYDateEntity *)dateEntity
{
    _dateEntity = dateEntity;
    
    self.dayLabelView.text = dateEntity.formatDate;
    [self.dayLabelView sizeToFit];
    
    self.weekLabelView.text = dateEntity.date.weekDayName;
    [self.weekLabelView sizeToFit];
    
    [self setNeedsLayout];
}

- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    
    self.dayLabelView.textColor = textColor;
    self.weekLabelView.textColor = textColor;
}

- (void)setShowWeekDay:(BOOL)showWeekDay
{
    _showWeekDay = showWeekDay;
    
    if (showWeekDay) {
        self.weekLabelView.hidden = NO;
    } else {
        self.weekLabelView.hidden = YES;
    }
}

- (void)tap:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(didTapAtdateView:)]) {
        [self.delegate didTapAtdateView:self];
    }
}

@end
