//TODO create two properties distance and direction,
//from updateRoute delegate method, call the AR arrow display
//function regularly (two parameters distance and direction in which the arrows have to be displayed).

//
//  AppDelegate.h
//  indoorAtlasV1
//
//  Created by interns on 25/06/18.
//  Copyright © 2018 CommScope Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PRLocation.h"
#import "PRLocation.h"
#import <IndoorAtlas/IndoorAtlas.h>
#import <IndoorAtlasWayfinding/wayfinding.h>
#import "Utils.h"


// map view
//#import <MapKit/MapKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,IALocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) IALocationManager *locationManager;
@property (strong) NSString *latitude;
@property (strong) NSString *longitude;

@property (strong) IALocation *currentLocation;
@property (assign) double currentDestinationLatitude;
@property (assign) double currentDestinationLongitude;


@property (strong) NSString *graphJSON;
@property (strong) NSString *updatedRoute;
@property (strong) NSString *detectedBarcode;

@property (strong) IARoutingLeg *currentRoutingLeg;
@property (strong) NSArray<IARoutingLeg*> *routingPath;

@property (strong) IAWayfinding *wayfinding;
@property (assign) int routingLegIndex;

@property (assign) double legUpdateVal;
// for map overlay
//@property (strong) IAResourceManager *resourceManager;
//@property (strong) IAFloorPlan *floorPlan;
//@property (strong) UIImage *floorPlanImage;
//@property (strong) MKMapView *mapView;




@end

