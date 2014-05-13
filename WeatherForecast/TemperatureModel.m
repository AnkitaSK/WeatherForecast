//
//  TemperatureModel.m
//  WeatherForecast
//
//  Created by Ankita Kalangutkar on 11/05/14.
//  Copyright (c) 2014 creative capsule. All rights reserved.
//

#import "TemperatureModel.h"

@implementation TemperatureModel
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"day": @"day",
                                                       @"min": @"min",
                                                       @"max": @"max",
                                                       @"night": @"night",
                                                       @"eve": @"eve",
                                                       @"morn": @"morn"
                                                       }];
}
@end
