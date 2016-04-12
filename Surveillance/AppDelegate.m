//
//  AppDelegate.m
//  Surveillance
//
//  Created by Dillon Butt on 2016-04-01.
//  Copyright © 2016 Dillon Butt. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize tableData, isGreyScale, isHighResolution, deviceUniqueName, deviceSymbolicName, identifierForVendor, mostRecentEventImage, isMotionDetectionOn;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //global data variable
    tableData = [NSMutableArray arrayWithObjects:@"Placeholder", nil];
    [tableData removeObjectAtIndex:0];
    isGreyScale = NO;
    isHighResolution = NO;
    deviceSymbolicName = @"Camera";
    deviceUniqueName = @"Placeholder Name";
    isMotionDetectionOn = NO;

    //prevent app from automatically disabling
    [UIApplication sharedApplication].idleTimerDisabled = YES;

    // Override point for customization after application launch.
    
    //Colin moved this stuff to interface builder
    /*CameraViewController *cameraVC = [[CameraViewController alloc] init];
    cameraVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Camera" image:[UIImage imageNamed:@"camera"] tag:100];
    
    MapViewController *mapVC = [[MapViewController alloc] init];
    mapVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Map" image:[UIImage imageNamed:@"earth"] tag:101];
    
    MultipeerViewController *multipeerVC = [[MultipeerViewController alloc] init];
    multipeerVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Peer" image:[UIImage imageNamed:@"multipeer"] tag:102];
    
    SettingsViewController *settingsVC = [[SettingsViewController alloc] init];
    settingsVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Settings" image:[UIImage imageNamed:@"gear"] tag:103];
    

    UITabBarController *tabVC = [[UITabBarController alloc] init];
    tabVC.viewControllers = [NSArray arrayWithObjects:cameraVC, mapVC, multipeerVC, settingsVC, nil];
    
    self.window.rootViewController = tabVC;*/
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
