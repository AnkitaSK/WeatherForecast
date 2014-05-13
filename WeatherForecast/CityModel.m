//
//  City.m
//  WeatherForecast
//
//  Created by Ankita Kalangutkar on 11/05/14.
//  Copyright (c) 2014 creative capsule. All rights reserved.
//

#import "CityModel.h"

@implementation CityModel
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id": @"id",
                                                       @"name": @"name",
                                                       }];
}
@end
