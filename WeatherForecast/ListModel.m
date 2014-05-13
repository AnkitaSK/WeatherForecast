//
//  ListModel.m
//  WeatherForecast
//
//  Created by Ankita Kalangutkar on 11/05/14.
//  Copyright (c) 2014 creative capsule. All rights reserved.
//

#import "ListModel.h"

@implementation ListModel
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"dt": @"dt",
                                                       @"temp": @"temp",
                                                       @"pressure": @"pressure",
                                                       @"humidity": @"humidity",
                                                       @"weather": @"weathers"
                                                       }];
}
@end
