
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
- (void) eventHappened:(NSString*)fname;

@end


#endif /* MapViewController_h */
