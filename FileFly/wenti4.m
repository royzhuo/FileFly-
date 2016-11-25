//
//  wenti4.m
//  FileFly
//
//  Created by jx on 16/5/25.
//  Copyright © 2016年 jx. All rights reserved.
//

#import "wenti4.h"
#import "MBProgressHUD.h"
@interface wenti4 ()
{
    MBProgressHUD *HUD;
}
@end

@implementation wenti4

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"常见问题";
    UIBarButtonItem *BackBtn = [[UIBarButtonItem alloc]initWithTitle:nil style:UIBarButtonItemStyleDone target:self action:@selector(BackBtnAction)];
    [BackBtn setImage:[UIImage imageNamed:@"houtui_icon"]];
    self.navigationItem.leftBarButtonItem = BackBtn;
    [self jindu];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)BackBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 进度跳转过程
-(void)jindu
{
    //初始化进度框，置于当前的View当中
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    
    //如果设置此属性则当前的view置于后台
    HUD.dimBackground = YES;
    
    //设置对话框文字
    HUD.labelText = @"请稍等";
    
    //设置模式
    
    //显示对话框
    [HUD showAnimated:YES whileExecutingBlock:^{
        //对话框显示时需要执行的操作
        sleep(1);
    } completionBlock:^{
        //操作执行完后取消对话框
        [HUD removeFromSuperview];
        //        [HUD release];
        HUD = nil;
    }];
}


@end
