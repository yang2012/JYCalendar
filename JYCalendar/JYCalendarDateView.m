//
//  JYCalendarDateView.m
//  JYCalendar
//
//  Created by Justin Yang on 14-1-18.
//  Copyright (c) 2014年 Nanjing University. All rights reserved.
//

#import "JYCalendarDateView.h"

@interface JYCalendarDateView ()

@property (nonatomic, strong) UILabel *labelView;
@property (nonatomic, assign) BOOL showed;

@end

@implementation JYCalendarDateView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.labelView = [[UILabel alloc] init];
        self.labelView.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.labelView];
        
        self.showed = NO;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}

- (void)setDateEntity:(JYDateEntity *)dateEntity
{
    _dateEntity = dateEntity;
    
    self.labelView.text = dateEntity.formatDate;
}

- (void)layoutSubviews
{
    CGRect frame = self.frame;
    self.labelView.frame = CGRectMake(0, 0, frame.size.width, 20);
}

- (void)tap:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(didTapAtdateView:)]) {
        [self.delegate didTapAtdateView:self];
    }
}

@end
