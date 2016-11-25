//
//  PreviewController.h
//  FileFly
//
//  Created by Roy on 16/5/4.
//  Copyright © 2016年 Roy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuickLook/QuickLook.h>
@interface PreviewController : UIViewController

@property(nonatomic,copy) NSString *filePath;
//@property(nonatomic,strong) PreviewController *previewController;
@property(nonatomic,copy) NSData *imageInfo;
@property(nonatomic,copy) NSURL *imageUrl;

@end
