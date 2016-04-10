//
//  CameraViewController.m
//
//
//  Created by Colin Power on 2016-04-02.
//  Copyright © 2016 Colin Power. All rights reserved.
//

#include <opencv2/opencv.hpp>
//using namespace cv;
#import <opencv2/videoio/cap_ios.h>
#include "opencv2/imgcodecs.hpp"

#include "opencv2/imgproc.hpp"
#include "opencv2/videoio.hpp"
#include <opencv2/highgui.hpp>
#include <opencv2/video.hpp>
#include "opencv2/videoio.hpp"
#include "opencv2/core/core.hpp"

#import "opencv2/imgcodecs/ios.h"
#import "AppDelegate.h"
#import "CameraViewController.h"

//UI elemenets
@interface CameraViewController () <CvVideoCameraDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *maskView;
@property (strong, nonatomic) IBOutlet UIView *videoView;
@property (strong, nonatomic) IBOutlet UILabel *timeStampLabel;

@property (strong, nonatomic) IBOutlet UIImageView *eventView;

@property (strong, nonatomic) IBOutlet UIButton *captureButton;
- (IBAction)captureButtonTapped;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
- (IBAction)startTapped:(UIButton *)sender;

//2D OpenCV matrices that represent images
@property cv::Mat img, fgMaskMOG2;

//Global variables
@property int numberOfInputs;
@property int onesCount;
@property int onesCountPrevious;
@property int numberOfEvents;

@property cv::Ptr<cv::BackgroundSubtractor> pMOG2;
@property (strong, nonatomic) CvVideoCamera* videoCamera;

@end

@implementation CameraViewController
@synthesize onesCount, onesCountPrevious;
@synthesize numberOfInputs;
@synthesize numberOfEvents;
@synthesize fgMaskMOG2;
@synthesize videoCamera, eventView;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.timeStampLabel.text = @"Placeholder";
    
    //setup camera stream
    videoCamera = [[CvVideoCamera alloc] initWithParentView:_maskView];
    //[_videoCamera setDefaultAVCaptureSessionPreset:AVCaptureDevicePositionFront];
    videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionBack;
    videoCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPreset352x288;
    //_videoCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPreset1280x720;
    videoCamera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationPortrait;
    //videoCamera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationLandscapeRight;

    // _videoCamera.recordVideo = YES;
    videoCamera.defaultFPS = 30;
    videoCamera.grayscaleMode = NO;
    videoCamera.delegate = self;

    //setup MOG2 operation
    _pMOG2 = cv::createBackgroundSubtractorMOG2(1500, 16, false);
    
    //set inital values
    onesCount = -1;
    onesCountPrevious = -1;
    numberOfEvents = 0;
    numberOfInputs = 0;
    
    //set badge value
    [[[[[self tabBarController] tabBar] items] objectAtIndex:2] setBadgeValue:@"Test"];
}


- (void)viewDidAppear:(BOOL)animated
{
    AppDelegate* global = [UIApplication sharedApplication].delegate;
    
    if (videoCamera.running == NO)
    {
        if (global.isGreyScale == YES)
            videoCamera.grayscaleMode = YES;
        else
            videoCamera.grayscaleMode = NO;
        videoCamera.defaultFPS = global.cameraFrameRate;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 train the MoG background using an inistal history
 when a large increase in number of white pixels in foreground mask occurs
 record this as a suspicious event
 save camera picture for review
 save timestamp of event
 stretch: create bounding box of largest blobs and save as subimage
 */
#pragma mark - Protocol CvVideoCameraDelegate
#ifdef __cplusplus
- (void)processImage:(cv::Mat&)image
{
    _pMOG2->apply(image, fgMaskMOG2, -1);
    
    //process out small noise on the mask
    cv::GaussianBlur(fgMaskMOG2, fgMaskMOG2, cv::Size(3, 3), 2, 2);
    cv::threshold(fgMaskMOG2, fgMaskMOG2, 30, 255, cv::THRESH_BINARY);
    
    //update the model
    if (numberOfInputs == 101)
    {
        numberOfInputs = 0;
        //count numer of true elements in fgMaskMOG2
        onesCountPrevious = onesCount;
        onesCount = cv::countNonZero(fgMaskMOG2);
        NSLog(@"onesCount: %i", onesCount);
        
        if (onesCount - onesCountPrevious > 5000)
        {
            cv::Mat eventImage = image;
            //MAT is in BGR format while iOS uses RGB
            cvtColor(eventImage, eventImage, CV_BGR2RGB);
            UIImage* eventUIImage = MatToUIImage(eventImage);
            //eventView.image = MatToUIImage(eventImage);
            UIImageWriteToSavedPhotosAlbum(eventUIImage, nil, nil, nil);

            //the increase in white pixels indicates new motion has occured
            NSLog(@"onesCountPrevious: %i", onesCountPrevious);
            
            //sets the current time on a label
            NSDate * now = [NSDate date];
            NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
            [outputFormatter setDateFormat:@"HH':'mm':'ss' 'dd'/'MM'/'yyyy'"];
            NSString *newDateString = [outputFormatter stringFromDate:now];
            NSLog(@"Timestamp: %@", newDateString);
            [self.timeStampLabel setText:[outputFormatter stringFromDate:now]];
            
            AppDelegate* global = [UIApplication sharedApplication].delegate;
            [global.tableData addObject:newDateString];
            
            numberOfEvents++;
            NSString* badgeCount = [NSString stringWithFormat:@"%d",numberOfEvents];

            //[[[[[self tabBarController] tabBar] items] objectAtIndex:2] setBadgeValue:@"tset2"];
        }
    }
    else
    {
        image = fgMaskMOG2;
        //cv::Mat backgroundImage;
        //_pMOG2->getBackgroundImage(backgroundImage);
        //image = backgroundImage;

        //get the frame number and write it on the current frame
        rectangle(image, cv::Point(10, 2), cv::Point(100,20), cv::Scalar(255,255,255), -1);
        putText(image, "Mask", cv::Point(15, 15), cv::FONT_HERSHEY_SIMPLEX, 0.5, cv::Scalar(0,0,0));
        numberOfInputs++;
    }
}
#endif

/* Snippet that can find non-zero locations
 cv::Mat binaryImage; // input, binary image
 vector<Point> locations;   // output, locations of non-zero pixels
 cv::findNonZero(binaryImage, locations);
 // access pixel coordinates
 Point pnt = locations[i];
 */


- (IBAction)startTapped:(UIButton *)sender {

    AppDelegate* global = [UIApplication sharedApplication].delegate;
    if (global.isHighResolution == YES)
        videoCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPreset1280x720;
    else
        videoCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPreset352x288;
 
    if (videoCamera.running == NO)
    {
        //stop camera from auto adjusting to prevent noise
        [videoCamera lockBalance];
        [videoCamera lockExposure];
        [videoCamera lockFocus];
        [videoCamera start];
        [sender setTitle: @"Stop" forState: UIControlStateNormal];
    }
    else
    {
        [videoCamera unlockBalance];
        [videoCamera unlockExposure];
        [videoCamera unlockFocus];
        [videoCamera stop];
        [sender setTitle: @"Activate" forState: UIControlStateNormal];
    }
    
    //Show the untouched camera input in videoView
    AVCaptureSession *captureSession = videoCamera.captureSession;
    AVCaptureVideoPreviewLayer *previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:captureSession];
    [previewLayer.connection setVideoOrientation:AVCaptureVideoOrientationPortrait];
    
    UIView *aView = self.videoView;
    previewLayer.frame = aView.bounds; // Assume you want the preview layer to fill the view.
    [aView.layer addSublayer:previewLayer];
}


- (IBAction)captureButtonTapped {
    //save current image
    //generate timestamp for testing
}

- (cv::Mat)cvMatFromUIImage:(UIImage *)image
{
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
    CGFloat cols = image.size.width;
    CGFloat rows = image.size.height;
    
    cv::Mat cvMat(rows, cols, CV_8UC4); // 8 bits per component, 4 channels (color channels + alpha)
    
    CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,                 // Pointer to  data
                                                    cols,                       // Width of bitmap
                                                    rows,                       // Height of bitmap
                                                    8,                          // Bits per component
                                                    cvMat.step[0],              // Bytes per row
                                                    colorSpace,                 // Colorspace
                                                    kCGImageAlphaNoneSkipLast |
                                                    kCGBitmapByteOrderDefault); // Bitmap info flags
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
    CGContextRelease(contextRef);
    
    return cvMat;
}

- (cv::Mat)cvMatGrayFromUIImage:(UIImage *)image
{
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
    CGFloat cols = image.size.width;
    CGFloat rows = image.size.height;
    
    cv::Mat cvMat(rows, cols, CV_8UC1); // 8 bits per component, 1 channels
    
    CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,                 // Pointer to data
                                                    cols,                       // Width of bitmap
                                                    rows,                       // Height of bitmap
                                                    8,                          // Bits per component
                                                    cvMat.step[0],              // Bytes per row
                                                    colorSpace,                 // Colorspace
                                                    kCGImageAlphaNoneSkipLast |
                                                    kCGBitmapByteOrderDefault); // Bitmap info flags
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
    CGContextRelease(contextRef);
    
    return cvMat;
}
@end

