//
//  ListModel.h
//  WeatherForecast
//
//  Created by Ankita Kalangutkar on 11/05/14.
//  Copyright (c) 2014 creative capsule. All rights reserved.
//

#import "JSONModel.h"
#import "TemperatureModel.h"
#import "WeatherModel.h"

@protocol TemperatureModel
@end

@protocol WeatherModel
@end

@interface ListModel : JSONModel
@property (nonatomic) int dt;
@property (nonatomic,strong)TemperatureModel *temp;
@property (nonatomic)float pressure;
@property (nonatomic)int humidity;
@property (nonatomic,strong)NSArray<WeatherModel> *weathers;
@end
