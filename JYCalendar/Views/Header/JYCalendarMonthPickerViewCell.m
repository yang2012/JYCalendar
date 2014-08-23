//
//  JYCalendarHeaderViewCell.m
//  JYCalendar
//
//  Created by Justin Yang on 14-1-19.
//  Copyright (c) 2014年 Nanjing University. All rights reserved.
//

#import "JYCalendarMonthPickerViewCell.h"
#import "NSDate+JYCalendar.h"
#import "UIView+JYCalendar.h"

@interface JYCalendarMonthPickerViewCell ()

@property (nonatomic, strong) UIImageView *pickerImageView;
@property (nonatomic, strong) UILabel *monthNumLabel;
@property (nonatomic, strong) UILabel *monthNameLabel;

@end

@implementation JYCalendarMonthPickerViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _addSubviews];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)_addSubviews
{
    self.pickerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"comm_bg_picker_time"]];
    self.pickerImageView.frame = CGRectMake(0.0f, 0.0f, 38.0f, 38.0f);
    self.pickerImageView.autoresizingMask = UIViewContentModeScaleAspectFit;
    self.pickerImageView.hidden = YES;
    [self.contentView addSubview:self.pickerImageView];
    
    self.monthNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 2.0f, 0.0f, 0.0f)];
    self.monthNumLabel.font = [UIFont systemFontOfSize:16];
    self.monthNumLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.monthNumLabel];
    
    self.monthNameLabel = [[UILabel alloc] init];
    self.monthNameLabel.font = [UIFont systemFontOfSize:8];
    self.monthNameLabel.textColor = [UIColor lightGrayColor];
    self.monthNameLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.monthNameLabel];
}

- (void)layoutSubviews
{
    CGFloat heightOfText = self.monthNumLabel.height + self.monthNameLabel.height;
    self.monthNumLabel.x = (self.width - self.monthNumLabel.width) / 2;
    self.monthNumLabel.y = (self.height - heightOfText) / 2;
    self.monthNameLabel.x = (self.width - self.monthNameLabel.width) / 2;
    self.monthNameLabel.y = self.monthNumLabel.y + self.monthNumLabel.height;
    
    self.pickerImageView.x = (self.width - self.pickerImageView.width) / 2;
    self.pickerImageView.y = (self.height - self.pickerImageView.height) / 2;
}

- (void)setMonth:(NSDate *)month
{
    _month = month;
    self.monthNumLabel.text = [NSString stringWithFormat:@"%ld", (long)month.month];
    [self.monthNumLabel sizeToFit];
    
    self.monthNameLabel.text = month.monthName;
    [self.monthNameLabel sizeToFit];
    
    [self setNeedsLayout];
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    if (selected) {
        self.pickerImageView.hidden = NO;
        self.monthNameLabel.textColor = [UIColor whiteColor];
        self.monthNumLabel.textColor = [UIColor whiteColor];
    } else {
        self.pickerImageView.hidden = YES;
        self.monthNameLabel.textColor = [UIColor blackColor];
        self.monthNumLabel.textColor = [UIColor blackColor];
    }
}

@end
