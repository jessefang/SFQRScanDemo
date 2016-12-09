//
//  ViewController.m
//  SFQRScanDemo
//
//  Created by 方世峰 on 16/12/8.
//  Copyright © 2016年 richinginfo. All rights reserved.
//

#import "ViewController.h"
#import "ScanViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(30, 130, 80, 30);
    [btn setTitle:@"scan code" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(scanCode) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)scanCode{
    ScanViewController *scanVc = [[ScanViewController alloc]init];
//    scanVc.scanAreaSize = CGSizeMake(300, 300);
//    scanVc.scanAreaCornerColor = [UIColor redColor];
    [scanVc scanComplete:^(NSString *scanResult) {
        NSLog(@"%@",scanResult);
    }];
    
    [self.navigationController pushViewController:scanVc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
