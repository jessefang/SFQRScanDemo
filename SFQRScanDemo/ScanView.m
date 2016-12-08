//
//  ScanView.m
//  Sample
//
//  Created by 方世峰 on 16/12/8.
//  Copyright © 2016年 richinginfo. All rights reserved.
//

#import "ScanView.h"

static const NSTimeInterval ScanLineAnimateDuration = 0.03;

@interface ScanView(){
    UIImageView *scanLine;
    CGFloat scanLineY;
}
@end

@implementation ScanView
- (void)layoutSubviews{
    [super layoutSubviews];
    if (!scanLine) {
        [self addScanLine];
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:ScanLineAnimateDuration target:self selector:@selector(showScanLine) userInfo:nil repeats:YES];
        
        [timer fire];
    }
}

- (void)addScanLine{
    scanLine = [[UIImageView alloc]initWithFrame:CGRectMake(self.bounds.size.width / 2 - self.scanArea.width / 2, self.bounds.size.height / 2 - self.scanArea.height / 2, self.scanArea.width, 2)];
    scanLine.image = [UIImage imageNamed:@"scan_line"];
    scanLine.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:scanLine];
    scanLineY = scanLine.frame.origin.y;
    
}

- (void)showScanLine{
    [UIView animateWithDuration:ScanLineAnimateDuration animations:^{
        CGRect rect = scanLine.frame;
        rect.origin.y = scanLineY;
        scanLine.frame = rect;
    } completion:^(BOOL finished) {
        CGFloat maxBorder = self.frame.size.height / 2 + self.scanArea.height / 2 - 4;
        if (scanLineY > maxBorder) {
            scanLineY = self.frame.size.height / 2 - self.scanArea.height / 2;
        }
        scanLineY++;
    }];
}

#pragma mark - 扫描区域自定义
- (void)drawRect:(CGRect)rect{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGRect screenDrawRect = CGRectMake(0, 0, screenSize.width, screenSize.height);
    CGRect clearDrawRect = CGRectMake(screenDrawRect.size.width / 2 - self.scanArea.width / 2, screenDrawRect.size.height / 2 - self.scanArea.height / 2, self.scanArea.width, self.scanArea.height);
    
    CGContextRef cRef = UIGraphicsGetCurrentContext();
    [self screenFillRectWithCRef:cRef rect:screenDrawRect];
    [self screenClearRectWithCRef:cRef rect:clearDrawRect];
    [self addWhiteSquareWithCRef:cRef rect:clearDrawRect];
    [self addRightAngleLineWithCRef:cRef rect:clearDrawRect];
}

- (void)screenFillRectWithCRef:(CGContextRef)cRef rect:(CGRect)rect{
    CGContextSetRGBFillColor(cRef, 25 / 255.0, 25 / 255.0, 25 / 255.0, 0.5);
    CGContextFillRect(cRef, rect);
}

- (void)screenClearRectWithCRef:(CGContextRef)cRef rect:(CGRect)rect{
    CGContextClearRect(cRef, rect);
}

- (void)addWhiteSquareWithCRef:(CGContextRef)cRef rect:(CGRect)rect{
    CGContextStrokeRect(cRef, rect);
    CGContextSetRGBStrokeColor(cRef, 1, 1, 1, 1);
    CGContextSetLineWidth(cRef, 0.8);
    CGContextAddRect(cRef, rect);
    CGContextStrokePath(cRef);
}

- (void)addRightAngleLineWithCRef:(CGContextRef)cRef rect:(CGRect)rect{
    //设置颜色及线宽
    CGContextSetLineWidth(cRef, 2);
    CGContextSetRGBStrokeColor(cRef, 128 / 255.0, 255 / 255.0, 0 / 255.0, 1);
    //左上角
    CGPoint topLeftAngleA[] = {
        CGPointMake(rect.origin.x + 0.7, rect.origin.y),
        CGPointMake(rect.origin.x + 0.7, rect.origin.y + 15)
    };
    
    CGPoint topLeftAngleB[] = {
        CGPointMake(rect.origin.x, rect.origin.y + 0.7),
        CGPointMake(rect.origin.x + 15, rect.origin.y + 0.7)
    };
    
    [self addLineFromPointA:topLeftAngleA toPointB:topLeftAngleB withCref:cRef];
    //左下角
    CGPoint bottomLeftAngleA[] = {
        CGPointMake(rect.origin.x + 0.7, rect.origin.y + rect.size.height - 15),
        CGPointMake(rect.origin.x + 0.7, rect.origin.y + rect.size.height)
    };
    CGPoint bottomLeftAngleB[] = {
        CGPointMake(rect.origin.x, rect.origin.y + rect.size.height - 0.7),
        CGPointMake(rect.origin.x + 15, rect.origin.y + rect.size.height - 0.7)
    };
    
    [self addLineFromPointA:bottomLeftAngleA toPointB:bottomLeftAngleB withCref:cRef];
    //右上角
    CGPoint topRightAngleA[] = {
        CGPointMake(rect.origin.x + rect.size.width - 15, rect.origin.y + 0.7),
        CGPointMake(rect.origin.x + rect.size.width, rect.origin.y + 0.7)
    };
    CGPoint topRightAngleB[] = {
        CGPointMake(rect.origin.x + rect.size.width - 0.7, rect.origin.y),
        CGPointMake(rect.origin.x + rect.size.width - 0.7, rect.origin.y + 15)
    };
    [self addLineFromPointA:topRightAngleA toPointB:topRightAngleB withCref:cRef];
    //右下角
    CGPoint bottomRightAngleA[] = {
        CGPointMake(rect.origin.x + rect.size.width - 0.7, rect.origin.y + rect.size.height - 15),
        CGPointMake(rect.origin.x + rect.size.height - 0.7, rect.origin.y + rect.size.height)
    };
    CGPoint bottomRightAngleB[] = {
        CGPointMake(rect.origin.x + rect.size.width - 15, rect.origin.y + rect.size.height - 0.7),
        CGPointMake(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height)
    };
    [self addLineFromPointA:bottomRightAngleA toPointB:bottomRightAngleB withCref:cRef];
    
    CGContextStrokePath(cRef);
}

- (void)addLineFromPointA:(CGPoint[])pointA toPointB:(CGPoint[])pointB withCref:(CGContextRef)cRef{
    CGContextAddLines(cRef, pointA, 2);
    CGContextAddLines(cRef, pointB, 2);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
