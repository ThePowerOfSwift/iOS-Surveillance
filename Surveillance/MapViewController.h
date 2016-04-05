//
//  MapViewController.h
//  Surveillance
//
//  Created by Dillon Butt on 2016-04-02.
//  Copyright © 2016 Dillon Butt. All rights reserved.
//

#ifndef MapViewController_h
#define MapViewController_h
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>
{
    CLLocationCoordinate2D locPark;
    CLLocationCoordinate2D locExam;
    CLLocationCoordinate2D locMe;
    CLLocation* cl;
    CLLocationManager* lm;
}

@property (weak,nonatomic) IBOutlet MKMapView *map;

- (CLLocationCoordinate2D) getCurrentLocation;

@end


#endif /* MapViewController_h */
