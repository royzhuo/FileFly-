//
//  DiSanFangViewController.m
//  FileFly
//
//  Created by Roy on 16/8/23.
//  Copyright © 2016年 jx. All rights reserved.
//

#import "DiSanFangViewController.h"

@interface DiSanFangViewController ()<UIDocumentInteractionControllerDelegate>

@property (nonatomic, strong) UIDocumentInteractionController *documentInteractionController;

@end

@implementation DiSanFangViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    ////url 为需要调用第三方打开的文件地址
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath=[paths lastObject];
    NSURL *url=[NSURL fileURLWithPath:docPath];
    
    _documentInteractionController=[UIDocumentInteractionController interactionControllerWithURL:url];
    _documentInteractionController.delegate=self;
    [_documentInteractionController presentOpenInMenuFromRect:self.view.bounds inView:self.view animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
   


@end
