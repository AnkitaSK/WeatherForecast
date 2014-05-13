//
//  DisplayWeatherReport.m
//  WeatherForecast
//
//  Created by Ankita Kalangutkar on 11/05/14.
//  Copyright (c) 2014 creative capsule. All rights reserved.
//

#import "DisplayWeatherReport.h"
#import "JSONModel+networking.h"
#import "WeatherDetail.h"
#import "CustomCell.h"
#import "TemperatureModel.h"
#import "ListModel.h"

#define kAppID @"c32a92d37bbc356e5e75d57327382f2c"
#define kAPIUrl @"http://api.openweathermap.org/data/2.5/forecast/daily"
#define kNoOfDays @"14"

@interface DisplayWeatherReport ()
@property (nonatomic,strong) WeatherDetail *weatherDetail;
@property (nonatomic,strong) NSMutableArray *tempDetails;
@end

@implementation DisplayWeatherReport

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) fetchWeatherDetails
{
    [JSONHTTPClient getJSONFromURLWithString:kAPIUrl params:@{@"q": self.cityName,
                                                              @"cnt":kNoOfDays,
                                                              @"APPID":kAppID}
                                  completion:^(id json, JSONModelError *err){
                                      self.weatherDetail = [[WeatherDetail alloc] initWithDictionary:json error:nil];
                                      [self.tempDetails addObjectsFromArray:self.weatherDetail.lists];
                                      self.tableView.userInteractionEnabled = YES;
                                      [self.tableView reloadData];
                                  }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void) viewWillAppear:(BOOL)animated
{
    self.navigationItem.title = self.cityName;
    self.tableView.userInteractionEnabled = NO;
    self.tempDetails = [[NSMutableArray alloc] init];
    [self fetchWeatherDetails];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.tempDetails.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"customCell";
    CustomCell *cell = (CustomCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    ListModel *listItem = [self.tempDetails objectAtIndex:indexPath.row];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/yyyy"];
    cell.dateLabel.text = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:listItem.dt]];
    
    cell.minTempLabel.text = [NSString stringWithFormat:@"%f", listItem.temp.min];
    cell.maxTempLabel.text = [NSString stringWithFormat:@"%f", listItem.temp.max];
    
    NSString *weatherDetail;
    if (listItem.weathers.count >1) {
        //when there is more than 1 weather info
        for (int i=0;i<listItem.weathers.count-1;i++) {
            weatherDetail = [[listItem.weathers objectAtIndex:i] description];
            [weatherDetail stringByAppendingString:@","];
            [weatherDetail stringByAppendingString:[[listItem.weathers objectAtIndex:i+1] description]];
        }
    }
    else
    {
        for (int i=0;i<listItem.weathers.count;i++) {
            weatherDetail = [[listItem.weathers objectAtIndex:i] description];
        }
    }
    
    cell.weatherLabel.text = weatherDetail;
    
    return cell;
}

@end
