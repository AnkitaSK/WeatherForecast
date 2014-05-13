//
//  WeatherDetail.h
//  WeatherForecast
//
//  Created by Ankita Kalangutkar on 11/05/14.
//  Copyright (c) 2014 creative capsule. All rights reserved.
//

#import "JSONModel.h"
#import "CityModel.h"
#import "ListModel.h"

@protocol CityModel
@end

@protocol ListModel
@end

@interface WeatherDetail : JSONModel
@property (nonatomic,strong)CityModel *city;
@property (nonatomic,strong)NSArray<ListModel> *lists;
//@property (nonatomic,strong) NSString *country;
@end
