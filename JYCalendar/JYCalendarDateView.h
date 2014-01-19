//
//  JYCalendarDateView.h
//  JYCalendar
//
//  Created by Justin Yang on 14-1-18.
//  Copyright (c) 2014年 Nanjing University. All rights reserved.
//

#import "JYDateEntity.h"

@class JYCalendarDateView;

@protocol JYCalendarDateViewDelegate <NSObject>

- (void)didTapAtdateView:(JYCalendarDateView *)dateView;

@end

@interface JYCalendarDateView : UIView

@property (nonatomic, weak) id<JYCalendarDateViewDelegate> delegate;
@property (nonatomic, strong) JYDateEntity *dateEntity;

@end
