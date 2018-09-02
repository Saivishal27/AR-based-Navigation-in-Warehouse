//
//  BarcodeScannerViewController.m
//  LadingApp
//
//  Created by rk1023 on 02/03/16.
//  Copyright © 2016 CommScope, Inc. All rights reserved.
//

#import "BarcodeScannerViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "AppDelegate.h"

@interface BarcodeScannerViewController ()

@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong) AppDelegate *appDelegate;
@property (nonatomic) BOOL isReading;

-(void)stopReading;
-(void)loadBeepSound;

@end

@implementation BarcodeScannerViewController
@synthesize delegate;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if(self == [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    if([self startCapture])
    {
        [self addOutput];
        [_captureSession startRunning];
    }
    else
    {
        if(self.delegate != nil && [self.delegate respondsToSelector:@selector(didDetectErrorWhileScanningForBarcode:)])
        {
            NSError *error = [NSError errorWithDomain:@"com.BillOfLading.ScannerUnavailable" code:01 userInfo:nil];
            [self.delegate didDetectErrorWhileScanningForBarcode:error];
        }
    }
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction method implementation

-(BOOL)startCapture
{
    NSError *error;
    
    // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video
    // as the media type parameter.
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Get an instance of the AVCaptureDeviceInput class using the previous device object.
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    
    if (!input)
    {
        // If any error occurs, simply log the description of it and don't continue any more.
        //NSLog(@"%@", [error localizedDescription]);
        
        return NO;
        //[self displayAdvisory:YES :kAdvBarcodeScanningNotSupportedTitle :kAdvBarcodeScanningNotSupportedDesc :NO];
    }
    
    // Initialize the captureSession object.
    _captureSession = [[AVCaptureSession alloc] init];
    // Set the input device on the capture session.
    [_captureSession addInput:input];
    
    
    // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
    
    //[captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    
    // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    _videoPreviewLayer.frame = CGRectMake(4, 4, self.barCodeScanningView.frame.size.width-8, self.barCodeScanningView.frame.size.height-8);
    //[_videoPreviewLayer setFrame:self.barCodeScanningView.layer.bounds];
    [self.barCodeScanningView.layer addSublayer:_videoPreviewLayer];
    
    // Start video capture.
    return YES;
}

-(void)addOutput
{
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [_captureSession addOutput:captureMetadataOutput];
    
    // Create a new serial dispatch queue.
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    captureMetadataOutput.metadataObjectTypes = [captureMetadataOutput availableMetadataObjectTypes];
}

- (IBAction)startStopReading:(id)sender
{
    [self.barCodeScanningView performSelectorOnMainThread:@selector(setBackgroundColor:) withObject:[UIColor redColor] waitUntilDone:YES];

    if ([self.btnScanLeft.titleLabel.text isEqualToString:@"Scan"])
    {
        // This is the case where the app should read a QR code when the start button is tapped.
        if(![_captureSession isRunning])
        {
            [_captureSession startRunning];
        }
        [self setScanBtnsTitle:@"Pause"];
    }
    else
    {
        // In this case the app is currently reading a QR code and it should stop doing so.
        //[self stopReading];
        [_captureSession startRunning];
        [self setScanBtnsTitle:@"Scan"];
    }
    // Set to the flag the exact opposite value of the one that currently has.
}

-(void)setScanBtnsTitle:(NSString*)title
{
    [self.btnScanLeft setTitle:title forState:UIControlStateNormal];
    [self.btnScanRight setTitle:title forState:UIControlStateNormal];
}

#pragma mark - Private method implementation

-(void)stopReading
{
    // Stop video capture and make the capture session object nil.
    for(id output in _captureSession.outputs)
    {
        if([output isKindOfClass:[AVCaptureMetadataOutput class]])
        {
            [_captureSession removeOutput:output];
        }
    }
}

-(IBAction)btnActnCancel:(UIButton*)sender
{
    [self dismissBarCodeView];
}

-(void)loadBeepSound
{
    // Get the path to the beep.mp3 file and convert it to a NSURL object.
    NSString *beepFilePath = [[NSBundle mainBundle] pathForResource:@"beep" ofType:@"mp3"];
    NSURL *beepURL = [NSURL URLWithString:beepFilePath];
    
    NSError *error;
    
    // Initialize the audio player object using the NSURL object previously set.
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:beepURL error:&error];
    if (error)
    {
        // If the audio player cannot be initialized then log a message.
        NSLog(@"Could not play beep file.");
        //NSLog(@"%@", [error localizedDescription]);
    }
    else
    {
        // If the audio player was successfully initialized then load it in memory.
        [_audioPlayer prepareToPlay];
    }
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate method implementation

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    [self.barCodeScanningView performSelectorOnMainThread:@selector(setBackgroundColor:) withObject:[UIColor redColor] waitUntilDone:YES];
    //NSLog(@"Trying To Detect");

    AVMetadataMachineReadableCodeObject *barCodeObject;
    NSString *detectionString = nil;
    NSArray *barCodeTypes = @[AVMetadataObjectTypeUPCECode, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode39Mod43Code,
                              AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeCode128Code,
                              AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeQRCode, AVMetadataObjectTypeAztecCode];
    
    for (AVMetadataObject *metadata in metadataObjects)
    {
        for (NSString *type in barCodeTypes)
        {
            if ([metadata.type isEqualToString:type])
            {
                barCodeObject = (AVMetadataMachineReadableCodeObject *)[_prevLayer transformedMetadataObjectForMetadataObject:(AVMetadataMachineReadableCodeObject *)metadata];
                detectionString = [(AVMetadataMachineReadableCodeObject *)metadata stringValue];
                break;
            }
        }
        
        if (detectionString != nil)
        {
            [self.barCodeScanningView performSelectorOnMainThread:@selector(setBackgroundColor:) withObject:[UIColor greenColor] waitUntilDone:YES];
            NSLog(@"Detected String = %@",detectionString);
            

                [_captureSession stopRunning];
                [self performSelectorOnMainThread:@selector(setScanBtnsTitle:) withObject:@"Scan" waitUntilDone:NO];
                //[self playbeepSound];
                
                self.appDelegate.detectedBarcode = detectionString;
                double x=0.0,y=0.0;
                if([detectionString isEqualToString:@"0012345678905"])
                {
                    //coffee location
                    x = 17.44816722;
                    y = 78.38316838;
                }
                else if([detectionString isEqualToString:@"9788679912077"])
                {
                    //wellness location
                    x = 17.44830692;
                    y = 78.38256899;
                }
                self.appDelegate.currentDestinationLatitude = x;
                self.appDelegate.currentDestinationLongitude = y;
                [self.delegate didDetectBarcodeHavingString:detectionString];
                
                if(self.delegate != nil && [self.delegate respondsToSelector:@selector(didDetectBarcodeHavingString:)])
                {
                    
                }
                
                break;
            
        }
    }
}

-(void)dismissBarCodeView
{
    [UIView beginAnimations:@"dismissBarCodeView" context:nil];
    [UIView setAnimationDuration:0.8];
    self.view.alpha = 0;
    [_captureSession stopRunning];
    _captureSession = nil;
    
    // Remove the video preview layer from the viewPreview view's layer.
    [_videoPreviewLayer removeFromSuperlayer];
    
    [self.view removeFromSuperview];
    
    [UIView commitAnimations];
}

- (IBAction)btnFlashAction:(UIButton *)sender
{
//    AVCaptureDevice *torch = [[AVCaptureDevice alloc]init];
//    
//    if(torch.torchMode == AVCaptureTorchModeOn)
//    {
//        torch.torchMode = AVCaptureTorchModeOff;
//    }
//    else
//    {
//        torch.torchMode = AVCaptureTorchModeOn;
//    }
}

-(void)disablingFlashButton
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    NSMutableArray *torchDevices = [[NSMutableArray alloc] init];
    BOOL hasTorch = NO;
    
    for (AVCaptureDevice *device in devices)
    {
        if ([device hasTorch]) {
            [torchDevices addObject:device];
        }
    }
    
    hasTorch = ([torchDevices count] > 0);
    if (!hasTorch)
    {
        self.btnFlash.alpha = 0.3;
        self.btnFlash.userInteractionEnabled = NO;
    }
}

- (void)playbeepSound
{
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"ScanningSound" ofType:@"wav"];
    SystemSoundID soundID;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath: soundPath], &soundID);
    AudioServicesPlaySystemSound (soundID);
}

@end
