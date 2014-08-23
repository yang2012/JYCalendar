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
@property (nonatomic, strong) UIView *selectedBackgroundView;

@end

@implementation JYCalendarDateView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _addSubviews];
        self.showWeekDay = NO;
        self.selected    = NO;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}

- (void)_addSubviews
{
    self.selectedBackgroundView = [UIView new];
    self.selectedBackgroundView.backgroundColor = [UIColor colorWithHue:0.61f saturation:0.5f brightness:1.0f alpha:0.2f];
    [self addSubview:self.selectedBackgroundView];
    
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
    self.selectedBackgroundView.width = self.width;
    self.selectedBackgroundView.height = self.height;
}

- (void)setDateEntity:(JYDate *)dateEntity
{
    _dateEntity = dateEntity;
    
    if (dateEntity.date.isToday) {
        self.backgroundColor = [UIColor colorWithHue:4/7.0f saturation:0.8f brightness:1.0f alpha:0.5f];
    } else {
        self.backgroundColor = [UIColor whiteColor];
    }
    
    if (dateEntity.visible) {
        self.alpha = 1.0f;
    } else {
        self.alpha = 0.8f;
    }
    
    self.dayLabelView.text = dateEntity.formatDate;
    [self.dayLabelView sizeToFit];
    
    self.weekLabelView.text = dateEntity.date.weekdayName;
    [self.weekLabelView sizeToFit];
    
    [self setNeedsLayout];
}

- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    
    self.dayLabelView.textColor = textColor;
    self.weekLabelView.textColor = textColor;
}

- (void)setSelected:(BOOL)selected
{
    _selected = selected;
    
    if (selected) {
        self.selectedBackgroundView.hidden = NO;
    } else {
        self.selectedBackgroundView.hidden = YES;
    }
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
    if ([self.delegate respondsToSelector:@selector(didTapAtDateView:)]) {
        [self.delegate didTapAtDateView:self];
    }
}

@end
