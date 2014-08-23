//
//  JYCalendarTitleView.m
//  JYCalendar
//
//  Created by Justin Yang on 14-1-19.
//  Copyright (c) 2014年 Nanjing University. All rights reserved.
//

#import "JYCalendarTitleView.h"
#import "NSDate+JYCalendar.h"
#import "UIView+JYCalendar.h"

@implementation JYCalendarTitleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self _addSubview];
    }
    return self;
}

- (void)_addSubview
{
    self.monthLabel = [[UILabel alloc] init];
    self.monthLabel.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    self.monthLabel.font = [UIFont boldSystemFontOfSize:18];
    self.monthLabel.textAlignment = NSTextAlignmentCenter;
    self.monthLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:self.monthLabel];
    
    self.yearLabel = [[UILabel alloc] init];
    self.yearLabel.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.3];
    self.yearLabel.font = [UIFont systemFontOfSize:10];
    self.yearLabel.textAlignment = NSTextAlignmentCenter;
    self.yearLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:self.yearLabel];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self addGestureRecognizer:tapGesture];
}

- (void)layoutSubviews
{
    CGSize size = self.bounds.size;
    
    self.monthLabel.x = (size.width - self.monthLabel.width) / 2;
    self.yearLabel.x = (size.width - self.yearLabel.width) / 2;
    self.yearLabel.y = self.monthLabel.height;
}

- (void)setTime:(NSDate *)time
{
    self.monthLabel.text = [NSString stringWithFormat:@"%ld", (long)time.month];
    [self.monthLabel sizeToFit];
    self.yearLabel.text = [NSString stringWithFormat:@"%ld", (long)time.year];
    [self.yearLabel sizeToFit];
    
    [self setNeedsLayout];
}

- (void)tap:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(didTapTitleView:)]) {
        [self.delegate didTapTitleView:self];
    }
}

@end
