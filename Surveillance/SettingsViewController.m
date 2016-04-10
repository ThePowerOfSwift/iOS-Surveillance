//
//  SettingsViewController.m
//  Surveillance
//
//  Created by Dillon Butt on 2016-04-02.
//  Copyright © 2016 Dillon Butt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SettingsViewController.h"
#import "AppDelegate.h"

@implementation SettingsViewController


- (IBAction)greyScaleSwitched:(id)sender {

    AppDelegate* global = [UIApplication sharedApplication].delegate;
    
    if ([_greyScaleSwitch isOn]) {
        global.isGreyScale = YES;
        NSLog(@"Greyscale switch on");
    }
    else
    {
        global.isGreyScale = NO;
        NSLog(@"Greyscale switch off");
    }
}

- (IBAction)resolutionSwitched:(UISwitch *)sender {
    
    AppDelegate* global = [UIApplication sharedApplication].delegate;
    
    if ([_highResolutionSwitch isOn]) {
        global.isHighResolution = YES;
        NSLog(@"Switch on");
    }
    else
    {
        global.isHighResolution = NO;
        NSLog(@"Switch off");
    }
}
- (IBAction)frameRateStepperChanged {
    
    AppDelegate* global = [UIApplication sharedApplication].delegate;
    global.cameraFrameRate = (int) _frameRateStepper.value;
    _frameRateValueLabel.text =  @(_frameRateStepper.value).stringValue;;
}
@end
