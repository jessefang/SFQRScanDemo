//
//  ScanViewController.h
//  Sample
//
//  Created by 方世峰 on 16/12/8.
//  Copyright © 2016年 richinginfo. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^scanCompleteBlock)(NSString *);

@interface ScanViewController : UIViewController
@property (nonatomic, copy)scanCompleteBlock scanCompleteBlock;
@property (nonatomic, assign)CGSize scanAreaSize;
@property (nonatomic, strong)UIColor *scanAreaCornerColor;

- (void)scanComplete:(scanCompleteBlock)completeBlock;
@end
