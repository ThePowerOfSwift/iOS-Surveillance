
#import <Foundation/Foundation.h>
#import <CFNetwork/CFNetwork.h>
#import "MapViewController.h"

@implementation MapViewController

-(void) viewDidLoad
{
    
    [super viewDidLoad];
    lm = [[CLLocationManager alloc] init];
    lm.delegate = self;
    lm.distanceFilter = kCLDistanceFilterNone;
    lm.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    [lm requestAlwaysAuthorization];
    [lm startUpdatingLocation];
    
    // Do any additional setup after loading the view, typically from a nib.
    locMe = [self getCurrentLocation];
    MKCoordinateRegion reg = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(47.56425,-52.70404), 20000, 20000);
    self.map.region = reg;
    
    self.map.delegate = self;
    [self getAllCameraEvents];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.map removeAnnotations:self.map.annotations];
    [self getAllCameraEvents];
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
    static NSString* ident = @"pin";
    v = [mapView dequeueReusableAnnotationViewWithIdentifier:ident];
    if (v == nil)
    {
        v = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:ident];
        v.image = [UIImage imageNamed:@"camera.png"];
        v.canShowCallout = YES;
//        v.leftCalloutAccessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"writeicon.png"]];
//        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
//        //            [rightButton addTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
//        v.rightCalloutAccessoryView = rightButton;
    } else
    {
        v.annotation = annotation;
    }
    
    return v;
}

- (CLLocationCoordinate2D) getCurrentLocation
{
    lm.desiredAccuracy = kCLLocationAccuracyBest;
    lm.distanceFilter = kCLDistanceFilterNone;
    cl = [[CLLocation alloc] init];
    cl = [lm location];
    
    CLLocationCoordinate2D coord;
    
    NSLog(@"Latitude: %f", lm.location.coordinate.latitude);
    NSLog(@"Longtitude: %f", lm.location.coordinate.longitude);
    
    
    coord.latitude = cl.coordinate.latitude;
    coord.longitude = cl.coordinate.longitude;
    if((cl.coordinate.longitude== 0.0 ) && (cl.coordinate.latitude==0.0))
    {
        NSLog(@"An error has occurred");
        return coord;
    }
    else
    {
        coord = [cl coordinate];
        return coord;
    }
}

- (void) createAnnotation:(CLLocationCoordinate2D)location fname:(NSString*)fname uname:(NSString*)uname timestamp:(NSString*)timestamp
{
    MKPointAnnotation* ann = [[MKPointAnnotation alloc] init];
    ann.coordinate = location;
    NSString* temp = [[fname stringByAppendingString:@" on "] stringByAppendingString:timestamp];
    ann.title = temp;
    ann.subtitle = uname;
    [self.map addAnnotation:ann];
}

- (NSString*) getDeviceName
{
    return @"Hello world";
}

- (void) eventHappened:(NSString*)devicename fname:(NSString*)fname
{
    NSString *tmpLat = [[NSString alloc] initWithFormat:@"%f", locMe.latitude];
    NSString *tmpLong = [[NSString alloc] initWithFormat:@"%f", locMe.longitude];
    
    NSDate *currentDate = [[NSDate alloc] init];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MMMM dd, yyyy, hh:mm aa"];
    NSString *prettyVersion = [dateFormat stringFromDate:currentDate];
    NSDate *startdates = [dateFormat dateFromString:prettyVersion];
    NSLog(@"Timestamp %0.0f",[startdates timeIntervalSince1970]);
    
    [self saveEventToDatabase:devicename fname:fname lat:tmpLat longi:tmpLong tstamp:prettyVersion];
}

- (void) saveEventToDatabase:(NSString*)devicename fname:(NSString*)fname lat:(NSString*)latitude longi:(NSString*)longitude tstamp:(NSString*)timestamp
{
    CFStringRef url = CFStringCreateWithFormat(NULL,NULL, CFSTR("http://www.cs.mun.ca/~ddjb25/storeEntry.php?devicename=%@&functionalname=%@&latitude=%@&longitude=%@&timestamps=%@"), devicename,fname,latitude,longitude,timestamp);
    CFStringRef tmpUrl = CFURLCreateStringByAddingPercentEscapes(NULL, url, NULL, NULL,
                                            kCFStringEncodingUTF8);

    CFURLRef myURL = CFURLCreateWithString(kCFAllocatorDefault, tmpUrl, NULL);
    
    CFStringRef requestMethod = CFSTR("GET");
    CFHTTPMessageRef myRequest = CFHTTPMessageCreateRequest(kCFAllocatorDefault, requestMethod, myURL, kCFHTTPVersion1_1);
    
    CFDataRef mySerializedRequest = CFHTTPMessageCopySerializedMessage(myRequest);
    
    CFReadStreamRef requestStream = CFReadStreamCreateForHTTPRequest(NULL, myRequest);
    
    CFReadStreamOpen(requestStream);
    
    NSMutableData *responseBytes = [NSMutableData data];
    
    CFIndex numBytesRead = 0 ;
    do
    {
        UInt8 buf[1024];
        numBytesRead = CFReadStreamRead(requestStream, buf, sizeof(buf));
        
        if(numBytesRead > 0)
            [responseBytes appendBytes:buf length:numBytesRead];
        
    } while(numBytesRead > 0);
    
    CFHTTPMessageRef response = (CFHTTPMessageRef)CFReadStreamCopyProperty(requestStream, kCFStreamPropertyHTTPResponseHeader);
    CFHTTPMessageSetBody(response, (__bridge CFDataRef)responseBytes);
    NSData *responseBodyData = (NSData*)CFBridgingRelease(CFHTTPMessageCopyBody(response));
    NSString *responseBody = [[NSString alloc] initWithData:responseBodyData encoding:NSUTF8StringEncoding];
    if ([responseBody  isEqual: @"success"])
    {
        NSLog(@"Storage successful");
    }
    else
    {
        NSLog(@"Error occurred");
    }
    CFReadStreamClose(requestStream);
    CFRelease(requestStream);
    
    CFRelease(myRequest);
    CFRelease(myURL);
    CFRelease(url);
    CFRelease(mySerializedRequest);
    myRequest = NULL;
    mySerializedRequest = NULL;
    
}

- (void) getAllCameraEvents
{
    CFStringRef url = CFSTR("http://www.cs.mun.ca/~ddjb25/getAllCameraEvents.php");
    CFURLRef myURL = CFURLCreateWithString(kCFAllocatorDefault, url, NULL);
    
    CFStringRef requestMethod = CFSTR("GET");
    CFHTTPMessageRef myRequest = CFHTTPMessageCreateRequest(kCFAllocatorDefault, requestMethod, myURL, kCFHTTPVersion1_1);
    
    CFDataRef mySerializedRequest = CFHTTPMessageCopySerializedMessage(myRequest);
    
    CFReadStreamRef requestStream = CFReadStreamCreateForHTTPRequest(NULL, myRequest);
    
    CFReadStreamOpen(requestStream);
    
    NSMutableData *responseBytes = [NSMutableData data];
    
    CFIndex numBytesRead = 0 ;
    do
    {
        UInt8 buf[1024];
        numBytesRead = CFReadStreamRead(requestStream, buf, sizeof(buf));
        
        if(numBytesRead > 0)
            [responseBytes appendBytes:buf length:numBytesRead];
        
    } while(numBytesRead > 0);
    
    CFHTTPMessageRef response = (CFHTTPMessageRef)CFReadStreamCopyProperty(requestStream, kCFStreamPropertyHTTPResponseHeader);
    CFHTTPMessageSetBody(response, (__bridge CFDataRef)responseBytes);
    NSData *responseBodyData = (NSData*)CFBridgingRelease(CFHTTPMessageCopyBody(response));
    NSString *responseBody = [[NSString alloc] initWithData:responseBodyData encoding:NSUTF8StringEncoding];
    
    NSError *error = nil;
    id object = [NSJSONSerialization
                 JSONObjectWithData:responseBodyData
                 options:0
                 error:&error];
    for (id foo in object)
    {
        float lati = [foo[@"latitude"] floatValue];
        float longi = [foo[@"longitude"] floatValue];
        CLLocationCoordinate2D coords = CLLocationCoordinate2DMake(lati, longi);
        [self createAnnotation:coords fname:foo[@"functionalName"] uname:foo[@"uniqueDeviceName"] timestamp:foo[@"timestamps"]];
    }
    
    CFReadStreamClose(requestStream);
    CFRelease(requestStream);
    
    CFRelease(myRequest);
    CFRelease(myURL);
    CFRelease(url);
    CFRelease(mySerializedRequest);
    myRequest = NULL;
    mySerializedRequest = NULL;
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations

{
    CLLocation *newLocation = locations.lastObject;
    
    CLLocation *loc1 = [[CLLocation alloc] initWithLatitude:locMe.latitude longitude:locMe.longitude];
    CLLocation *loc2 = [[CLLocation alloc] initWithLatitude:newLocation.coordinate.latitude longitude:newLocation.coordinate.longitude];
    double distance = [loc1 distanceFromLocation:loc2];
    locMe = [newLocation coordinate];
    
}


@end
