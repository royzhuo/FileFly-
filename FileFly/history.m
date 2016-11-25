//
//  history.m
//  FileFly
//
//  Created by jx on 16/5/22.
//  Copyright © 2016年 jx. All rights reserved.
//

#import "history.h"
#import "FirstViewController.h"
#import "Files.h"
#import "PreviewController.h"

static NSString *historyForderPath;
@interface history ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{
    NSString *currentFilePath;
}
@property (strong, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) UILabel *detailLabel;
@property(strong,nonatomic)UIImageView *image;
@property(strong,nonatomic)UIButton *caozuo;
//装配临时文件的集合
@property(nonatomic,copy) NSMutableArray *tempFilePaths;
@end

@implementation history
//控制器可以让左边侧滑找到当前class
+ (instancetype) controller{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"guanLi" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([history class])];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"历史记录";
//    self.navigationController.navigationBar.tintColor = RGB(18, 183, 245);
    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIBarButtonItem *BackBtn = [[UIBarButtonItem alloc]initWithTitle:nil style:UIBarButtonItemStyleDone target:self action:@selector(BackBtnAction:)];
    [BackBtn setImage:[UIImage imageNamed:@"houtui_icon"]];
    self.navigationItem.leftBarButtonItem = BackBtn;
    UIButton *cleanBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 0, 60, 30)];
    [cleanBtn addTarget:self action:@selector(qingkong) forControlEvents:UIControlEventTouchUpInside];
    [cleanBtn setTitle:@"清空" forState:UIControlStateNormal];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithCustomView:cleanBtn];
    
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    
    //获取document目录
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath=[paths lastObject];
    currentFilePath=docPath;

    
    //判断是否存在
    NSString * forderName = @"历史";
    historyForderPath = [currentFilePath stringByAppendingPathComponent:forderName];
    [self getFileByDirectoryPath:historyForderPath];
    BOOL *isExitForder = [self isExitForder:forderName withPath:currentFilePath];
    if (isExitForder ==NO) {
        [self createhistoryfoder:forderName withPath:currentFilePath];
    }
    else
    {
        NSLog(@"已存在");
    }
    NSLog(@"%@",currentFilePath);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - table
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _files.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellString = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellString];
    if (cell ==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellString];
    }
    Files *file = self.files[indexPath.row];
    _detailLabel = (UILabel *)[cell viewWithTag:2000];
   _detailLabel.text = file.fileName;
    _image = (UIImageView *)[cell viewWithTag:1000];
    if ([file.fileName isEqualToString:file.imageName]) {
        _image.image = [[UIImage alloc]initWithContentsOfFile:file.filePath];
    }
    else {
        _image.image = [UIImage imageNamed:file.imageName];
    }
    _caozuo = (UIButton *)[cell viewWithTag:3000];
    _caozuo.tag = indexPath.row;
    [_caozuo setImage:[UIImage imageNamed:@"删除"] forState:UIControlStateNormal];
    [_caozuo addTarget:self action:@selector(shanchu:) forControlEvents:UIControlEventTouchUpInside];

    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Files *file = self.files[indexPath.row];
    if (file.thorImageData == nil&&file.filePath!=nil) {
        NSString *filename = [historyForderPath stringByAppendingPathComponent:file.fileName];
        [self readFiles:filename withImage:nil];
    }
}
#pragma mark - 文件操作
-(void)shanchu:(UIButton *)button
{
    [ViewTools showAlertViewByTitle:@"修改记录" withMessage:@"删除记录"];
    Files *file = _files[button.tag];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSError *error;
    BOOL *is = [fm removeItemAtPath:file.filePath error:&error];
    if (is ==NO) {
        NSLog(@"失败");
    }

    [_files removeObject:file];
    [_table reloadData];
}
-(void)qingkong
{
    NSFileManager *fm = [NSFileManager defaultManager];
    for (Files *file in _files) {
        BOOL *isdelete = [fm removeItemAtPath:file.filePath error:nil];
        if (isdelete ==NO) {
            NSLog(@"删除失败");
        }
    }
    [_files removeAllObjects];

    [ViewTools showAlertViewByTitle:@"清空所有记录" withMessage:@"已删除"];
    [_table reloadData];
}


#pragma mark - fileManagerView
-(void) fileManagerView:(NSString *)historyForderPath
{
    //获取docunment路径
//    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    
//    
//    NSString *docPath=[paths lastObject];
//    _currentFilePath=docPath;

    [self getFileByDirectoryPath:historyForderPath];
}
#pragma mark 获取文件夹内容
-(void) getFileByDirectoryPath:(NSString *) url
{
    [self.files removeAllObjects];
    NSFileManager *fm= [NSFileManager defaultManager];
    //列出目录的内容
    NSArray *files= [fm directoryContentsAtPath:url];
    
    if (files.count ==0) {
        UIImageView *blackImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        blackImage.backgroundColor = [UIColor redColor];
    [blackImage setImage:[UIImage imageNamed:@"收发记录"]];
        [self.view addSubview:blackImage];
        self.table.alpha = 0;
    }
        
    
    if (files>0) {
        for (NSString *fileName in files) {

            //将path添加到现有路径末尾
            Files *file=[Files FileWithFileName:fileName withImage:nil withFilePath:[url
 stringByAppendingPathComponent:fileName]];
            file.imageName=[file getFileImage:fileName];
                [self.files addObject:file];
            
        }
        [self.table reloadData];
    }
    
    
}

#pragma mark -鼠标点击事件
//点击后退的返回事件
-(void)BackBtnAction:(UIButton *)navBackBtn{
    
//    [self.navigationController popToViewController:@"FirstViewController" animated:YES
        FirstViewController *vc = [[UIStoryboard storyboardWithName:@"ZhuYe" bundle:nil]instantiateViewControllerWithIdentifier:@"FirstViewController"];

    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 复制和创建文件夹
//创建历史文件夹
-(void)createhistoryfoder:(NSString *)forderName withPath:(NSString *)path
{
    NSLog(@"%@",forderName);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSData *forderdata = [forderName dataUsingEncoding:NSUTF8StringEncoding];
    //将文件名和路径连接起来并以文件的路径形式返回
    NSString *forderPath = [path stringByAppendingPathComponent:forderName];
    historyForderPath =forderPath;
    BOOL isCreate = [fileManager createDirectoryAtPath:forderPath attributes:nil];
    if (isCreate ==NO) {
        NSLog(@"创建文件夹失败");
        [self fileManagerView:forderPath];
    }
    else
    {
        [self fileManagerView:forderPath];
        [_table reloadData];
    }
}
//复制数据到历史文件夹
+(void)getFilePathUrl:(NSString *)url
{
    NSString * forderName = @"历史";
    //获取document目录
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath=[paths lastObject];
    NSString *forderPath = [docPath stringByAppendingPathComponent:forderName];
    historyForderPath =forderPath;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString*path = historyForderPath;
    NSString *fileName=[url lastPathComponent];
    path=[path stringByAppendingPathComponent:fileName];
    BOOL isSuccess= [fileManager copyItemAtPath:url toPath:path error:nil];

    
}
//预览文件
-(void)readFiles:(NSString *)file withImage:(NSData *)imageData
{
    PreviewController *read = [[UIStoryboard storyboardWithName:@"guanLi" bundle:nil]instantiateViewControllerWithIdentifier:@"preView"];
    read.filePath = file;
    read.imageInfo = imageData;
    [self.navigationController pushViewController:read animated:YES];
}

//看是否存在了这个文件夹
-(BOOL)isExitForder:(NSString *)forderName withPath:(NSString *)path
{
    NSFileManager * file = [NSFileManager defaultManager];
    NSString * forderPath = [path stringByAppendingPathComponent:forderName];
    return [file fileExistsAtPath:forderPath];
}
#pragma mark - 懒加载
-(NSMutableArray *)files
{
    if (_files ==nil) {
        _files = [NSMutableArray array];
    }
    return _files;
}
-(NSMutableArray *)tempFilePaths
{
    if (_tempFilePaths ==nil) {
        _tempFilePaths = [NSMutableArray array];
    }
    return _tempFilePaths;
}
@end
