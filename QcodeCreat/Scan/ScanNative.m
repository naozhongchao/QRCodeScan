//
//  ScanNative.m
//  Learn
//
//  Created by Apple on 2017/4/20.
//  Copyright © 2017年 YiChuan. All rights reserved.
//

#import "ScanNative.h"
#import <AVFoundation/AVFoundation.h>
@interface ScanNative()<AVCaptureMetadataOutputObjectsDelegate>
@property (nonatomic, strong) AVCaptureDevice *device;
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *layer;
@property (nonatomic, strong) UIView *preView;
@property (nonatomic, assign) CGRect cropRect;

@end
@implementation ScanNative

- (instancetype)initWithPreView:(UIView *)preView cropRect:(CGRect)cropRect
{
    self = [super init];
    if (self) {
        self.preView = preView;
        self.cropRect = cropRect;
        [self setCamera];

    }
    return self;
}


- (void)setCamera {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 初始化相机设备
        self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        
        // 输入流
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
        //先进行判断是否支持控制对焦,不开启自动对焦功能，很难识别二维码。
        if (self.device.isFocusPointOfInterestSupported && [_device isFocusModeSupported:AVCaptureFocusModeAutoFocus])
        {
            [input.device lockForConfiguration:nil];
            [input.device setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
            [input.device unlockForConfiguration];
        }
        // 输出流
        AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
        
        //  CGRectMake（y的起点/屏幕的高，x的起点/屏幕的宽，扫描的区域的高/屏幕的高，扫描的区域的宽/屏幕的宽）
       // [output setRectOfInterest:self.cropRect];
        
        //设置代理，主线程刷新
        [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        
        // 初始化连接对象
        self.session = [[AVCaptureSession alloc] init];
        
        // 设置高质量采集率
        [self.session setSessionPreset:AVCaptureSessionPresetHigh];
        
        if ([_session canAddInput:input]) {
            [self.session addInput:input];
        }
        if ([_session canAddOutput:output]) {
            [self.session addOutput:output];
        }
        
        
        output.metadataObjectTypes = [NSArray arrayWithObjects: AVMetadataObjectTypeQRCode,nil];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.layer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
            self.layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
            self.layer.frame = self.preView.frame;
            [self.preView.layer insertSublayer:self.layer atIndex:0];
            //[self.session startRunning];
        });
    });
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {

    if (metadataObjects.count > 0) {
        __block AVMetadataMachineReadableCodeObject *result = nil;
        [metadataObjects enumerateObjectsUsingBlock:^(AVMetadataMachineReadableCodeObject *obj, NSUInteger idx, BOOL *stop) {
            if ([obj.type isEqualToString:AVMetadataObjectTypeQRCode]) {
                result = obj;
                *stop = YES;
            }
        }];
        if (!result) {
            result = [metadataObjects firstObject];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self analyseResult:result];
        });
    }

    
    
}
- (void)analyseResult:(AVMetadataMachineReadableCodeObject *)result{
    NSString *resultStr = result.stringValue;
    if (resultStr.length <= 0) {
        return;
    }
    //停止扫描
    [self stopScan];
    //震动反馈
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    if (self.scanDelegate && [self.scanDelegate respondsToSelector:@selector(getScanResult:)]) {
        [self.scanDelegate getScanResult:resultStr];
    }
}


- (void)changeFlash:(BOOL)open {
    [self.device lockForConfiguration:nil];
    if ([self.device hasFlash]) {
        if (open) {
            self.device.flashMode = AVCaptureFlashModeOn;
            self.device.torchMode = AVCaptureTorchModeOn;
        }
        else {
            self.device.flashMode = AVCaptureFlashModeOff;
            self.device.torchMode = AVCaptureTorchModeOff;
        }
        
    }
    [self.device unlockForConfiguration];
}

- (void)stopScan {
    [self.session stopRunning];

}
- (void)startScan {
    [self.session startRunning];

}




@end
