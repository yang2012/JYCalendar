//
//  JYWeatherManager.h
//  JYCalendar
//
//  Created by Justin Yang on 14-1-27.
//  Copyright (c) 2014年 Nanjing University. All rights reserved.
//

@import CoreLocation;
#import <ReactiveCocoa/ReactiveCocoa/ReactiveCocoa.h>
#import "JYCondition.h"

@interface JYWeatherManager : NSObject <CLLocationManagerDelegate>

+ (instancetype)sharedManager;

@property (nonatomic, strong, readonly) CLLocation *currentLocation;
@property (nonatomic, strong, readonly) JYCondition *currentCondition;

- (void)findCurrentLocation;

@end
