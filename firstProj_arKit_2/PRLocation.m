//
//  PRLocation.m
//  indoorAtlasV1
//
//  Created by interns on 25/06/18.
//  Copyright © 2018 CommScope Inc. All rights reserved.
//

#import "PRLocation.h"

@implementation PRLocation
- (void)authenticateAndRequestLocation
{
    NSString *kAPIKey = @"e525eede-5d1e-4b08-a8eb-6c453728f5c0";
    //NSString *kAPIKey = @"4c163b66-9277-4ddc-9290-f59aa67a9ac2";
    
    NSString *kAPISecret =
    @"1C94gN1kVj/CjZ0xVeRlDf4+2adwK42qNMsMX9b91TKeT0tXkxGbXBpeM+bVWciBFqqy9k4I603Hfr8cjGzJKSmilzA0pkjuVBj4XyT71PRZZQ1g5fb3FoqvJdfDCA==";
    
    //NSString *kAPISecret =
    //@"wJNbGRMTLS0CxB/tN0a0Yu23LIBnANyCd3vPS79gjXZ+lek9PgGQJ9QpxCxK9LWtjwP/eMz7n1jQKwcIbKqe15I0h4WPBowcMP/X5H2BXPYIG6jLOVdiEd7WPvmf+A==";
    
    
    // Get IALocationManager shared instance and point delegate to receiver
    self.locationManager = [IALocationManager sharedInstance];
    self.locationManager.delegate = self;
    
    // Set IndoorAtlas API key and secret
    [self.locationManager setApiKey:kAPIKey andSecret:kAPISecret];
    
    // Set distance filter
    CLLocationDistance location = 0.3 ;
    self.locationManager.distanceFilter = location;
    
    
    // Request location updates
    [self.locationManager startUpdatingLocation];
    
    
}
//-(void)changeDistanceFilter(float distance){
//}

// Delegate method from the IALocationManagerDelegate protocol
- (void)indoorLocationManager:(IALocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    (void)manager;
    
    CLLocation *l = [(IALocation *)locations.lastObject location];
    
    _latitude = [NSString stringWithFormat:@"%.6f",l.coordinate.latitude];
    _longitude = [NSString stringWithFormat:@"%.6f",l.coordinate.longitude];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"LocationUpdated" object:l];
    
    
    NSLog(@"position changed to coordinate: %.6fx%.6f",
          l.coordinate.latitude, l.coordinate.longitude);
    
}
@end
