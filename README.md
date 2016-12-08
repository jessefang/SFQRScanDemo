# SFQRScanDemo
使用AVFoundation完成的二维码扫描，扫描相册里的二维码需iOS8+才可以支持

#usage

    #import ScanViewController 
    ScanViewController *scanVc = [[ScanViewController alloc]init];
    [self.navigationController pushViewController:scanVc animated:YES];
