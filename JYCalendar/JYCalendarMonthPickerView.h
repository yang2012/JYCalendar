//
//  JYCalendarHeaderView.h
//  JYCalendar
//
//  Created by Justin Yang on 14-1-19.
//  Copyright (c) 2014年 Nanjing University. All rights reserved.
//

@class JYCalendarMonthPickerView;

@protocol JYCalendarMonthPickerDelegate <NSObject>

- (void)monthPicker:(JYCalendarMonthPickerView *)pickerView didSelectDate:(NSDate *)date;

@end

@interface JYCalendarMonthPickerView : UIView

@property (nonatomic, weak) id<JYCalendarMonthPickerDelegate> delegate;
@property (nonatomic, strong) NSDate *date;

@end
