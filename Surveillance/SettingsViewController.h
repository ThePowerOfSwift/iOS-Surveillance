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

@interface SettingsViewController : UIViewController
@property (strong, nonatomic) IBOutlet UISwitch *highResolutionSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *greyScaleSwitch;
- (IBAction)greyScaleSwitched:(id)sender;
- (IBAction)resolutionSwitched:(UISwitch *)sender;
@property (strong, nonatomic) IBOutlet UILabel *frameRateValueLabel;

@property (strong, nonatomic) IBOutlet UIStepper *frameRateStepper;
- (IBAction)frameRateStepperChanged;



@end

#endif /* SettingsViewController_h */
