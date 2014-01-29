//
//  JYCalendarTitleView.h
//  JYCalendar
//
//  Created by Justin Yang on 14-1-19.
//  Copyright (c) 2014年 Nanjing University. All rights reserved.
//

@class JYCalendarTitleView;

@protocol JYCalendarTitleViewDelegate <NSObject>

- (void)didTapTitleView:(JYCalendarTitleView *)titleView;

@end

@interface JYCalendarTitleView : UIView

@property (nonatomic, weak) id<JYCalendarTitleViewDelegate> delegate;

@property (nonatomic, strong) UILabel *monthLabel;
@property (nonatomic, strong) UILabel *yearLabel;

- (void)setTime:(NSDate *)time;

@end
