//
//  AppDelegate.h
//  Surveillance
//
//  Created by Dillon Butt on 2016-04-01.
//  Copyright © 2016 Dillon Butt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSMutableArray *tableData;
@property BOOL isGreyScale;
@property BOOL isHighResolution;
@property NSString* deviceSymbolicName;
@property NSString* deviceUniqueName;
@property(nonatomic, readonly, strong) NSUUID *identifierForVendor;

@end

