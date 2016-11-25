//
//  LeftMenuController.m
//  FileFly
//
//  Created by jx on 16/4/25.
//  Copyright © 2016年 jx. All rights reserved.
//

#import "LeftMenuController.h"
#import "FirstViewController.h"
#import "SecondViewController.h"
#import "AppDelegate.h"
#import"QuartzCore/QuartzCore.h"
#import "SheZhi.h"
#import "about.h"
#import "history.h"
#import "wenti.h"
@interface LeftMenuController ()<UIImagePickerControllerDelegate,UIActionSheetDelegate>
 {
        NSIndexPath *selectedIndexPath;
    }

@property (strong, nonatomic) NSData *imgData;//图片二进制流
@property (strong, nonatomic) UIImagePickerController *picker;
@property (strong, nonatomic) IBOutlet UITableView *table;


@end

@implementation LeftMenuController
+ (instancetype)controller {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"ZhuYe" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([LeftMenuController class])];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    //图像按钮
    self.imgBtn.layer.cornerRadius = 33;//值越大越圆
    self.imgBtn.layer.masksToBounds = YES;
    //获取主机名称
    NSString *phoneName = [[UIDevice currentDevice]name];
    self.nameLabel.text = phoneName;
    self.imgBtn.layer.cornerRadius = 33;
    self.imgBtn.layer.masksToBounds = YES;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ITRAirSideMenu *itrSideMenu = ((AppDelegate *)[UIApplication sharedApplication].delegate).itrAirSideMenu;
//    update content view controller with setContentViewController
    [itrSideMenu hideMenuViewController];
    selectedIndexPath = indexPath;
}
#pragma mark - tableview
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellString = @"Cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellString];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellString];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:21];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.highlightedTextColor = [UIColor lightGrayColor];
        cell.selectedBackgroundView = [[UIView alloc] init];
    }
//    NSArray *titles = @[@"连接电脑",@"即时传",@"历史",@"设置",@"关于本机"];
//    cell.textLabel.text = titles[indexPath.row];
    NSArray *img = @[@"主页",@"传输",@"历史",@"帮助"];
    UIImageView *imgicon = (UIImageView *)[cell viewWithTag:1000];
    imgicon.image = [UIImage imageNamed:[img objectAtIndex:indexPath.row]];
        NSArray *titles = @[@"首页",@"即时传",@"历史",@"帮助"];
    UILabel *title = (UILabel *)[cell viewWithTag:2000];
    title.textColor = [UIColor whiteColor];
   title.text = [titles objectAtIndex:indexPath.row];
    tableView.separatorStyle = NO;
    return cell;
}

-(void)sideMenu:(ITRAirSideMenu *)sideMenu didHideMenuViewController:(UIViewController *)menuViewController
{
    if (selectedIndexPath.row == 0) {
        [sideMenu setContentViewController:[[UINavigationController alloc] initWithRootViewController:[FirstViewController controller]]];
    }
    else if (selectedIndexPath.row ==1)
    {
        [sideMenu setContentViewController:[[UINavigationController alloc] initWithRootViewController:[SecondViewController controller]]];
    }
    else if (selectedIndexPath.row ==2)
    {
                [sideMenu setContentViewController:[[UINavigationController alloc] initWithRootViewController:[history controller]]];
    }
    else if (selectedIndexPath.row ==3)
    {
        [sideMenu setContentViewController:[[UINavigationController alloc] initWithRootViewController:[wenti controller]]];
    }
//    else if (selectedIndexPath.row ==4)
//    {
//        [sideMenu setContentViewController:[[UINavigationController alloc] initWithRootViewController:[about controller]]];
//    }
    
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
    else if (buttonIndex == 2){
        
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
        image = [UIImage imageWithData:self.imgData scale:1.f];
        
        [self.imgBtn setImage:image forState:UIControlStateNormal];
    }
    else
    {
        
        NSLog(@"Error media type");
    }
    
    
    [self.picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 底部按钮跳转事件
- (IBAction)sheZhi:(id)sender {
    SheZhi *sz = [[UIStoryboard storyboardWithName:@"ZhuYe" bundle:nil]instantiateViewControllerWithIdentifier:@"SheZhi"];
//    [self.navigationController pushViewController:sz animated:YES];
    [self presentViewController:sz animated:NO completion:nil];
}

- (IBAction)guanYu:(id)sender {
    about *ab = [[UIStoryboard storyboardWithName:@"ZhuYe" bundle:nil]instantiateViewControllerWithIdentifier:@"about"];
    [self presentViewController:ab animated:NO completion:nil];
}

@end
