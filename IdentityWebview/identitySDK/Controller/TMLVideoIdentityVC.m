//
//  TMLVideoIdentityVC.m
//  identityForH5
//
//  Created by tml on 2017/3/22.
//  Copyright © 2017年 charles. All rights reserved.
//

#import "TMLVideoIdentityVC.h"
#import "TMLWebView.h"
#import "identityContants.h"
#import "MBProgressHUD.h"
#import <AVFoundation/AVFoundation.h>
// 相册库
#import <AssetsLibrary/AssetsLibrary.h>

//static CGFloat DegreesToRadians(CGFloat degrees) {return degrees * M_PI / 180;};

@interface TMLVideoIdentityVC ()

/**
 * 相机回话 执行 输入设备和输出设备之间 数据传递
 */
@property(nonatomic , strong) AVCaptureSession * session;
/**
 * 输入设备
 */
@property(nonatomic , strong) AVCaptureDeviceInput * videoInput;
/**
 * 照片输出流
 */
@property(nonatomic , strong) AVCaptureStillImageOutput * stillImageOutput;
/**
 * 预览图层
 */
@property(nonatomic , strong) AVCaptureVideoPreviewLayer * previewLayer;
/**
 * 是否开启人脸识别
 */
@property(nonatomic , assign) BOOL * detectFaces;
/**
 * 人脸检测框
 */
@property(nonatomic , strong) UIImage *square;
/**
 * 人脸识别对象
 */
@property(nonatomic , strong) CIDetector *faceDetector;
@property(nonatomic , strong) AVCaptureVideoDataOutput * videoDataOutput;

@end

@implementation TMLVideoIdentityVC

#pragma mark- 生命周期方法
- (void)viewDidLoad {
    [super viewDidLoad];


    [self checkUrl];
    
    _square = [UIImage imageNamed:@"squarePNG"] ;

}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
  
}

-(void)viewWillDisappear:(BOOL)animated:(BOOL)animated {
    [super viewDidDisappear:animated];

    if (_session) {
        [_session stopRunning];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma Mark : - 检查身份验证
-(void)checkUrl {
    
    BOOL needCheckIdentity = [_urlStr hasPrefix:CHECK_PREFIX];
    
    if (needCheckIdentity) {
        
        _urlStr =  [_urlStr stringByReplacingOccurrencesOfString:CHECK_PREFIX withString:HTTP_PREFIX];
        TMLLog(@"%@-->开始人脸验证",_urlStr);
        
        [self loadAVCaptureSession];
        if (_session) {
            
            [_session startRunning];
        }
        
    }else{
        
        [self openVideoWebView];
        TMLLog(@"%@-->无需验证",_urlStr);
    }
}

-(void)openVideoWebView{
    
    if (_session) {
        
        [_session stopRunning];
    }
    
    TMLWebView * webView = [[TMLWebView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    NSURL * url = [NSURL URLWithString:_urlStr];
    
    NSURLRequest * request = [[NSURLRequest alloc] initWithURL:url];
    
    [webView loadRequest:request];
    
    [self.view addSubview:webView];
    
}


#pragma mark- 相机
-(void)loadAVCaptureSession {
    // 创建会话
    _session = [[AVCaptureSession alloc] init];
    
    NSError * error;
    
    
    AVCaptureDevice *device = nil;
    NSArray *cameras = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *camera in cameras) {
        if (camera.position == AVCaptureDevicePositionFront) {//取得前置摄像头
            device = camera;
        }
    }
    if(!device) {
        NSLog(@"取得前置摄像头错误");
        return;
    }
    
    // 自动对焦
    [device lockForConfiguration:nil];
    
    [device isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus];
    
    [device unlockForConfiguration];
    
    // 实例化 输入对象
    _videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:device error:&error];
    if (error) {
        
        TMLLog(@"%@",error);
    }
    
    
    // 实例化 输出对象
    _stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    
    // 输出设置 输出格式: JPEG ...
    NSDictionary * setting = [NSDictionary dictionaryWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey ,nil];
    [_stillImageOutput setOutputSettings:setting];
    
    
    if ([_session canAddInput:_videoInput]) {
        [_session addInput:_videoInput];
    }
    
    if ([_session canAddOutput:_stillImageOutput]) {
        [_session addOutput:_stillImageOutput];
    }
    
    // 实例化预览图层
    _previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_session];
    [_previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    _previewLayer.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64);

    [self.view.layer addSublayer:_previewLayer];
    
    if ([_session canSetSessionPreset:AVCaptureSessionPreset640x480]) {
        _session.sessionPreset = AVCaptureSessionPreset640x480;
        
        // [self toggleFaceDetection];
        
        // 延迟三秒拍照
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            
            if (_session.isRunning) {
                TMLLog(@"拍照");
                [self takePhoto];

            }
        
        });
        
    } else {
        TMLLog(@"无法调取摄像头");
    }
}

// 拍照
- (void)takePhoto{
    
    AVCaptureConnection *stillImageConnection = [self.stillImageOutput        connectionWithMediaType:AVMediaTypeVideo];
    UIDeviceOrientation curDeviceOrientation = [[UIDevice currentDevice] orientation];
    AVCaptureVideoOrientation avcaptureOrientation = [self avOrientationForDeviceOrientation:curDeviceOrientation];
    [stillImageConnection setVideoOrientation:avcaptureOrientation];
    
    //设置相机焦距
    [stillImageConnection setVideoScaleAndCropFactor:1];
    
    
    
    __weak typeof(self) weakSelf = self;
    
    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:stillImageConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        
        
        NSData *jpegData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        
    
    
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
      
        hud.labelText =  NSLocalizedString(@"加载中...", @"HUD loading title");
        
        
        
        NSString * jpegRet = [jpegData base64EncodedStringWithOptions:0];
       
        TMLLog(@"%@",jpegRet);
        
        
        // 延迟三秒 跳转播放视屏
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            TMLLog(@"跳转播放视屏");
            [weakSelf openVideoWebView];
        });
        
       
    }];
}


// 获取设备输出方向
-(AVCaptureVideoOrientation)avOrientationForDeviceOrientation:(UIDeviceOrientation)deviceOrientation {
    
    AVCaptureVideoOrientation result = (AVCaptureVideoOrientation)deviceOrientation;
    if ( deviceOrientation == UIDeviceOrientationLandscapeLeft )
        result = AVCaptureVideoOrientationLandscapeRight;
    else if ( deviceOrientation == UIDeviceOrientationLandscapeRight )
        result = AVCaptureVideoOrientationLandscapeLeft;
    
    return result;
}



// 展示人脸框
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
