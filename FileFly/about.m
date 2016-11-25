//
//  about.m
//  FileFly
//
//  Created by jx on 16/5/19.
//  Copyright © 2016年 jx. All rights reserved.
//

#import "about.h"
#import "FirstViewController.h"
@interface about ()

@end

@implementation about
//控制器可以让左边侧滑找到当前class
- (void)viewDidLoad {
    [super viewDidLoad];
    //顶部导航栏后退的按钮
//    UIBarButtonItem *BackBtn = [[UIBarButtonItem alloc]initWithTitle:nil style:UIBarButtonItemStyleDone target:self action:@selector(BackBtnAction:)];
//    //添加后退按钮图片
//    BackBtn.image = [UIImage imageNamed:@"houtui_icon"];
//    //将后退按钮图片赋值
//    self.navigationItem.leftBarButtonItem = BackBtn;
//    self.title = @"关于";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -鼠标点击事件
//点击后退的返回事件
//-(void)BackBtnAction:(UIButton *)navBackBtn{
//    
//    //           [[self navigationController] popViewControllerAnimated:YES];
//    FirstViewController *vc = [[UIStoryboard storyboardWithName:@"ZhuYe" bundle:nil]instantiateViewControllerWithIdentifier:@"FirstViewController"];
//    
//    [self.navigationController pushViewController:vc animated:YES];
//}

- (IBAction)fanhui:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}
@end
