//
//  Utills.h
//  indoorAtlasV1
//
//  Created by interns on 02/07/18.
//  Copyright © 2018 CommScope Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <IndoorAtlas/IndoorAtlas.h>
#import <IndoorAtlasWayfinding/wayfinding.h>
#import "Utils.h"

@implementation Utils : NSObject

+(double) getDotProduct: (double) Ax Ay:(double) Ay Bx:(double) Bx By:(double) By
{
    return (Ax*Bx)+(Ay*By);
}

+(BOOL) getDistance: (IARoutingPoint *) pointA pointB:(IARoutingPoint *) pointB pointC:(CLLocation *) pointC
{
    double startPointX = pointA.latitude-pointB.latitude;
    double startPointY = pointA.longitude-pointB.longitude;
    double recArea = [Utils getDotProduct:startPointX Ay:startPointY Bx:startPointX By:startPointY];
    double endPointX = pointA.latitude-pointC.coordinate.latitude;
    double endPointY = pointA.longitude-pointC.coordinate.longitude;
    double reqVal = [Utils getDotProduct:startPointX Ay:startPointY Bx:endPointX By:endPointY];
    
    return (reqVal>0 && reqVal<recArea);
    
}

+(double) getDistanceFormula: (IALocation*) pointA pointB: (IARoutingPoint *) pointB
{
    double x1 = pointA.location.coordinate.latitude;
    double y1 = pointA.location.coordinate.longitude;
    
    double x2 = pointB.latitude;
    double y2 = pointB.longitude;
    
    double distance = sqrt(pow(y2 - y1 , 2) + pow(x2 - x1, 2));
    return distance;
}

+(void) setRouteStringFromRoute:(NSArray<IARoutingLeg *> *) route IntoString: (NSString *) routeString
{
    routeString = @"";
    NSLog(@"TDSSSSKKK DEBUG MODE ON\nroutecount = %d", route.count);
    for (IARoutingLeg *leg in route)
    {
        routeString = [routeString stringByAppendingString:[NSString stringWithFormat:@"begin latitude: %f longitude: %f\n end latitude: %f longitude: %f\n direction: %f\ndistance: %f\n\n",leg.begin.latitude, leg.begin.longitude, leg.end.latitude, leg.end.longitude,leg.direction,leg.length]];
        
        //NSLog(@"begin latitude: %f longitude: %f\n end latitude: %f longitude: %f\n direction: %f",leg.begin.latitude, leg.begin.longitude, leg.end.latitude, leg.end.longitude, leg.direction);
    }
    NSLog(@"routeString = %@", routeString);
}

+(NSString *) setRouteStringFromRoute:(NSArray<IARoutingLeg *> *) route
{
    NSString *routeString = @"";
    NSLog(@"TDSSSSKKK DEBUG MODE ON\nroutecount = %d", route.count);
    for (IARoutingLeg *leg in route)
    {
        routeString = [routeString stringByAppendingString:[NSString stringWithFormat:@"begin latitude: %f longitude: %f\n end latitude: %f longitude: %f\n direction: %f\ndistance: %f\n\n",leg.begin.latitude, leg.begin.longitude, leg.end.latitude, leg.end.longitude,leg.direction,leg.length]];
        
        //NSLog(@"begin latitude: %f longitude: %f\n end latitude: %f longitude: %f\n direction: %f",leg.begin.latitude, leg.begin.longitude, leg.end.latitude, leg.end.longitude, leg.direction);
    }
    //NSLog(@"routeString = %@", routeString);
    return routeString;
}

@end

