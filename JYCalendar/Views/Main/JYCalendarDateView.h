//
//  JYCalendarDateView.h
//  JYCalendar
//
//  Created by Justin Yang on 14-1-18.
//  Copyright (c) 2014年 Nanjing University. All rights reserved.
//

#import "JYDate.h"

@class JYCalendarDateView;

@protocol JYCalendarDateViewDelegate <NSObject>

- (void)didTapAtDateView:(JYCalendarDateView *)dateView;

@end

@interface JYCalendarDateView : UIView

@property (nonatomic, weak) id<JYCalendarDateViewDelegate> delegate;
@property (nonatomic, strong) JYDate *dateEntity;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, assign) BOOL showWeekDay;

@property (nonatomic, assign) BOOL selected;

@end
