//
//  Utils.h
//  indoorAtlasV1
//
//  Created by interns on 02/07/18.
//  Copyright © 2018 CommScope Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <IndoorAtlas/IndoorAtlas.h>
#import <IndoorAtlasWayfinding/wayfinding.h>

@interface Utils : NSObject

+(double) getDotProduct: (double) Ax Ay:(double) Ay Bx:(double) Bx By:(double) By;
+(BOOL) getDistance: (IARoutingPoint *) pointA pointB:(IARoutingPoint *) pointB pointC:(CLLocation *) pointC;
+(double) getDistanceFormula: (IALocation*) pointA pointB: (IARoutingPoint *) pointB;
+(void) setRouteStringFromRoute:(NSArray<IARoutingLeg *> *) route IntoString: (NSString *) routeString;
+(NSString *) setRouteStringFromRoute:(NSArray<IARoutingLeg *> *) route;
@end
