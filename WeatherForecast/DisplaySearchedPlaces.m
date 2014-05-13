//
//  DisplayPlacesViewController.m
//  WeatherForecast
//
//  Created by Ankita Kalangutkar on 11/05/14.
//  Copyright (c) 2014 creative capsule. All rights reserved.
//

#import "DisplaySearchedPlaces.h"
#import "DisplayWeatherReport.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

// created a custom segue, inorder to reuse the destination view controller
@interface DetailSegue : UIStoryboardSegue
@end

@implementation DetailSegue

- (void)perform
{
    DisplaySearchedPlaces *sourceViewController = self.sourceViewController;
    DisplayWeatherReport *destinationViewController = self.destinationViewController;
    [sourceViewController.navigationController pushViewController:destinationViewController animated:YES];
}

@end

@interface DisplaySearchedPlaces ()<CLLocationManagerDelegate>
@property (strong, nonatomic) IBOutlet UIBarButtonItem *weatherDetailItem;
@property (nonatomic, strong) DetailSegue *currentCitySegue;
@property (nonatomic, strong) DetailSegue *detailSegue;
@property (nonatomic, strong) MKLocalSearch *localSearch;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic) CLLocationCoordinate2D userLocation;
@property (nonatomic, strong) NSMutableArray *searchedPlaces;
@property (nonatomic,strong) CLLocationManager *locationManager;
@property (nonatomic,strong) NSString * currentCityName;
@property (nonatomic,strong) UIActivityIndicatorView *indicator;
@property (nonatomic,strong) DisplayWeatherReport *displayWeatherReport;
@end

@implementation DisplaySearchedPlaces

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.searchedPlaces = [[NSMutableArray alloc] init];
    
    self.tableView.userInteractionEnabled = NO;
    // start progress bar
    self.indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.indicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
    self.indicator.center = self.view.center;
    [self.view addSubview:self.indicator];
    [self.indicator bringSubviewToFront:self.view];
    [self.indicator startAnimating];
    
    // this creates the CCLocationManager that will find your current location
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    [self.locationManager startUpdatingLocation];
    
    //initialize a destination viewcontroller, inorder to reuse it later
    self.displayWeatherReport = [self.storyboard instantiateViewControllerWithIdentifier:@"WeatherReportID"];
    
    // use custom segues to the destination view controller
    self.detailSegue = [[DetailSegue alloc] initWithIdentifier:@"showDetail"
                                                        source:self
                                                   destination:self.displayWeatherReport];
    
    self.currentCitySegue = [[DetailSegue alloc] initWithIdentifier:@"currentCityWeather"
                                                             source:self
                                                        destination:self.displayWeatherReport];
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
    return self.searchedPlaces.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    MKMapItem *mapItem = [self.searchedPlaces objectAtIndex:indexPath.row];
    cell.textLabel.text = mapItem.name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.searchBar.text = @"";
    
    MKMapItem *mapItem = [self.searchedPlaces objectAtIndex:indexPath.row];
    self.displayWeatherReport.cityName = mapItem.name;
    // call to a custom segue
    [self.detailSegue perform];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    [searchBar resignFirstResponder];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:NO animated:YES];
}

- (void)startSearch:(NSString *)searchString
{
    if (self.localSearch.searching)
    {
        [self.localSearch cancel];
    }
    
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    
    request.naturalLanguageQuery = searchString;
    //    request.region = newRegion;
    
    MKLocalSearchCompletionHandler completionHandler = ^(MKLocalSearchResponse *response, NSError *error)
    {
        NSArray *places;
        if (error != nil)
        {
            NSString *errorStr = [[error userInfo] valueForKey:NSLocalizedDescriptionKey];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Could not find places"
                                                            message:errorStr
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        else
        {
            places = [response mapItems];
            [self.searchedPlaces addObjectsFromArray:places];
            self.tableView.userInteractionEnabled = YES;
            [self.tableView reloadData];
        }
        //        showing network spinning gear in status bar. default is NO
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    };
    
    if (self.localSearch != nil)
    {
        self.localSearch = nil;
    }
    self.localSearch = [[MKLocalSearch alloc] initWithRequest:request];
    
    [self.localSearch startWithCompletionHandler:completionHandler];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    self.tableView.userInteractionEnabled = NO;
    [searchBar resignFirstResponder];
    
    // check to see if Location Services is enabled, there are two state possibilities:
    // 1) disabled for entire device, 2) disabled just for this app
    //
    NSString *causeStr = nil;
    
    // check whether location services are enabled on the device
    if ([CLLocationManager locationServicesEnabled] == NO)
    {
        causeStr = @"device";
    }
    // check the application’s explicit authorization status:
    else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)
    {
        causeStr = @"app";
    }
    else
    {
        //start the search
        [self startSearch:searchBar.text];
    }
    
    if (causeStr != nil)
    {
        NSString *alertMessage = [NSString stringWithFormat:@"You currently have location services disabled for this %@. Please refer to \"Settings\" app to turn on Location Services.", causeStr];
        
        UIAlertView *servicesDisabledAlert = [[UIAlertView alloc] initWithTitle:@"Location Services Disabled"
                                                                        message:alertMessage
                                                                       delegate:nil
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil];
        [servicesDisabledAlert show];
    }
    
}

- (IBAction)weatherForCurrentLocation:(UIBarButtonItem *)sender
{
    self.displayWeatherReport.cityName = self.currentCityName;
    // call to a custom segue
    [self.currentCitySegue perform];
}

#pragma mark -- CLLocationManagerDelegate method
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    [self.locationManager stopUpdatingLocation];
    
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        for (CLPlacemark * placemark in placemarks) {
            self.currentCityName = ([placemarks count] > 0) ? [[placemarks objectAtIndex:0] locality] : @"Not Found";
            [self.indicator stopAnimating];
            self.tableView.userInteractionEnabled = YES;
            self.weatherDetailItem.enabled = YES;
        }
    }];
}

@end
