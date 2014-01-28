//
//  JYClient.h
//  JYCalendar
//
//  Created by Justin Yang on 14-1-27.
//  Copyright (c) 2014年 Nanjing University. All rights reserved.
//

@import CoreLocation;
#import <ReactiveCocoa/ReactiveCocoa/ReactiveCocoa.h>

@interface JYClient : NSObject

- (RACSignal *)fetchJSONFromURL:(NSURL *)url;
- (RACSignal *)fetchCurrentConditionsForLocation:(CLLocationCoordinate2D)coordinate;

@end
