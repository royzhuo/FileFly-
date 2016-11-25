//
//  SHBQRView.h
//  QRCode_Demo
//
//  Created by 李景祥 on 16/08/10.
//  Copyright © 2016年 李景祥. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SHBQRView;

@protocol SHBQRViewDelegate <NSObject>

- (void)qrView:(SHBQRView *)view ScanResult:(NSString *)result;

@end

@interface SHBQRView : UIView

@property (nonatomic, assign) id<SHBQRViewDelegate> delegate;

@property (nonatomic, assign, readonly) CGRect scanViewFrame;

- (void)startScan;
- (void)stopScan;

@end
