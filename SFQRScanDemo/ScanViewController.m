//
//  ScanViewController.m
//  Sample
//
//  Created by 方世峰 on 16/12/8.
//  Copyright © 2016年 richinginfo. All rights reserved.
//

#import "ScanViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "ScanView.h"

@interface ScanViewController ()<AVCaptureMetadataOutputObjectsDelegate>
@property (strong, nonatomic)AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic,strong) AVCaptureSession *captureSession;
@property (nonatomic,strong) AVCaptureDevice *avDevice;
@property (nonatomic,strong) AVCaptureDeviceInput *input;
@property (nonatomic,strong) AVCaptureMetadataOutput *output;
@end

@implementation ScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.avDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.avDevice error:nil];
    self.output = [[AVCaptureMetadataOutput alloc]init];
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    self.captureSession = [[AVCaptureSession alloc]init];
    [self.captureSession setSessionPreset:AVCaptureSessionPresetHigh];
    
    if ([self.captureSession canAddInput:self.input]) {
        [self.captureSession addInput:self.input];
    }
    if ([self.captureSession canAddOutput:self.output]) {
        [self.captureSession addOutput:self.output];
    }
    self.output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeEAN8Code,AVMetadataObjectTypeCode128Code];
    
    self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
    self.previewLayer.videoGravity = AVLayerVideoGravityResize;
    self.previewLayer.frame = self.view.layer.bounds;
    
    [self.view.layer insertSublayer:self.previewLayer atIndex:0];
    [self.captureSession startRunning];
    
    CGRect screenRect = [UIScreen mainScreen].bounds;
    
    ScanView *scanView = [[ScanView alloc]initWithFrame:screenRect];
    scanView.scanArea = CGSizeMake(200, 200);
    scanView.backgroundColor = [UIColor clearColor];
    scanView.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2);
    [self.view addSubview:scanView];
    
    UIButton *popBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    popBtn.frame = CGRectMake(0, 27, 50, 30);
    [popBtn setImage:[UIImage imageNamed:@"navigation_arrow"] forState:UIControlStateNormal];
    [popBtn addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:popBtn];
    
    //添加扫描区域
    CGFloat screenHeight = self.view.frame.size.height;
    CGFloat screenWidth = self.view.frame.size.width;
    CGRect scanRect = CGRectMake((screenWidth - scanView.scanArea.width) / 2, (screenHeight - scanView.scanArea.height) / 2, scanView.scanArea.width, scanView.scanArea.height);
    [self.output setRectOfInterest:CGRectMake(scanRect.origin.y / screenHeight, scanRect.origin.x / screenWidth, scanRect.size.height / screenHeight, scanRect.size.width / screenWidth)];
    
    UILabel *informLable = [[UILabel alloc]initWithFrame:CGRectMake(0, (screenHeight - scanView.scanArea.height) / 2 + scanView.scanArea.height, screenWidth, 40)];
    informLable.font = [UIFont systemFontOfSize:13];
    informLable.text = @"请将二维码/条码放进扫框内，即可自动扫描";
    informLable.textColor = [UIColor whiteColor];
    informLable.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:informLable];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    NSString *string;
    if ([metadataObjects count] > 0) {
        [self.captureSession stopRunning];
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        string = metadataObj.stringValue;
        NSLog(@"capture content:%@",string);
    }
}
- (void)popViewController{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
