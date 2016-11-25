//
//  TextViewController.m
//  FileFly
//
//  Created by Roy on 16/5/5.
//  Copyright © 2016年 Roy. All rights reserved.
//

#import "TextViewController.h"

@implementation TextViewController

-(void)viewDidLoad
{
    self.titleLabel.text=self.titleName;
}

- (IBAction)quxiaoEvent:(id)sender {
    UIAlertController *alertView=[UIAlertController alertControllerWithTitle:@"是否保存" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    UIAlertAction *saveAction=[UIAlertAction actionWithTitle:@"保存" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.delegate getTextViewContent:self.textView.text withTitle:self.titleName];
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [alertView addAction:cancel];
    [alertView addAction:saveAction];
    [self presentViewController:alertView animated:YES completion:nil];
}

- (IBAction)finishEvent:(id)sender {
    
    
    [self.delegate getTextViewContent:self.textView.text withTitle:self.titleName];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
@end
