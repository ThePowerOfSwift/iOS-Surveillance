//
//  MapViewController.m
//  Surveillance
//
//  Created by Dillon Butt on 2016-04-02.
//  Copyright © 2016 Dillon Butt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MapViewController.h"

@implementation MapViewController

-(void) viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    locPark = CLLocationCoordinate2DMake(47.573488, -52.736024);
    locExam = CLLocationCoordinate2DMake(47.574988, -52.734324);
    locMe = [self getCurrentLocation];
    MKCoordinateRegion reg = MKCoordinateRegionMakeWithDistance(locPark, 400, 400);
    self.map.region = reg;
    
    self.map.delegate = self;
    
    
    // Add annotation
    [self createAnnotation:locPark title:@"Park Here" subtitle:@"Go to exam by 1pm"];
//    MKPointAnnotation* ann = [[MKPointAnnotation alloc] init];
//    ann.coordinate = locPark;
//    ann.title = @"Park here";
//    ann.subtitle = @"Go to exam by 1pm";
//    [self.map addAnnotation:ann];
    [self createAnnotation:locExam title:@"4768 exam" subtitle:@"1-2pm, Mar 21"];
//    ann = [[MKPointAnnotation alloc] init];
//    ann.coordinate = locExam;
//    ann.title = @"4768 exam";
//    ann.subtitle = @"1-2pm, Mar 21";
//    [self.map addAnnotation:ann];
    
    // Add overlay
    CGFloat lat = locPark.latitude;
    CLLocationDistance metersPerPoint = MKMetersPerMapPointAtLatitude(lat);
    MKMapPoint c = MKMapPointForCoordinate(locPark);
    c.x += -43/metersPerPoint;
    c.y -= 56/metersPerPoint;
    MKMapPoint p1 = MKMapPointMake(c.x, c.y);
    p1.y -= 100/metersPerPoint;
    MKMapPoint p2 = MKMapPointMake(c.x, c.y);
    p2.x += 90/metersPerPoint;
    MKMapPoint p3 = MKMapPointMake(c.x, c.y);
    p3.x += 190/metersPerPoint;
    p3.y -= 90/metersPerPoint;
    MKMapPoint p4 = MKMapPointMake(c.x, c.y);
    p4.x += 100/metersPerPoint;
    p4.y -= 185/metersPerPoint;
    MKMapPoint pts[4] = {p1, p2, p3, p4};
    MKPolygon* poly = [MKPolygon polygonWithPoints:pts count:4];
    [self.map addOverlay:poly];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    MKDirectionsRequest *walkingRouteRequest = [[MKDirectionsRequest alloc] init];
    walkingRouteRequest.transportType = MKDirectionsTransportTypeWalking;
    MKMapItem *startPoint = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:locPark addressDictionary:nil]];
    MKMapItem *endPoint = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:locExam addressDictionary:nil]];
    [walkingRouteRequest setSource:startPoint];
    [walkingRouteRequest setDestination:endPoint];
    
    MKDirections *walkingRouteDirections = [[MKDirections alloc] initWithRequest:walkingRouteRequest];
    [walkingRouteDirections calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse * walkingRouteResponse, NSError *walkingRouteError)
     {
         if (walkingRouteError)
         {
             NSLog(@"Route error: %@", walkingRouteError);
         } else
         {
             [self.map addOverlay:walkingRouteResponse.routes[0].polyline
                            level:MKOverlayLevelAboveRoads];
         }
     }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
#pragma mark <UIMapKitDelegate> methods

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    MKAnnotationView* v = nil;
    if ([annotation.title isEqualToString:@"Park here"])
    {
        static NSString* ident = @"pin";
        v = [mapView dequeueReusableAnnotationViewWithIdentifier:ident];
        if (v == nil)
        {
            v = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:ident];
            ((MKPinAnnotationView*)v).pinTintColor = [MKPinAnnotationView greenPinColor];
            v.canShowCallout = YES;
            ((MKPinAnnotationView *)v).animatesDrop = YES;
        } else
        {
            v.annotation = annotation;
        }
    }
    else if ([annotation.title isEqualToString:@"4768 exam"])
    {
        static NSString* ident = @"pin";
        v = [mapView dequeueReusableAnnotationViewWithIdentifier:ident];
        if (v == nil)
        {
            v = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:ident];
            v.image = [UIImage imageNamed:@"camera.png"];
            v.canShowCallout = YES;
            v.leftCalloutAccessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"writeicon.png"]];
            UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            //            [rightButton addTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
            v.rightCalloutAccessoryView = rightButton;
        } else
        {
            v.annotation = annotation;
        }
    }
    return v;
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id <MKOverlay>)overlay
{
    MKOverlayRenderer* r = nil;
    if ([overlay isKindOfClass:[MKPolygon class]]) {
        MKPolygonRenderer *v = [[MKPolygonRenderer alloc] initWithPolygon:(MKPolygon*)overlay];
        v.fillColor = [[UIColor redColor] colorWithAlphaComponent:0.1];
        v.strokeColor = [[UIColor redColor] colorWithAlphaComponent:0.8];
        v.lineWidth = 2;
        r = v;
    }
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolylineRenderer *l = [[MKPolylineRenderer alloc] initWithPolyline:(MKPolyline*)overlay];
        l.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.5];
        l.lineWidth = 4;
        r = l;
    }
    return r;
}

- (CLLocationCoordinate2D) getCurrentLocation
{
    CLLocationManager *lm = [[CLLocationManager alloc] init];
    lm.delegate = self;
    lm.desiredAccuracy = kCLLocationAccuracyBest;
    lm.distanceFilter = kCLDistanceFilterNone;
    CLLocation *loc = [[CLLocation alloc] init];
    loc = [lm location];
    
    CLLocationCoordinate2D coord;
    coord.latitude = loc.coordinate.latitude;
    coord.longitude = loc.coordinate.longitude;
    if((loc.coordinate.longitude== 0.0 ) && (loc.coordinate.latitude==0.0))
    {
        NSLog(@"An error has occurred");
        return coord;
    }
    else
    {
        coord = [loc coordinate];
        return coord;
    }
}

- (void) createAnnotation:(CLLocationCoordinate2D)location title:(NSString*)title subtitle:(NSString*)subtitle
{
    MKPointAnnotation* ann = [[MKPointAnnotation alloc] init];
    ann.coordinate = location;
    ann.title = title;
    ann.subtitle = subtitle;
    [self.map addAnnotation:ann];
}

- (NSString*) getDeviceName
{
    
    return @"Hello world";
}

@end