//
//  JYWeatherManager.m
//  JYCalendar
//
//  Created by Justin Yang on 14-1-27.
//  Copyright (c) 2014年 Nanjing University. All rights reserved.
//

#import "JYWeatherManager.h"
#import "JYClient.h"

@interface JYWeatherManager ()

@property (nonatomic, strong) JYCondition *currentCondition;
@property (nonatomic, strong) CLLocation *currentLocation;
@property (nonatomic, strong) NSArray *hourlyForecast;
@property (nonatomic, strong) NSArray *dailyForecast;

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, assign) BOOL isFirstUpdate;
@property (nonatomic, strong) JYClient *client;

@end

@implementation JYWeatherManager

#pragma mark - lifecycle

+ (instancetype)sharedManager {
    static id _sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[JYWeatherManager alloc] init];
    });
    
    return _sharedManager;
}

- (id)init {
    if (self = [super init]) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        
        _client = [[JYClient alloc] init];
        
        [[[[RACObserve(self, currentLocation)
            ignore:nil]
           // Flatten and subscribe to all 3 signals when currentLocation updates
           flattenMap:^(CLLocation *newLocation) {
               return [RACSignal merge:@[
                                         [self _updateCurrentConditions]
                                         ]];
           }] deliverOn:RACScheduler.mainThreadScheduler]
         subscribeError:^(NSError *error) {
             NSLog(@"%@", error);
         }];
    }
    return self;
}

#pragma mark - Public methods

- (void)findCurrentLocation {
    self.isFirstUpdate = YES;
    [self.locationManager startUpdatingLocation];
}

#pragma mark - Private methods

- (RACSignal *)_updateCurrentConditions {
    return [[self.client fetchCurrentConditionsForLocation:self.currentLocation.coordinate]
            doNext:^(JYCondition *condition) {
        self.currentCondition = condition;
    }];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    if (self.isFirstUpdate) {
        self.isFirstUpdate = NO;
        return;
    }
    
    CLLocation *location = [locations lastObject];
    
    if (location.horizontalAccuracy > 0) {
        self.currentLocation = location;
        [self.locationManager stopUpdatingLocation];
    }
}

@end
