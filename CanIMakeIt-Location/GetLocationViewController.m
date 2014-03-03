//
//  ViewController.m
//  CanIMakeIt-Location
//
//  Created by YOGESH PADMAN on 3/2/14.
//  Copyright (c) 2014 Dakshayani Padman. All rights reserved.
//

#import "GetLocationViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface GetLocationViewController () <CLLocationManagerDelegate>
@property (strong, nonatomic) IBOutlet UILabel *latitudeLabel;
@property (strong, nonatomic) IBOutlet UILabel *longitudeLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;


- (IBAction)getLocationButton:(id)sender;

@end

@implementation GetLocationViewController
{
    CLLocationManager *locationManager;
    CLGeocoder *geoCoder;
    CLPlacemark *placeMark;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    locationManager = [[CLLocationManager alloc] init];
    geoCoder = [[CLGeocoder alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)getLocationButton:(id)sender
{
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [locationManager startUpdatingLocation];
}


#pragma mark CLLocationManagerDelegate methods

-(void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Error: Failed to get location - %@", error);
}

-(void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"Location: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil)
    {
        self.latitudeLabel.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
        self.longitudeLabel.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];

    }
    
    [geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error)
    {
        
        if ((error == nil) && (placemarks > 0))
        {
            placeMark = [placemarks lastObject];
            
            self.addressLabel.text = [NSString stringWithFormat:@"%@ %@\n%@ %@\n%@\n%@", placeMark.subThoroughfare, placeMark.thoroughfare, placeMark.postalCode, placeMark.locality, placeMark.administrativeArea, placeMark.country];
        }
        else
        {
            NSLog(@"Error: %@", error.debugDescription);
        }
    }];
}


@end
