//
//  BarcodeScannerViewController.h
//  LadingApp
//
//  Created by rk1023 on 02/03/16.
//  Copyright © 2016 CommScope, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol BarcodeScannerDelegate <NSObject>

@required

-(void)didDetectBarcodeHavingString:(NSString*)barcodeData;
-(void)didDetectErrorWhileScanningForBarcode:(NSError*)error;

@end

@interface BarcodeScannerViewController : UIViewController<AVCaptureMetadataOutputObjectsDelegate>
{
    AVCaptureSession *_session;
    AVCaptureDevice *_device;
    AVCaptureDeviceInput *_input;
    AVCaptureMetadataOutput *_output;
    AVCaptureVideoPreviewLayer *_prevLayer;
}

@property (weak, nonatomic) IBOutlet UIButton *btnScanLeft;
@property (weak, nonatomic) IBOutlet UIButton *btnScanRight;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UIView *barCodeScanningView;
@property (weak, nonatomic) IBOutlet UIView *btnFlash;
@property (weak, nonatomic) IBOutlet UIImageView *imgGreenWindow;
@property (weak, nonatomic) id delegate;

-(void)dismissBarCodeView;

@end
