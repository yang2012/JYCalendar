//
//  JYCalendarDateDetailEmptyCell.m
//  JYCalendar
//
//  Created by Justin Yang on 14-1-26.
//  Copyright (c) 2014年 Nanjing University. All rights reserved.
//

#import "JYCalendarDateDetailEmptyCell.h"
#import "UIView+JYCalendar.h"

@interface JYCalendarDateDetailEmptyCell ()

@property (nonatomic, strong) UIImageView *placeholderImageView;
@property (nonatomic, strong) UILabel *placeholderLabel;

@end

@implementation JYCalendarDateDetailEmptyCell

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
    self.placeholderImageView       = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"detail_ico_schedule_none@2x"]];
    self.placeholderImageView.frame = CGRectMake(0.0f, 0.0f, 36.0f, 38.0f);
    [self.contentView addSubview:self.placeholderImageView];

    self.placeholderLabel      = [[UILabel alloc] init];
    self.placeholderLabel.font = [UIFont systemFontOfSize:12.0f];
    self.placeholderLabel.text = NSLocalizedString(@"Any new events?", nil);
    [self.placeholderLabel sizeToFit];
    [self.contentView addSubview:self.placeholderLabel];
    
    self.backgroundColor = [UIColor whiteColor];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.placeholderImageView.x = (self.width - self.placeholderImageView.width ) / 2;
    self.placeholderImageView.y = (self.height - self.placeholderImageView.height) / 2 - 10.0f;
    
    self.placeholderLabel.x = (self.width - self.placeholderLabel.width) / 2;
    self.placeholderLabel.y = self.placeholderImageView.y + self.placeholderImageView.height;
}

@end
