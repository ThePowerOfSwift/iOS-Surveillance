//
//  SettingsViewController.h
//  Surveillance
//
//  Created by Dillon Butt on 2016-04-02.
//  Copyright © 2016 Dillon Butt. All rights reserved.
//

#ifndef SettingsViewController_h
#define SettingsViewController_h
#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <CoreMotion/CoreMotion.h>
#import <CoreMotion/CMSensorRecorder.h>

@interface SettingsViewController : UIViewController
@property (strong, nonatomic) IBOutlet UISwitch *highResolutionSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *greyScaleSwitch;
- (IBAction)greyScaleSwitched:(id)sender;
- (IBAction)resolutionSwitched:(UISwitch *)sender;
@property (strong, nonatomic) IBOutlet UILabel *frameRateValueLabel;

@property (strong, nonatomic) IBOutlet UIStepper *frameRateStepper;
- (IBAction)frameRateStepperChanged;
- (IBAction)deviceNameInputFieldEdit:(UITextField *)sender;
@property (strong, nonatomic) IBOutlet UISwitch *earthquakeDetectorSwitch;

@property (strong, nonatomic) IBOutlet UITextField *deviceNameInputField;
- (IBAction)earthquakeDetectorSwitched:(UISwitch *)sender;
@property (strong,nonatomic) CMMotionManager *manager;
@property (strong,nonatomic) CMSensorRecorder *recorder;
@property (nonatomic, retain) NSTimer *timer;
@property double xAcc, yAcc, zAcc;
#define kMOTIONUPDATEINTERVAL 2

@end

#endif /* SettingsViewController_h */
