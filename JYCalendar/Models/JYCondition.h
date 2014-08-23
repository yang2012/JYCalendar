//
//  JYCondition.h
//  JYCalendar
//
//  Created by Justin Yang on 14-1-27.
//  Copyright (c) 2014年 Nanjing University. All rights reserved.
//

#import <Mantle.h>

@interface JYCondition : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSNumber *humidity;
@property (nonatomic, strong) NSNumber *temperature;
@property (nonatomic, strong) NSNumber *tempHigh;
@property (nonatomic, strong) NSNumber *tempLow;
@property (nonatomic, strong) NSString *locationName;
@property (nonatomic, strong) NSString *conditionDescription;
@property (nonatomic, strong) NSString *condition;
@property (nonatomic, strong) NSString *icon;

- (NSString *)imageName;

@end
