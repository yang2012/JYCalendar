//
//  JYCalendarDateDetailCell.m
//  JYCalendar
//
//  Created by Justin Yang on 14-1-22.
//  Copyright (c) 2014年 Nanjing University. All rights reserved.
//

#import "JYCalendarDateDetailCell.h"
#import "JYEventEntity.h"
#import "NSDate+JYCalendar.h"
#import "UIView+JYCalendar.h"

@interface JYCalendarDateDetailCell ()

@property (nonatomic, strong) UILabel *eventNameLabel;
@property (nonatomic, strong) UIImageView *indicatorImageView;
@property (nonatomic, strong) UILabel *eventStartTimeLabel;

@end

@implementation JYCalendarDateDetailCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _initialize];
    }
    return self;
}

- (void)_initialize
{
    self.indicatorImageView = [[UIImageView alloc] init];
    self.indicatorImageView.frame = CGRectMake(0.1f, 0.1f, 21.0f, 21.0f);
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(10.0, 5.0f, 21.2f, 21.2f)];
    containerView.backgroundColor = [UIColor blueColor];
    containerView.layer.cornerRadius = 10.6f;
    [containerView addSubview:self.indicatorImageView];
    [self addSubview:containerView];
    
    self.eventStartTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(35.0f, 8.0f, 0.0f, 0.0f)];
    self.eventStartTimeLabel.font = [UIFont systemFontOfSize:12.0f];
    self.eventStartTimeLabel.textColor = [UIColor blueColor];
    [self addSubview:self.eventStartTimeLabel];
    
    self.eventNameLabel = [[UILabel alloc] init];
    self.eventNameLabel.y = 8.0f;
    self.eventNameLabel.font = [UIFont systemFontOfSize:11.0f];
    [self addSubview:self.eventNameLabel];
    
    self.backgroundColor = [UIColor whiteColor];
}

- (void)layoutSubviews
{
    self.eventNameLabel.x = self.eventStartTimeLabel.x + self.eventStartTimeLabel.width + 5.0f;
}

- (void)_refresh
{
    if (self.eventEntity.startDate.isAM) {
        self.indicatorImageView.image = [UIImage imageNamed:@"comm_ico_timeline_am@2x"];
    } else {
        self.indicatorImageView.image = [UIImage imageNamed:@"comm_ico_timeline_pm@2x"];
    }
    
    self.eventNameLabel.text = self.eventEntity.content;
    [self.eventNameLabel sizeToFit];
    
    self.eventStartTimeLabel.text = [self.eventEntity.startDate description:@"HH:mm"];
    [self.eventStartTimeLabel sizeToFit];
    
    [self setNeedsLayout];
}

- (void)setEventEntity:(JYEventEntity *)eventEntity
{
    _eventEntity = eventEntity;
    
    [self _refresh];
}

@end
