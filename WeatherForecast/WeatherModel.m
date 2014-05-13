//
//  WeatherModel.m
//  WeatherForecast
//
//  Created by Ankita Kalangutkar on 12/05/14.
//  Copyright (c) 2014 creative capsule. All rights reserved.
//

#import "WeatherModel.h"

@implementation WeatherModel
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id": @"id",
                                                       @"main": @"main",
                                                       @"description": @"description"
                                                       }];
}
@end


