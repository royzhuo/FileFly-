//
//  ReceviedViewController.m
//  FileFly
//
//  Created by Roy on 16/5/30.
//  Copyright © 2016年 jx. All rights reserved.
//

#import "ReceviedViewController.h"
#import "AppDelegate.h"
#import "history.h"
#import "KNCirclePercentView.h"
#import "FirstViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "GFWaterView.h"
#import "Reachability.h"
#import "Files.h"
@interface ReceviedViewController()<MCBrowserViewControllerDelegate>
{
     NSString *tips;

}

@property(strong,nonatomic) AppDelegate *appDelegate;
//第三方进度条插件
@property (weak, nonatomic) IBOutlet KNCirclePercentView *circleView;
@property (strong, nonatomic) IBOutlet UILabel *wangluo;
@property (strong, nonatomic) IBOutlet UIImageView *backImage;
@property (strong, nonatomic) IBOutlet UIButton *chzhao;
@end

@implementation ReceviedViewController

-(void)viewDidLoad
{
    [self wangLuoState];
    self.wangluo.text = [NSString stringWithFormat:tips];
    NSLog(@"页面加载完");
//    [self.circleView bringSubviewToFront:ç];
    [self.circleView drawCircleWithPercent:0 duration:2 lineWidth:8 clockwise:YES lineCap:kCALineCapRound    fillColor:[UIColor clearColor] strokeColor:[UIColor orangeColor] animatedColors:nil];
    self.circleView.percentLabel.font=[UIFont systemFontOfSize:20];
    self.circleView.percentLabel.text = @"查找附近设备";
    self.circleView.percentLabel.textColor = [UIColor whiteColor];
//    self.circleView.backgroundColor = [UIColor blackColor];
    


//    //创建进度条
//    if (_progressView==nil) {
//        [self createProgress];
//    }
//    
//    [self.view addSubview:_progressView];
//    //已走过时的颜色
//    _progressView.progressTintColor=[UIColor blueColor];
//    //未走过时的颜色
//    _progressView.trackTintColor=[UIColor grayColor];
    
    //文件开始接收
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startReceviedData:) name:@"MCDidStartReceivingResourceNotification" object:nil];
    //文件接收结束
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishedReceviedData:) name:@"didFinishReceivingResourceNotification" object:nil];
    //文件接收进度
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reveviedProgress:) name:@"MCReceivingProgressNotification" object:nil];
    
    self.title =@"接收界面";
    UIBarButtonItem *BackBtn = [[UIBarButtonItem alloc]initWithTitle:nil style:UIBarButtonItemStyleDone target:self action:@selector(BackBtnAction:)];
    //添加后退按钮图片
    BackBtn.image = [UIImage imageNamed:@"houtui_icon"];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = RGB(18, 183, 245);
    //创建一个高20的假状态栏背景
    
//    UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
//    
//    //将它的颜色设置成你所需要的，这里我选择了黑色，表示我很沉稳
//    
//    statusBarView.backgroundColor=RGB(18, 183, 245);
//    [self.view addSubview:statusBarView];

    //创建波纹
    [NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(createBoWen) userInfo:nil repeats:YES];
    

}
#pragma mark-查找附近设备
- (IBAction)chazhao:(id)sender {
    //初始化工具
    _appDelegate=[[UIApplication sharedApplication] delegate];
    [[_appDelegate multipeer] setupPeerAndSessionByDisplayname:[UIDevice currentDevice].name];
    [[_appDelegate multipeer] setupAdvertiser];
    [[_appDelegate multipeer] setupBrowser];
    [[_appDelegate multipeer].browser setDelegate:self];
    [self presentViewController:[_appDelegate multipeer].browser animated:YES completion:nil];
    NSLog(@"点击了查找！");
}



#pragma mark-创建波纹view
-(void)createBoWen
{
    __block GFWaterView *waterView = [[GFWaterView alloc]initWithFrame:CGRectMake(self.circleView.frame.origin.x+10, self.circleView.frame.origin.y, 200, 200)];
    
    waterView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:waterView];
    [self.view insertSubview:self.chzhao aboveSubview:waterView];
    [UIView animateWithDuration:2 animations:^{
        
        waterView.transform = CGAffineTransformScale(waterView.transform, 2, 2);
        
        waterView.alpha = 0;
        
    } completion:^(BOOL finished) {
        //        [waterView removeFromSuperview];
    }];
}

#pragma mark 创建进度条
//-(void) createProgress
//{
//    UIProgressView *progressView=[[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
//    progressView.frame=CGRectMake(50, 244, 224, 60);
//    
//    _progressView=progressView;
//    
//
//}

#pragma mark 浏览器协议
-(void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController
{
    [[_appDelegate multipeer].browser dismissViewControllerAnimated:YES completion:nil];
}

-(void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController
{
    [[_appDelegate multipeer].browser dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 接收数据
//开始接收
-(void) startReceviedData:(NSNotification *) notification
{
    NSDictionary *dic=[notification userInfo];
}
//接收结束
-(void) finishedReceviedData:(NSNotification *) notification
{
    //    NSDictionary *dict = @{@"resourceName"  :   resourceName,
    //                           @"peerID"        :   peerID,
    //                           @"localURL"      :   localURL
    //                           };
    
    NSDictionary *dic=[notification userInfo];
    NSString *resourceName=[dic valueForKey:@"resourceName"];
    NSURL *localURL=[dic objectForKey:@"localURL"];
//    NSString *localU=[localURL absoluteString];
//    NSData *localUData=[[NSData alloc]initWithBase64EncodedString:localU options:0];
//   localU= [[NSString alloc] initWithData:localUData encoding:NSUTF8StringEncoding];
//   localURL= [NSURL URLWithString:localU];
    
//    UIImageWriteToSavedPhotosAlbum([UIImage imageWithData:fileData], self, @selector(image:didFinishSavingWithError:contextInfo:), nil);

    
    
    NSError *error=nil;
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath=[paths lastObject];
    NSString *filePath=[docPath stringByAppendingPathComponent:resourceName];
    NSURL *fileUrl=[NSURL fileURLWithPath:filePath];
    NSFileManager *fm=[NSFileManager defaultManager];
    [fm copyItemAtURL:localURL toURL:fileUrl error:&error];
    
    
    
    NSArray *imageExtensions=@[@"jpg",@"png",@"jpeg",@"JPG",@"PNG",@"JPEG"];
    NSString *extension = [resourceName pathExtension];
    if ([imageExtensions containsObject:extension]==YES)
    {
        UIImageWriteToSavedPhotosAlbum([UIImage imageWithData:[NSData dataWithContentsOfURL:localURL]], self, nil, nil);
    }
    
    //历史
    [history getFilePathUrl:filePath];
    
    //拷贝到已接收
    NSFileManager *fileManager=[NSFileManager defaultManager];
  NSString *files=  [fileManager directoryContentsAtPath:docPath];
    NSString *recevierFilePath=NULL;
    for (NSString *fileName in files) {
        if ([fileName isEqualToString:@"已接收"]) {
            //文件夹地址
            NSString *foderPath=[docPath stringByAppendingPathComponent:fileName];
            //文件地址
            
            recevierFilePath=[foderPath stringByAppendingPathComponent:resourceName];
        }
    }
    NSString *sourceUrl=[fileUrl absoluteString];
    BOOL isCopySuccess=[fileManager copyItemAtPath:filePath toPath:recevierFilePath error:nil];
    NSLog(@"拷贝is%d",isCopySuccess);
}
//接收进度
-(void)reveviedProgress:(NSNotification *)notification
{
    /*
     [[NSNotificationCenter defaultCenter] postNotificationName:@"MCReceivingProgressNotification"
     object:nil
     userInfo:@{@"progress": (NSProgress *)object}];
     */
    NSDictionary *dic=[notification userInfo];
    NSProgress *progress=(NSProgress *)[dic objectForKey:@"progress"];
    double fractionCompleted=[progress fractionCompleted];
    NSString *receviedData=[NSString stringWithFormat:@"文件接收进度:%.f%%",fractionCompleted*100];
//    [_progressView setProgress:fractionCompleted animated:YES];
//    [_progressView performSelectorOnMainThread:@selector(setProgress:animated:) withObject:nil waitUntilDone:nil];
//    NSLog(@"%@",receviedData);
    double finalResult=fractionCompleted*100;
    if (finalResult==100.f) {
        [self.circleView drawCircleWithPercent:(fractionCompleted*100) duration:1 lineWidth:15 clockwise:YES lineCap:kCALineCapRound fillColor:[UIColor grayColor] strokeColor:[UIColor orangeColor] animatedColors:nil];
        [self.circleView performSelectorOnMainThread:@selector(startAnimation) withObject:nil waitUntilDone:NO];
        NSLog(@"%@",receviedData);

    }
    
}
#pragma mark - 看当前的状态
-(void)wangLuoState
{
    Reachability * reach = [Reachability reachabilityForInternetConnection];
    tips = @" ";
    switch (reach.currentReachabilityStatus)
    {
        case NotReachable:
            tips = @"无网络连接";
            break;
            
        case ReachableViaWiFi:
            tips = @"Wifi";
            break;
            
        case ReachableViaWWAN:
            NSLog(@"移动流量");
        case kReachableVia2G:
            tips = @"2G";
            break;
            
        case kReachableVia3G:
            tips = @"3G";
            break;
            
        case kReachableVia4G:
            tips = @"4G";
            break;
    }
}

#pragma mark -鼠标点击事件
//点击后退的返回事件
-(void)BackBtnAction:(UIButton *)navBackBtn{
    
    
    FirstViewController *vc = [[UIStoryboard storyboardWithName:@"ZhuYe" bundle:nil]instantiateViewControllerWithIdentifier:@"FirstViewController"];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

@end
