//
//  JYDateEntity.h
//  JYCalendar
//
//  Created by Justin Yang on 14-1-18.
//  Copyright (c) 2014年 Nanjing University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JYDate : NSObject

@property (nonatomic, assign) BOOL visible;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, assign) NSInteger weekRow;
@property (nonatomic, readonly) NSString *formatDate;

@end
