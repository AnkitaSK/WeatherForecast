//
//  WeatherDetail.m
//  WeatherForecast
//
//  Created by Ankita Kalangutkar on 11/05/14.
//  Copyright (c) 2014 creative capsule. All rights reserved.
//

#import "WeatherDetail.h"

@implementation WeatherDetail
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"city": @"city",
                                                       @"list": @"lists"
                                                        }];
}
@end
