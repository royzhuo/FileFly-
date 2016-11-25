//
//  FirstViewController.m
//  FileFly
//
//  Created by jx on 16/4/25.
//  Copyright © 2016年 jx. All rights reserved.
//
#import "SecondViewController.h"
#import "FirstViewController.h"
#import "ITRAirSideMenu.h"
#import "AppDelegate.h"
#import "SheZhi.h"
#import "fileGuanLi.h"
#import "Multipeer.h"
#import "CLPopViewController.h"
#import "LLBootstrap.h"

static NSString *historyForderPath;
static NSString *sendForderPath;
static NSString *receiveForderPath;
@interface FirstViewController ()<UIPopoverPresentationControllerDelegate>
{
    NSString *currentFilePath;
}
@property(strong,nonatomic)CLPopViewController *itemPopVC;

@end

@implementation FirstViewController
//即将加载时出现
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"06"] forBarMetrics:UIBarMetricsCompact];
    self.navigationController.navigationBar.barTintColor = [UIColor clearColor];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.layer.masksToBounds = YES;
    
    //获取document目录
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath=[paths lastObject];
    currentFilePath=docPath;
    
    
    //判断是否存在
    NSString * forderName = @"已发送";
    sendForderPath = [currentFilePath stringByAppendingPathComponent:forderName];
//    [self getFileByDirectoryPath:historyForderPath];
    BOOL *isExitForder = [self isExitForder:forderName withPath:currentFilePath];
    if (isExitForder ==NO) {
        [self createhistoryfoder:forderName withPath:currentFilePath];
    }
    else
    {
        NSLog(@"已存在");
    }
    NSLog(@"%@",sendForderPath);
    
    
    //判断是否存在
    NSString * forderNames = @"已接收";
    receiveForderPath = [currentFilePath stringByAppendingPathComponent:forderNames];
//    [self getFileByDirectoryPath:historyForderPath];
    BOOL *isExitForders = [self isExitForder:forderNames withPath:currentFilePath];
    if (isExitForders ==NO) {
        [self createhistoryfoder:forderNames withPath:currentFilePath];
    }
    else
    {
        NSLog(@"已存在");
    }
    NSLog(@"%@",receiveForderPath);
    
    //历史判断是否存在
    NSString * forderNamess = @"历史";
    historyForderPath = [currentFilePath stringByAppendingPathComponent:forderNamess];
    //    [self getFileByDirectoryPath:historyForderPath];
    BOOL *isExitForderss = [self isExitForder:forderNamess withPath:currentFilePath];
    if (isExitForderss ==NO) {
        [self createhistoryfoder:forderNamess withPath:currentFilePath];
    }
    else
    {
        NSLog(@"历史已存在");
    }
    NSLog(@"%@",historyForderPath);
}
//方法滑动返回原来的
+(instancetype) controller
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"ZhuYe" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([FirstViewController class])];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
//标题
    self.title = @"FileFly";
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"菜单" style:UIBarButtonItemStylePlain target:self action:@selector(presentLeftMenuViewController)];
    self.navigationItem.rightBarButtonItem =[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(xiahua)];
    //自定义按钮
    UIButton *buttonInfo = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonInfo setFrame:CGRectMake(self.view.frame.size.width/2 - self.view.frame.size.width/6,self.view.frame.size.height-153,self.view.frame.size.width/3, 33)];
    [buttonInfo setTitle:@"我要发送" forState:UIControlStateNormal];
    [buttonInfo bs_configureAsInfoStyle];
    [self.view addSubview:buttonInfo];
    [buttonInfo addTarget:self action:@selector(fasong) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *buttonInfoo = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonInfoo setFrame:CGRectMake(self.view.frame.size.width/2 - self.view.frame.size.width/6,self.view.frame.size.height-109,self.view.frame.size.width/3, 33)];
    [buttonInfoo setTitle:@"我要接收" forState:UIControlStateNormal];
    [buttonInfoo bs_configureAsInfoStyle];
    [self.view addSubview:buttonInfoo];
    [buttonInfoo addTarget:self action:@selector(jieshou) forControlEvents:UIControlEventTouchUpInside];
    
}
//出现左侧的滑动栏
- (void) presentLeftMenuViewController{
    
    //show left menu with animation
    ITRAirSideMenu *itrSideMenu = ((AppDelegate *)[UIApplication sharedApplication].delegate).itrAirSideMenu;
    [itrSideMenu presentLeftMenuViewController];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 右侧下滑界面
-(void)xiahua
{
    self.itemPopVC = [[CLPopViewController alloc] initWithNibName:@"CLPopViewController" bundle:nil];
    self.itemPopVC.modalPresentationStyle = UIModalPresentationPopover;
    self.itemPopVC.popoverPresentationController.barButtonItem = self.navigationItem.rightBarButtonItem;
    //箭头方向
    self.itemPopVC.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUp;
    //代理
    self.itemPopVC.popoverPresentationController.delegate = self;
    [self presentViewController:self.itemPopVC animated:YES completion:nil];
}

-(UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller
{
    NSLog(@"%@",controller);
    return  UIModalPresentationNone;
}

#pragma mark - 导航栏底下的跳转事件
-(IBAction)SheZhi:(id)sender
{
    SheZhi *sz = [[UIStoryboard storyboardWithName:@"ZhuYe" bundle:nil]instantiateViewControllerWithIdentifier:@"SheZhi"];
    [self presentViewController:sz animated:YES completion:nil];
}
- (IBAction)wenJianGuanLi:(id)sender {
    fileGuanLi *file = [[UIStoryboard storyboardWithName:@"guanLi" bundle:nil]instantiateViewControllerWithIdentifier:@"fileGuanLi"];
   // [self.navigationController pushViewController:file animated:YES];
    [self presentViewController:file animated:YES completion:nil];
}
- (IBAction)kuaiChuan:(id)sender {
    SecondViewController *se = [[UIStoryboard storyboardWithName:@"ChuanShu" bundle:nil]instantiateViewControllerWithIdentifier:@"SecondViewController"];
    [self.navigationController pushViewController:se animated:YES];
}
-(void)fasong
{
        Multipeer *mu = [[UIStoryboard storyboardWithName:@"ChuanShu" bundle:nil]instantiateViewControllerWithIdentifier:@"SecondViewController"];
        [self.navigationController pushViewController:mu animated:YES];
}
-(void)jieshou
{
        Multipeer *mu = [[UIStoryboard storyboardWithName:@"ChuanShu" bundle:nil]instantiateViewControllerWithIdentifier:@"Multipeer"];
        [self.navigationController pushViewController:mu animated:YES];
}
//看是否存在了这个文件夹
-(BOOL)isExitForder:(NSString *)forderName withPath:(NSString *)path
{
    NSFileManager * file = [NSFileManager defaultManager];
    NSString * forderPath = [path stringByAppendingPathComponent:forderName];
    return [file fileExistsAtPath:forderPath];
}
//创建历史文件夹
-(void)createhistoryfoder:(NSString *)forderName withPath:(NSString *)path
{
    NSLog(@"%@",forderName);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSData *forderdata = [forderName dataUsingEncoding:NSUTF8StringEncoding];
    //将文件名和路径连接起来并以文件的路径形式返回
    NSString *forderPath = [path stringByAppendingPathComponent:forderName];
//    historyForderPath =forderPath;
    BOOL isCreate = [fileManager createDirectoryAtPath:forderPath attributes:nil];
    if (isCreate ==NO) {
        NSLog(@"创建文件夹失败");
//        [self fileManagerView:forderPath];
    }
//    else
//    {
//        [self fileManagerView:forderPath];
//        [_table reloadData];
//    }
}

//- (IBAction)fasong:(id)sender {
//    Multipeer *mu = [[UIStoryboard storyboardWithName:@"ChuanShu" bundle:nil]instantiateViewControllerWithIdentifier:@"SecondViewController"];
//    [self.navigationController pushViewController:mu animated:YES];
//}
//- (IBAction)jieshou:(id)sender {
//    Multipeer *mu = [[UIStoryboard storyboardWithName:@"ChuanShu" bundle:nil]instantiateViewControllerWithIdentifier:@"Multipeer"];
//    [self.navigationController pushViewController:mu animated:YES];
//}

@end
