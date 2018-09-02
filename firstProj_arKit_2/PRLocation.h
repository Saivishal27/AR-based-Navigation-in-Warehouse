//
//  PRLocation.h
//  indoorAtlasV1
//
//  Created by interns on 25/06/18.
//  Copyright © 2018 CommScope Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
@import IndoorAtlas;


@interface PRLocation:NSObject <IALocationManagerDelegate>

@property (nonatomic, strong) IALocationManager *locationManager;
@property (strong) NSString *latitude;
@property (strong) NSString *longitude;

- (void)authenticateAndRequestLocation;
- (void)indoorLocationManager:(IALocationManager *)manager didUpdateLocations:(NSArray *)locations;

@end
