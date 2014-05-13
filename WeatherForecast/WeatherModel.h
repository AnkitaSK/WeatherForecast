//
//  WeatherModel.h
//  WeatherForecast
//
//  Created by Ankita Kalangutkar on 12/05/14.
//  Copyright (c) 2014 creative capsule. All rights reserved.
//

#import "JSONModel.h"

@interface WeatherModel : JSONModel
@property (nonatomic) int id;
@property (nonatomic,strong) NSString *main;
@property (nonatomic,strong) NSString *description;
@end

