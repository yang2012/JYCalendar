//
//  JYCalendarMonthCell.h
//  JYCalendar
//
//  Created by Justin Yang on 14-1-18.
//  Copyright (c) 2014年 Nanjing University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JYCalendarDateView.h"

@interface JYCalendarMonthCell : UICollectionViewCell

- (void)setUpDatesForMonth:(NSArray *)dateEntities
              withDelegate:(id<JYCalendarDateViewDelegate>)delegate;

@end
