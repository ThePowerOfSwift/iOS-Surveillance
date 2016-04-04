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

@interface MapViewController : UIViewController <MKMapViewDelegate>
{
    CLLocationCoordinate2D locPark;
    CLLocationCoordinate2D locExam;
}

@property (weak,nonatomic) IBOutlet MKMapView *map;

@end


#endif /* MapViewController_h */
