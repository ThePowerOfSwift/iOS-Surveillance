//
//  MapViewController.m
//  Surveillance
//
//  Created by Dillon Butt on 2016-04-02.
//  Copyright © 2016 Dillon Butt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CameraViewController.h"
#import "AppDelegate.h"

@implementation CameraViewController

-(void) viewDidLoad
{
    
        //sets the tab bar badge value
        self.tabBarItem.badgeValue = @"1";
    
    //use this one liner to set ANY of the badge values on the parent controller's tab bar.
    [[[[[self tabBarController] tabBar] items] objectAtIndex:2] setBadgeValue:@"test"];    }


- (void)viewDidAppear:(BOOL)animated
{

        //sets the current time on a label
        NSDate * now = [NSDate date];
        NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
         //[outputFormatter setDateFormat:@"HH:mm:ss"];
        [outputFormatter setDateFormat:@"HH':'mm':'ss' 'dd'/'MM'/'yyyy'"];
        NSString *newDateString = [outputFormatter stringFromDate:now];
        NSLog(@"Timestamp: %@", newDateString);
        _timeStampLabel.text = newDateString;
    
        AppDelegate* test = [UIApplication sharedApplication].delegate;
    [test.tableData addObject:newDateString];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#

@end