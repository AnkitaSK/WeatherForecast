//
//  TemperatureModel.h
//  WeatherForecast
//
//  Created by Ankita Kalangutkar on 11/05/14.
//  Copyright (c) 2014 creative capsule. All rights reserved.
//

#import "JSONModel.h"

@interface TemperatureModel : JSONModel
@property (nonatomic) float day;
@property (nonatomic) float min;
@property (nonatomic) float max;
@property (nonatomic) float night;
@property (nonatomic) float eve;
@property (nonatomic) float morn;
@end
