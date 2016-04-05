//
//  MapViewController.m
//  Surveillance
//
//  Created by Dillon Butt on 2016-04-02.
//  Copyright © 2016 Dillon Butt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CameraViewController.h"

@implementation CameraViewController

-(void) viewDidLoad
{
    
        //sets the tab bar badge value
        self.tabBarItem.badgeValue = @"1";
        //sets the current time on a label
        NSDate * now = [NSDate date];
        NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
         //[outputFormatter setDateFormat:@"HH:mm:ss"];
        [outputFormatter setDateFormat:@"HH':'mm':'ss' 'dd'/'MM'/'yyyy'"];
        NSString *newDateString = [outputFormatter stringFromDate:now];
        NSLog(@"Timestamp: %@", newDateString);
        _timeStampLabel.text = newDateString;
    }


- (void)viewDidAppear:(BOOL)animated
{


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#

@end