//
//  SheZhi.m
//  FileFly
//
//  Created by jx on 16/5/4.
//  Copyright © 2016年 jx. All rights reserved.
//

#import "SheZhi.h"
#import"QuartzCore/QuartzCore.h"
#import "FirstViewController.h"
#import "Reachability.h"
#import "history.h"
#import "Files.h"
@interface SheZhi ()<UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate>
{
    NSString *tips;
}
- (IBAction)houtui:(id)sender;
@property(nonatomic,strong)NSArray *cellTitle;
@property(nonatomic,strong)NSArray *cellDetail;
@property (strong, nonatomic) NSData *imgData;//图片二进制流
@property (strong, nonatomic) UIImagePickerController *picker;
@property(strong,nonatomic)NSMutableArray *files;
@end

@implementation SheZhi
//控制器可以让左边侧滑找到当前class
+ (instancetype) controller{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"ZhuYe" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([SheZhi class])];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //按钮圆角
    self.ImgBtn.layer.cornerRadius = 33;//值越大越圆
    self.ImgBtn.layer.masksToBounds = YES;
//    self.title = @"设置";
//    //顶部导航栏后退的按钮
//    UIBarButtonItem *BackBtn = [[UIBarButtonItem alloc]initWithTitle:nil style:UIBarButtonItemStyleDone target:self action:@selector(BackBtnAction:)];
//    //添加后退按钮图片
//    BackBtn.image = [UIImage imageNamed:@"houtui_icon"];
//    //将后退按钮图片赋值
//    self.navigationItem.leftBarButtonItem = BackBtn;
    self.tuPian.backgroundColor = RGB(18, 183, 245);
    //隐藏线条
    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.navigationController.navigationBar.translucent = NO;
//    self.navigationController.navigationBarHidden = NO;
    //读取本机的名称
//    NSDictionary *infoDictionary =[[NSBundle mainBundle]infoDictionary];
    //隐藏状态栏
//    self.navigationController.navigationBar.barTintColor = RGB(18, 183, 245);
    NSString *userPhoneName = [[UIDevice currentDevice]name];
    NSLog(@"%@",userPhoneName);
    self.Namelabel.text = userPhoneName;
    //读取机器型号
    NSString *model = [[UIDevice currentDevice]model];
    NSLog(@"%@",model);
    //文件标题
    self.cellTitle = [NSArray arrayWithObjects:@"接收确认",@"检测状态",@"清空历史", nil];
    self.cellDetail = [NSArray arrayWithObjects:@"导入接收的图片到系统图库",@"检测当前所处的网络状态",@"清空历史记录和缓存", nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - tabledasoure
//几组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cellTitle.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellString = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellString];
    if (cell ==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellString];
    }
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:1000];
    titleLabel.text = [self.cellTitle objectAtIndex:indexPath.row];
    UILabel *detailLabl = (UILabel *)[cell viewWithTag:2000];
    detailLabl.text = [self.cellDetail objectAtIndex:indexPath.row];
    UISwitch *switch1 = (UISwitch *)[cell viewWithTag:3000];
    
    //switch的初始状态
    if (indexPath.row ==0) {
        [switch1 setOn:YES animated:YES];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.row ==1) {
        switch1.hidden = YES;
    }
    if (indexPath.row ==2) {
        switch1.hidden = YES;
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.row ==1) {
        [self wangLuoState];
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"当前网络状态为:%@",tips] delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alertView show];
    }
        
        if (indexPath.row ==2) {
            NSFileManager *fi = [NSFileManager defaultManager];
            NSString * forderName = @"历史";
            //获取document目录
            NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *docPath=[paths lastObject];
            NSString *forderPath = [docPath stringByAppendingPathComponent:forderName];
            NSLog(@"%@",forderPath);
            history *hi = [[history alloc]init];
            NSArray *array = [fi directoryContentsAtPath:forderPath];
            
            
            
            if (array>0) {
                for (NSString *fileName in array) {
                    
                    //将path添加到现有路径末尾
                    Files *file=[Files FileWithFileName:fileName withImage:nil withFilePath:[forderPath
                                                                    stringByAppendingPathComponent:fileName]];
                    file.imageName=[file getFileImage:fileName];
                    BOOL issucesss = [fi removeItemAtPath:file.filePath error:nil];
                    if (issucesss == NO) {
                        NSLog(@"删除失败");
                    }
                }
                [self.files removeAllObjects];
                [ViewTools showAlertViewByTitle:@"提示" withMessage:@"清空成功!"];
            
            
        }
    
}
}

#pragma mark - switch
- (IBAction)switchAction:(id)sender {
    UISwitch *mySwitch = (UISwitch *)sender;
    if (mySwitch.isOn) {
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定导入库中！" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alertView show];
        NSLog(@"开启了");
        self.imageIsSave = YES;
    }
    else{
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"关闭导入库中！" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alertView show];
        NSLog(@"关闭的");
        self.imageIsSave = NO;
    }
}
#pragma mark  - 头像按钮事件
- (IBAction)imgAction:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"请选择头像来源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"照相机",@"本地头像", nil];
    [actionSheet showInView:self.view];
}
#pragma UIActionSheet - Delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (self.picker == nil) {
        self.picker = [[UIImagePickerController alloc]init];
        self.picker.delegate = self;
        self.picker.allowsEditing = YES;
    }
    if (buttonIndex == 0) {
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:self.picker animated:YES completion:nil];
        }
        else
        {
//            [self showMessageTip:@"设备不支持" detail:nil timeOut:1.5f];
            

            NSLog(@"无摄像头，无法打开");
        }
        
    }
    else if(buttonIndex == 1){
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:self.picker animated:YES completion:nil];
        }
    }

    
    NSLog(@"button %ld",(long)buttonIndex);
}
#pragma mark - 图片选中事件
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if([mediaType isEqualToString:@"public.image"])	//被选中的是图片
    {
        //获取照片实例
        //[self showMessageTip:@"正在压缩图片" detail:nil timeOut:-1.f];
        
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage] ;
        
        self.imgData = UIImageJPEGRepresentation(image, 0.7);
        FileFlyCenter *fily = [[FileFlyCenter alloc]init];
        fily.imageData = self.imgData;
        image = [UIImage imageWithData:self.imgData scale:1.f];
        
        [self.ImgBtn setImage:image forState:UIControlStateNormal];
    }
    else
    {
        
        NSLog(@"Error media type");
    }
    
    
    [self.picker dismissViewControllerAnimated:YES completion:nil];
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
    
    //           [[self navigationController] popViewControllerAnimated:YES];
    FirstViewController *vc = [[UIStoryboard storyboardWithName:@"ZhuYe" bundle:nil]instantiateViewControllerWithIdentifier:@"FirstViewController"];
    
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)houtui:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}
@end

