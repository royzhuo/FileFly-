//
//  Multipeer.m
//  FileFly
//
//  Created by jx on 16/5/17.
//  Copyright © 2016年 jx. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "Multipeer.h"
#import "SecondViewController.h"
#import "Files.h"
#import "MBProgressHUD.h"
#import "KNCirclePercentView.h"
@interface Multipeer ()<UIActionSheetDelegate>
{
    NSInteger *muqianState;
    CGFloat height;
    CGFloat width;
    MBProgressHUD *HUD;
    NSString *currentFilePath;
}

@property(nonatomic,strong) NSString *currentFilePath;
@property(nonatomic,strong)NSTimer *timer;
@property (nonatomic) CGFloat percentage;
@property (nonatomic) CGFloat percentageEnd;
@property (weak, nonatomic) IBOutlet KNCirclePercentView *autoCalculateCircleView;
@end

@implementation Multipeer

- (void)viewDidLoad {
    [super viewDidLoad];
    //默认的进度
    [self.autoCalculateCircleView drawCircleWithPercent:0
                                               duration:5
                                              lineWidth:15
                                              clockwise:YES
                                                lineCap:kCALineCapRound
                                              fillColor:[UIColor clearColor]
                                            strokeColor:[UIColor orangeColor]
                                         animatedColors:nil];
    self.autoCalculateCircleView.percentLabel.font = [UIFont systemFontOfSize:35];
    
    self.title =@"传输界面";
    UIBarButtonItem *BackBtn = [[UIBarButtonItem alloc]initWithTitle:nil style:UIBarButtonItemStyleDone target:self action:@selector(BackBtnAction:)];
    //添加后退按钮图片
    BackBtn.image = [UIImage imageNamed:@"houtui_icon"];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.barTintColor = RGB(18, 183, 245);
    fileDate = [[NSMutableArray alloc]init];
    receiveDate = [[NSMutableArray alloc]init];
    //获取document目录
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath=[paths lastObject];
    _currentFilePath=docPath;
    //设置属性
    height = self.view.frame.size.width;
    width = self.view.frame.size.width;
    
}
#pragma mark -视图即将加载
//-(void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    self.percentage = 0;
//    self.percentageEnd = 0.75;
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
//    
//}
//#pragma mark - 视图即将消失
//-(void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    
//    self.roundProgressBar.percentage = 0;
//    [self.timer invalidate];
//}
#pragma mark - 按钮事件
- (IBAction)shareClick:(UIButton *)sender {
    if (!self.mySession) {
        [self setUpMultipeer];
    }
    [self showBrowserVC];
}

- (IBAction)xians:(id)sender {
    //初始化进度框，置于当前的View当中
//    HUD = [[MBProgressHUD alloc] initWithView:self.view];
//    [self.view addSubview:HUD];
//    
//    //如果设置此属性则当前的view置于后台
//    HUD.dimBackground = YES;
//    
//    //设置对话框文字
//    HUD.labelText = @"请稍等";
//    
//    //设置模式
//    
//    //显示对话框
//    [HUD showAnimated:YES whileExecutingBlock:^{
//        //对话框显示时需要执行的操作
//        sleep(1);
//    } completionBlock:^{
//        //操作执行完后取消对话框
//        [HUD removeFromSuperview];
////        [HUD release];
//        HUD = nil;
//    }];
    
    // Auto calculate radius
    [self.autoCalculateCircleView drawCircleWithPercent:70
                                               duration:1.5
                                              lineWidth:15
                                              clockwise:YES
                                                lineCap:kCALineCapRound
                                              fillColor:[UIColor clearColor]
                                            strokeColor:[UIColor orangeColor]
                                         animatedColors:nil];
    self.autoCalculateCircleView.percentLabel.font = [UIFont systemFontOfSize:35];
    [self.autoCalculateCircleView startAnimation];
    
    
}

- (IBAction)sendClick:(UIButton *)sender {
    [self sendData];

    
}

#pragma mark - 初始化框架
-(void)setUpMultipeer
{
    //  Setup peer ID
    self.myPeerID = [[MCPeerID alloc] initWithDisplayName:[UIDevice currentDevice].name];
    
    //  Setup session
    self.mySession = [[MCSession alloc] initWithPeer:self.myPeerID];
    self.mySession.delegate = self;
    
    //  Setup BrowserViewController
    self.browserVC = [[MCBrowserViewController alloc] initWithServiceType:@"chat" session:self.mySession];
    self.browserVC.delegate = self;
    
    //  Setup Advertiser
    self.advertiser = [[MCAdvertiserAssistant alloc] initWithServiceType:@"chat" discoveryInfo:nil session:self.mySession];
    [self.advertiser start];
}
-(void)showBrowserVC
{
    [self presentViewController:self.browserVC animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dismissBrowserVC
{
    if (muqianState ==0) {
        [self dismissViewControllerAnimated:YES completion:^(void){
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"连接失败" message:@"设备连接失败" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
            [alert show];
            alert = nil;
            }];
    }
    else if (muqianState ==2)
    {
    [self dismissViewControllerAnimated:YES completion:^(void){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"连接成功" message:@"设备连接成功" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alert show];
        alert = nil;
    }];
    }
}
#pragma mark - MCBrowserViewDelegate
-(void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController
{
    [self dismissBrowserVC];
    [receiveDate removeAllObjects];
}
-(void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController
{
    [self dismissBrowserVC];
}
#pragma mark - MCsession
-(void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID
{
    NSLog(@"data receiveddddd : %lu",(unsigned long)data.length);
    if (data.length > 0) {
        if (data.length < 2) {
            noOfDataSend++;
            NSLog(@"noofdatasend : %zd",noOfDataSend);
            NSLog(@"array count : %zd",fileDate.count);
            if (noOfDataSend < ([fileDate count])) {
//                NSLog(@"开始接收数据...");
//                UIImage *image=[UIImage imageWithData:data];
//                //保存到相册
//                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
                
                
                [self.mySession sendData:[fileDate objectAtIndex:noOfDataSend] toPeers:[self.mySession connectedPeers] withMode:MCSessionSendDataReliable error:nil];
            }else {
                [self.mySession sendData:[@"File Transfer Done" dataUsingEncoding:NSUTF8StringEncoding] toPeers:[self.mySession connectedPeers] withMode:MCSessionSendDataReliable error:nil];
            }
        } else {
            if ([[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] isEqualToString:@"File Transfer Done"]) {
                [self appendFileData];
            }else {
                [self.mySession sendData:[@"1" dataUsingEncoding:NSUTF8StringEncoding] toPeers:[self.mySession connectedPeers] withMode:MCSessionSendDataReliable error:nil];
                [receiveDate addObject:data];
            }
        }
    }
}
// Received a byte stream from remote peer
- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID
{
    NSLog(@"did receive stream");
}

//进度条
- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress
{
//    NSDictionary *dict = @{@"resourceName"  :   resourceName,
//                           @"peerID"        :   peerID,
//                           @"progress"      :   progress
//                           };
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"MCDidStartReceivingResourceNotification"
//                                                        object:nil
//                                                      userInfo:dict];
//    
//    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [progress addObserver:self.progress
//                   forKeyPath:@"fractionCompleted"
//                      options:NSKeyValueObservingOptionNew
//                      context:nil];
//    });
//    [self.progress setProgress:progress.fractionCompleted];
}

// Finished receiving a resource from remote peer and saved the content in a temporary location - the app is responsible for moving the file to a permanent location within its sandbox
- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error
{
    NSLog(@"finish receiving resource");
}

-(void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state
{
    NSLog(@"change state : %zd",state);
    muqianState = state;
}

#pragma mark - Other Methods

-(void)sendData
{
//    NSMutableData *sendData=[[NSMutableData alloc]init];
//    NSKeyedArchiver *ar=[[NSKeyedArchiver alloc]initForWritingWithMutableData:sendData];
//    [ar encodeObject:self.dic forKey:@"dic"];
//    [ar finishEncoding];
    [fileDate removeAllObjects];
    [receiveDate removeAllObjects];
//    NSData *sendData = UIImagePNGRepresentation([UIImage imageNamed:@"02"]);
//    NSData *sendData = UIImageJPEGRepresentation(_imageArray[0], 1);
    //将数组逐个转换传输
    NSLog(@"数组文件的个数%lu",(unsigned long)_imageArray.count);
//    NSData *sendData = [NSKeyedArchiver archivedDataWithRootObject:_imageArray];
//    for (int i = 0; i<_imageArray.count; i++) {
//        UIImage *image = [_imageArray objectAtIndex:i];
//        NSData *sendData = UIImagePNGRepresentation(image);
//    }
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:self.imageArray forKey:@"image"];
    NSData *sendData = [NSKeyedArchiver archivedDataWithRootObject:dict];
    NSUInteger length = [sendData length];
    NSUInteger chunkSize = 100*1024;
    NSUInteger offset = 0;
    
    do {
        NSUInteger thisChunkSize = length - offset > chunkSize ? chunkSize : length - offset;
        NSLog(@"thisChunkSize length : %lu",(unsigned long)thisChunkSize);
        NSData* chunk = [NSData dataWithBytesNoCopy:(char *)[sendData bytes] + offset
                                             length:thisChunkSize
                                       freeWhenDone:NO];
        NSLog(@"chunk length : %lu",(unsigned long)chunk.length);
        
        [fileDate addObject:[NSData dataWithData:chunk]];
        offset += thisChunkSize;
    } while (offset < length);
    
    noOfdata = [fileDate count];
    noOfDataSend = 0;
    
    if ([fileDate count] > 0) {
        [self.mySession sendData:[fileDate objectAtIndex:noOfDataSend] toPeers:[self.mySession connectedPeers] withMode:MCSessionSendDataReliable error:nil];
        offset = 0;
    }
}


-(void)appendFileData
{
    NSMutableData *fileData = [NSMutableData data];
    
    for (int i = 0; i < [receiveDate count]; i++) {
        [fileData appendData:[receiveDate objectAtIndex:i]];
    }
    
    [fileData writeToFile:[NSString stringWithFormat:@"%@/Image.png", [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]] atomically:YES];
    
    UIImageWriteToSavedPhotosAlbum([UIImage imageWithData:fileData], self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
//    NSKeyedUnarchiver *ua=[[NSKeyedUnarchiver alloc]initForReadingWithData:fileData];
//    NSDictionary *dic=[ua decodeObjectForKey:@"dic"];
//    for (id key in dic) {
//        id value=[dic objectForKey:key];
//        [self writeDataInDocument:value withName:key];
//    }
//    [ua finishDecoding];
    
}


-(void) writeDataInDocument:(id) content withName:(id) key
{
    
    NSLog(@"key is :%@,data :%@",key,content);
    NSFileHandle *outFile;
    NSFileManager *fm=[NSFileManager defaultManager];
    
    NSString *fileName=key;
    NSString *fullFileName=[_currentFilePath stringByAppendingPathComponent:fileName];
    Files *tempFile=[[Files alloc]init];
    if ([[tempFile getFileImage:fileName] isEqualToString:fileName]) {
        //存入图片
        [content writeToFile:[NSString stringWithFormat:@"%@/@", _currentFilePath,fileName] atomically:YES];
        
        UIImageWriteToSavedPhotosAlbum([UIImage imageWithData:content], self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        
    }else{
        
        BOOL *isCreate=[fm createFileAtPath:fullFileName contents:content attributes:nil];
        if(isCreate==YES) [ViewTools showAlertViewByTitle:@"发送成功" withMessage:@"保存成功"];
        else [ViewTools showAlertViewByTitle:@"发送失败" withMessage:@"反正失败了"];
    }
    
    
    
    
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (!error) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"发送成功" message:@"保存成功" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alert show];
        alert = nil;
    }
}
//#pragma mark - 进度条
//-(void)createProcess
//{
//    
//}
//#pragma mark - 时间监听
//- (void)timerFired:(NSTimer *)timer
//{
//    self.percentage += 0.01;
//    if (self.percentage >= self.percentageEnd) {
//        [self.timer invalidate];
//    }
//    
//    
//    self.roundProgressBar.percentage = self.percentage;
//    
//}
#pragma mark -鼠标点击事件
//点击后退的返回事件
-(void)BackBtnAction:(UIButton *)navBackBtn{
    
    
        SecondViewController *vc = [[UIStoryboard storyboardWithName:@"ZhuYe" bundle:nil]instantiateViewControllerWithIdentifier:@"SecondViewController"];
        
        [self.navigationController pushViewController:vc animated:YES];

}
@end
