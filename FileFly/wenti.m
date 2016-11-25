//
//  wenti.m
//  FileFly
//
//  Created by jx on 16/5/25.
//  Copyright © 2016年 jx. All rights reserved.
//

#import "wenti.h"
#import "wenti1.h"
#import "wenti2.h"
#import "wenti3.h"
#import "wenti4.h"
#import "FirstViewController.h"
#import "MBProgressHUD.h"
@interface wenti ()<UITableViewDelegate,UITableViewDataSource>
{
    MBProgressHUD *HUD;
}
@property(nonatomic,strong)NSArray *arrayQuestion;
@end

@implementation wenti
//控制器可以让左边侧滑找到当前class
+ (instancetype) controller{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"wenti" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([wenti class])];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"常见问题";
    UIBarButtonItem *BackBtn = [[UIBarButtonItem alloc]initWithTitle:nil style:UIBarButtonItemStyleDone target:self action:@selector(BackBtnAction)];
    [BackBtn setImage:[UIImage imageNamed:@"houtui_icon"]];
    self.navigationItem.leftBarButtonItem = BackBtn;
    self.arrayQuestion = [NSArray arrayWithObjects:@"怎么选择头像？",@"怎么面对面传输？",@"怎么发送文件?",@"怎么管理文件?", nil];
    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - tabledelege
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayQuestion.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellString = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellString];
    if (cell ==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellString];
    }
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:1000];
    titleLabel.text = self.arrayQuestion[indexPath.row];
    UIImageView *image = (UIImage *)[cell viewWithTag:2000];
    image.image = [UIImage imageNamed:@"后退箭头"];
    return cell;
}
#pragma mark - cell点击
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        wenti1 *vc = [[UIStoryboard storyboardWithName:@"wenti" bundle:nil]instantiateViewControllerWithIdentifier:@"wenti1"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.row==1) {
        wenti1 *vc = [[UIStoryboard storyboardWithName:@"wenti" bundle:nil]instantiateViewControllerWithIdentifier:@"wenti2"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.row==2) {
        wenti1 *vc = [[UIStoryboard storyboardWithName:@"wenti" bundle:nil]instantiateViewControllerWithIdentifier:@"wenti3"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.row==3) {
        wenti1 *vc = [[UIStoryboard storyboardWithName:@"wenti" bundle:nil]instantiateViewControllerWithIdentifier:@"wenti4"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}
#pragma mark - 按钮点击事件
-(void)BackBtnAction
{

     FirstViewController *vc = [[UIStoryboard storyboardWithName:@"ZhuYe" bundle:nil]instantiateViewControllerWithIdentifier:@"FirstViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
