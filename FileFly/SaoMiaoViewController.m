//
//  SaoMiaoViewController.m
//  FileFly
//
//  Created by jx on 16/8/12.
//  Copyright © 2016年 jx. All rights reserved.
//

#import "SaoMiaoViewController.h"
#import "SHBQRView.h"
@interface SaoMiaoViewController ()<SHBQRViewDelegate>

@end

@implementation SaoMiaoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    SHBQRView *saomiaoView = [[SHBQRView alloc]initWithFrame:self.view.bounds];
    saomiaoView.delegate = self;
    [self.view addSubview:saomiaoView];
    [saomiaoView addSubview:self.guanyu];
    [self.view addSubview:self.daoHang];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)qrView:(SHBQRView *)view ScanResult:(NSString *)result
{
    [view stopScan];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@" 扫描的结果为: %@",result] preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [view startScan];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}
- (IBAction)houtui:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
