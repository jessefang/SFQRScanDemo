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

@interface ScanViewController ()<AVCaptureMetadataOutputObjectsDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (strong, nonatomic)AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic,strong) AVCaptureSession *captureSession;
@property (nonatomic,strong) AVCaptureDevice *avDevice;
@property (nonatomic,strong) AVCaptureDeviceInput *input;
@property (nonatomic,strong) AVCaptureMetadataOutput *output;
@property (nonatomic, strong)ScanView *scanView;

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
    
    self.scanView.scanArea = CGSizeMake(200, 200);
    self.scanView.scanCornerColor = [UIColor colorWithRed:128 / 255.0 green:255 / 255.0 blue:0 / 255.0 alpha:1];;
    [self.view addSubview:self.scanView];
    
    UIButton *popBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    popBtn.frame = CGRectMake(0, 27, 50, 30);
    [popBtn setBackgroundColor:[UIColor clearColor]];
    [popBtn setTitle:@"返回" forState:UIControlStateNormal];
    [popBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [popBtn addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:popBtn];
    
    UIButton *albumBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    albumBtn.frame = CGRectMake(self.view.frame.size.width - 50, 27, 50, 30);
    [albumBtn setBackgroundColor:[UIColor clearColor]];
    [albumBtn setTitle:@"相册" forState:UIControlStateNormal];
    [albumBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [albumBtn addTarget:self action:@selector(openAlbum) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:albumBtn];
    
    //添加扫描区域
    CGFloat screenHeight = self.view.frame.size.height;
    CGFloat screenWidth = self.view.frame.size.width;
    CGRect scanRect = CGRectMake((screenWidth - self.scanView.scanArea.width) / 2, (screenHeight - self.scanView.scanArea.height) / 2, self.scanView.scanArea.width, self.scanView.scanArea.height);
    [self.output setRectOfInterest:CGRectMake(scanRect.origin.y / screenHeight, scanRect.origin.x / screenWidth, scanRect.size.height / screenHeight, scanRect.size.width / screenWidth)];
    
    UILabel *informLable = [[UILabel alloc]initWithFrame:CGRectMake(0, (screenHeight - self.scanView.scanArea.height) / 2 + self.scanView.scanArea.height, screenWidth, 40)];
    informLable.font = [UIFont systemFontOfSize:13];
    informLable.text = @"请将二维码/条码放进扫框内，即可自动扫描";
    informLable.textColor = [UIColor whiteColor];
    informLable.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:informLable];
}

- (void)scanComplete:(scanCompleteBlock)completeBlock{
    self.scanCompleteBlock = completeBlock;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)openAlbum{
    if ([self isPhotoLibraryAvailable]) {
        UIImagePickerController *controller = [[UIImagePickerController alloc]init];
        controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        controller.delegate = self;
        [self presentViewController:controller animated:YES completion:^{
            NSLog(@"Picker View Controller is presented");
        }];
    }else{
        NSLog(@"设备不支持打开相册");
    }
}

- (BOOL)isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];
}

#pragma mark - UImagePicker Delegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    NSLog(@"cancel");
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];
    __block UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    if (!image) {
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{ CIDetectorAccuracy : CIDetectorAccuracyHigh }];
    NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
    if (features.count >=1){
        CIQRCodeFeature *feature = [features objectAtIndex:0];
        NSString *scanResult = feature.messageString;
        if (self.scanCompleteBlock) {
            self.scanCompleteBlock(scanResult);
        }
    }else{
        if (self.scanCompleteBlock) {
            self.scanCompleteBlock(@"capture failed");
        }
    }
    [self popViewController];

}


#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    NSString *string;
    if ([metadataObjects count] > 0) {
        [self.captureSession stopRunning];
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        string = metadataObj.stringValue;
        if (self.scanCompleteBlock) {
            self.scanCompleteBlock(string);
        }
    }else{
        if (self.scanCompleteBlock) {
            self.scanCompleteBlock(@"capture failed");
        }
    }
    [self popViewController];
}

- (void)popViewController{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - initialize & set,get method
- (ScanView *)scanView{
    if (!_scanView) {
        _scanView = [[ScanView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _scanView.backgroundColor = [UIColor clearColor];
        _scanView.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2);
    }
    return _scanView;
}

- (void)setScanAreaSize:(CGSize)scanAreaSize{
    _scanAreaSize = scanAreaSize;
    self.scanView.scanArea = _scanAreaSize;
}

- (void)setScanAreaCornerColor:(UIColor *)scanAreaCornerColor{
    _scanAreaCornerColor = scanAreaCornerColor;
    self.scanView.scanCornerColor = _scanAreaCornerColor;
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
