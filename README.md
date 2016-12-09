# SFQRScanDemo
使用AVFoundation完成的二维码扫描扫

#usage下载

项目项目并导入

`#import "ScanViewController"` 

注：扫描相册里的二维码需iOS8+才可以支持  

`ScanViewController *scanVc = [[ScanViewController alloc]init];`
    
扫码区域大小

`scanVc.scanAreaSize = CGSizeMake(300, 300);`

扫码框四角颜色

`scanVc.scanAreaCornerColor = [UIColor redColor];`

Block 返回扫码结果

    [scanVc scanComplete:^(NSString *scanResult) {
        NSLog(@"%@",scanResult);
    }];


