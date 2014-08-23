//
//  JYCalendarMenuView.h
//  JYCalendar
//
//  Created by Justin Yang on 14-1-26.
//  Copyright (c) 2014年 Nanjing University. All rights reserved.
//

@class JYCalendarMenuView;

@protocol JYCalendarMenuViewDelegate <NSObject>

@optional
- (void)menuView:(JYCalendarMenuView *)menuView didClickMenuAtIndex:(NSInteger)index;

@end

@interface JYCalendarMenuView : UIView

@property (nonatomic, weak) id<JYCalendarMenuViewDelegate> delegate;
@property (nonatomic, assign, readonly) BOOL showed;
@property (nonatomic, assign, readonly) BOOL animating;

- (void)presentMenuInView:(UIView *)view
                 animated:(BOOL)animated;

- (void)dismissMenuAnimated:(BOOL)animated;

- (void)dismissMenuAnimated:(BOOL)animated completion:(void (^)())finishedBlock;

@end
