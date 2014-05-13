//
//  City.h
//  WeatherForecast
//
//  Created by Ankita Kalangutkar on 11/05/14.
//  Copyright (c) 2014 creative capsule. All rights reserved.
//

#import "JSONModel.h"

@interface CityModel : JSONModel
@property (nonatomic) int id;
@property (nonatomic,strong)NSString *name;
@end
