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
@property (nonatomic, strong, readonly) NSDate *selectedDate;
@property (nonatomic, assign, readonly) BOOL showed;
@property (nonatomic, assign, readonly) BOOL animating;

- (void)presentPickerBeginningAtDate:(NSDate *)date
                              inView:(UIView *)view
                            animated:(BOOL)animated;

- (void)dismissPickerAnimated:(BOOL)animated;

- (void)dismissPickerAnimated:(BOOL)animated completion:(void (^)())finishedBlock;

@end
