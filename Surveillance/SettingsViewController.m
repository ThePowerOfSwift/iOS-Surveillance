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

@synthesize manager;
@synthesize timer;

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

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
        NSLog(@"Resolution Switch on");
    }
    else
    {
        global.isHighResolution = NO;
        NSLog(@"Resolution Switch off");
    }
}

- (IBAction)frameRateStepperChanged {
    
    AppDelegate* global = [UIApplication sharedApplication].delegate;
    global.cameraFrameRate = (int) _frameRateStepper.value;
    _frameRateValueLabel.text =  @(_frameRateStepper.value).stringValue;
}

- (IBAction)deviceNameInputFieldEdit:(UITextField *)sender {

    AppDelegate* global = [UIApplication sharedApplication].delegate;
    global.deviceSymbolicName = sender.text;
    [self.view endEditing:TRUE];
}

- (IBAction)earthquakeDetectorSwitched:(UISwitch *)sender {
    
    AppDelegate* global = [UIApplication sharedApplication].delegate;
    
    if ([_earthquakeDetectorSwitch isOn]) {
        global.isMotionDetectionOn = YES;
        NSLog(@"Switch on");
        
        self.manager = [[CMMotionManager alloc] init];
        
        if (self.manager.deviceMotionAvailable == YES) {
            [self startMonitoringMotion];
        }
        else
            NSLog(@"Accelerometer or gyro unavailable!");
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1/2 target:self selector:@selector(getValues:) userInfo:nil repeats:YES];
    }
    else
    {
        global.isMotionDetectionOn = NO;
        [self stopMonitoringMotion];
        NSLog(@"Switch off");
        [self.timer invalidate];
    }
}

-(void) getValues:(NSTimer *) timer {
    
    if (self.manager.accelerometerActive) {
        CMAcceleration acc = self.manager.accelerometerData.acceleration;
        _xAcc = acc.x;
        _yAcc = acc.y;
        _zAcc = acc.z;
    }
    else {
        _xAcc = 0;
        _yAcc = 0;
        _zAcc = 0;
    }
    
    //motion greater than 2.5Gs
    if (fabs(_xAcc) > 2.5 || fabs(_yAcc) > 2.5 || fabs(_zAcc) > 2.5)
    {
        //write the earthquake time to table
        NSDate * now = [NSDate date];
        NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
        [outputFormatter setDateFormat:@"HH':'mm':'ss' 'dd'/'MM'/'yyyy'"];
        NSString *newDateString = [outputFormatter stringFromDate:now];
        NSLog(@"Motion Event: %@", newDateString);
        
        AppDelegate* global = [UIApplication sharedApplication].delegate;
        NSString *earthQuakeEvent = [@"Earthquake: " stringByAppendingString:newDateString];
        [global.tableData addObject:earthQuakeEvent];
    }
}

- (void) startMonitoringMotion {
    self.manager.deviceMotionUpdateInterval = 1.0/kMOTIONUPDATEINTERVAL;
    self.manager.accelerometerUpdateInterval = 1.0/kMOTIONUPDATEINTERVAL;
    self.manager.gyroUpdateInterval = 1.0/kMOTIONUPDATEINTERVAL;
    self.manager.showsDeviceMovementDisplay = YES;
    [self.manager startDeviceMotionUpdates];
    [self.manager startAccelerometerUpdates];
    [self.manager startGyroUpdates];
}

- (void)stopMonitoringMotion {
    [self.manager stopAccelerometerUpdates];
    [self.manager stopGyroUpdates];
}

@end
