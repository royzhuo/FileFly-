    //
//  SecondViewController.m
//  FileFly
//
//  Created by jx on 16/4/25.
//  Copyright © 2016年 jx. All rights reserved.
//
#import "FirstViewController.h"
#import "SecondViewController.h"
#import "AppDelegate.h"
#import "YHJTabPageScrollView.h"
#import "Masonry.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "showImage.h"
#import "blueTooth.h"
#import "ViewTools.h"
#import "Files.h"
#import "PreviewController.h"
#import "Multipeer.h"
#import "MBProgressHUD.h"
#import <Photos/Photos.h>
#import "Photo.h"
//#import "PhotoViewController.h"
//  ALAssetsLibrary.h 代表资源库(所有的视频,照片)
//    ALAssetsGroup.h   代表资源库中的相册
//     ALAsset.h         代表相册中一个视频或者一张照片
//     ALAssetRepresentation.h 代表一个资源的描述,可以获取到原始图片
#define heights      45.0
#define widths       80.0
static NSString *identifier = @"cell";
const static NSString *idf=@"tbcell";
const static NSString *tableViewID=@"tcell";
@interface SecondViewController ()<UIActionSheetDelegate,YHJTabPageScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UINavigationBarDelegate,MCBrowserViewControllerDelegate>
{
    UIView *View2;
    ALAssetsLibrary *library;//照片数据库
//    UIImage *_selectBtn;//是否选择按钮
    BOOL isSelected;
//    UICollectionView * CollectionView ;
    
    
    //选择文件视图
    UIView *view1;
    //图片数量视图
    UILabel *label1;
    UIImage *selectImg;
   
    
    
}
//图片放大缩小
@property(nonatomic,strong)UIImage *imageView;
@property(nonatomic,weak) UIButton *selectedButton;
@property(copy,nonatomic)YHJTabPageScrollView *pageControl;
@property(strong,nonatomic)NSMutableArray *selectedRecipes;
@property (nonatomic, strong) NSMutableIndexSet* selectedIndexSet;
@property(strong,nonatomic)UIButton *finishBtn;
//@property(nonatomic,assign)BOOL isSelected;
@property(strong,nonatomic) NSMutableArray *files;
@property(strong,nonatomic) UITableView *tableview;
@property(strong,nonatomic) NSString *currentFilePath;
@property(strong,nonatomic) NSMutableArray *selectedFiles;
@property(strong,nonatomic) MBProgressHUD *HUD;
@property(strong,nonatomic) AppDelegate *appDelegate;
@property(strong,nonatomic) PHCachingImageManager *imageManger;
@property(strong,nonatomic) PHFetchResult *allFetchResult;
@property(strong,nonatomic) PHContentEditingInputRequestOptions *edOption;




@end

@implementation SecondViewController

//当前页面坐标
int currentViewIndex=0;

//控制器可以让左边侧滑找到当前class
+ (instancetype) controller{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"ChuanShu" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([SecondViewController class])];
}



#pragma view lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    _appDelegate=[[UIApplication sharedApplication]delegate];
    [[_appDelegate multipeer] setupPeerAndSessionByDisplayname:[UIDevice currentDevice].name];
    [[_appDelegate multipeer] setupAdvertiser];
    
    
    
    isSelected = NO;
    //允许多选
    self.CollectionView.allowsMultipleSelection = YES;
    //顶部导航栏后退的按钮
    UIBarButtonItem *BackBtn = [[UIBarButtonItem alloc]initWithTitle:nil style:UIBarButtonItemStyleDone target:self action:@selector(BackBtnAction:)];
    //添加后退按钮图片
    BackBtn.image = [UIImage imageNamed:@"houtui_icon"];
    //将后退按钮图片赋值
    self.navigationItem.leftBarButtonItem = BackBtn;
    self.navigationItem.title = @"选择文件";
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor redColor]}];
    
//    self.navigationController.navigationBar.barTintColor = [UIColor redColor];
    UIView *barView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    barView.backgroundColor = RGB(18, 183, 245);
    [self.view addSubview:barView];
//    
//    NSArray *kkk = [self.view subviews];
//    [self.view bringSubviewToFront:self.navigationController.navigationBar];
    //隐藏状态栏
    self.navigationController.navigationBar.translucent = YES;
    
    //添加滑动视图
    view1 = [UIView new];
    view1.backgroundColor = [UIColor clearColor];
    View2 = [[UIView alloc] initWithFrame:self.view.bounds];
//    UIView *View3 = [UIView new];
//    View3.backgroundColor = [UIColor yellowColor];
    UIView *View4 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, heights)];
    View4.backgroundColor = [UIColor lightGrayColor];
    [View2 addSubview:View4];

    //view2完成按钮
    UIButton *btn1 =[[UIButton alloc]initWithFrame:CGRectMake(View4.frame.size.width - 120, View4.frame.origin.y+10,150, 25)];
    [btn1 setTitle:@"发送" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(finish) forControlEvents:UIControlEventTouchUpInside];
    [View4 addSubview:btn1];
    //标题
    label1 = [[UILabel alloc]initWithFrame:CGRectMake(View4.frame.origin.x+10, View4.frame.origin.y+10,150, 25)];
    [View4 addSubview:label1];
    
    //给头部滑动条添加滑动view
    NSArray *page = @[[[YHJTabPageScrollViewPageItem alloc]initWithTabName:@"文件" andTabView:view1],[[YHJTabPageScrollViewPageItem alloc]initWithTabName:@"图片" andTabView:View2]];
//    ,[[YHJTabPageScrollViewPageItem alloc]initWithTabName:@"音乐" andTabView:View3]
    //将滑动集合给滑动式图
    _pageControl = [[YHJTabPageScrollView alloc]initWithPageItems:page];
    //将自己的view添加滑动视图
    UIView *rootView = self.view;
    [rootView addSubview:_pageControl];
    
    
    UIView *toolView=[[UIView alloc]initWithFrame:CGRectMake(0, rootView.frame.size.height-60,rootView.frame.size.width, 60)];
    toolView.backgroundColor=[UIColor clearColor];
    UIButton *sendDataBtn=[[UIButton alloc]init];
    sendDataBtn.frame=CGRectMake(toolView.frame.size.width/2-toolView.frame.size.width/4, 10, toolView.frame.size.width/2, 40);
    CGRect rootFrame=sendDataBtn.frame;
    sendDataBtn.backgroundColor=RGB(135, 206, 250);
    [sendDataBtn.layer setCornerRadius:8];
    [sendDataBtn setTitle:@"发送" forState:UIControlStateNormal];
    [sendDataBtn addTarget:self action:@selector(sendData:) forControlEvents:UIControlEventTouchUpInside];
    [toolView addSubview:sendDataBtn];
    [rootView addSubview:toolView];
    //添加约束（没有没法显示）
    [_pageControl mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(rootView.mas_top).offset(60);
        make.left.equalTo(rootView.mas_left);
        make.right.equalTo(rootView.mas_right);
        make.bottom.equalTo(rootView.mas_bottom);
    }];
    _pageControl.delegate=self;
    
    

    
        [self createCollectionView];
    [View2 addSubview:_CollectionView];
//        [self downLodaPhoto];



    
    [self createTableView];
    [view1 addSubview:self.tableview];
    
    currentViewIndex=0;
    if(currentViewIndex==0)
    {
        [self fileManagerView];
       // [self downLodaPhoto];
    }
       // [self createLoading];
    
    Photo *photo=[[Photo alloc]init];
    [photo getFecthResults];
    NSArray *a= [photo getPHAsset:photo.fecthResult];
    int count=a.count;

    
    self.imageManger=[[PHCachingImageManager alloc]init];

}

#pragma mark - 视图即将加载
//-(void)viewDidAppear:(BOOL)animated
//{
//    [self.selectedRecipes removeAllObjects];
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)createLoading
{
    //初始化进度框，置于当前的View当中
        _HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:_HUD];
    
        //如果设置此属性则当前的view置于后台
        _HUD.dimBackground = YES;
    
        //设置对话框文字
        _HUD.labelText = @"加载本地数据";
    
        //设置模式
    
        //显示对话框
        [_HUD showAnimated:YES whileExecutingBlock:^{
            //对话框显示时需要执行的操作
            sleep(1);
        } completionBlock:^{
            //操作执行完后取消对话框
            [_HUD removeFromSuperview];
    //        [HUD release];
            _HUD = nil;
        }];
}
#pragma mark  创建collectionview
-(void) createCollectionView
{
    //创建collectionview
    UICollectionViewFlowLayout *FlowLayout = [[UICollectionViewFlowLayout alloc]init];
    //新建collectionview并且设置属性与屏幕同宽
    _CollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,50, self.view.frame.size.width, self.view.frame.size.height-140) collectionViewLayout:FlowLayout];
    _CollectionView.backgroundColor = [UIColor clearColor];
    _CollectionView.dataSource = self;
    _CollectionView.delegate = self;
    //collectionview与tableview不同的注册单元格
    [_CollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:identifier];
}

#pragma mark 创建tableview
-(void) createTableView
{
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0,
                                                                        self.view.frame.size.width, (self.view.frame.size.height-160)) style:UITableViewStylePlain];
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableview=tableView;
    self.tableview.delegate=self;
    self.tableview.dataSource=self;
    
}
#pragma mark tableview协议
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.files.count>0) {
        Files *file=  self.files[0];
        if (file.allFetchResults!=nil) {
            NSLog(@"照片数量:%d",file.allFetchResults.count);
            [self.files removeAllObjects];
            return file.allFetchResults.count;
        }else return self.files.count;
    }else  return self.files.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell *cell;
    if (self.allFetchResult!=nil) {
        cell=[tableView dequeueReusableCellWithIdentifier:tableViewID];
        if (cell==nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:tableViewID];
        }
        PHAsset *asset=self.allFetchResult[indexPath.item];
        UIView *toolView=[[UIView alloc]init];
        [self.imageManger requestImageForAsset:asset targetSize:CGSizeMake(100, 100) contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            cell.imageView.image=result;
            //cell.textLabel.hidden=YES;
            
            cell.textLabel.text=[NSString stringWithFormat:@"%d",indexPath.item];
            
            UIView *toolView=[[UIView alloc]init];
            toolView.frame=CGRectMake(cell.frame.size.width-60, cell.frame.origin.y, 60, cell.frame.size.height);
            UIButton *selectBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            selectBtn.frame=CGRectMake(0, 0, toolView.frame.size.width, toolView.frame.size.height);
            CGRect frame=selectBtn.frame;
            
            [selectBtn setImage:[UIImage imageNamed:@"def"] forState:UIControlStateNormal];
            selectBtn.tag=indexPath.row;
            [selectBtn addTarget:self action:@selector(selectedImage:) forControlEvents:UIControlEventTouchUpInside];
            [toolView addSubview:selectBtn];
            cell.accessoryView=toolView;
            
            
        }];
        
        
    }else{
        cell=[tableView dequeueReusableCellWithIdentifier:idf];
        if (cell==nil) {
            cell= [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idf];
        }
        
        Files *file=self.files[indexPath.item];
        cell.textLabel.text=file.fileName;
        cell.textLabel.hidden=NO;
        if ([file.imageName isEqualToString:file.fileName]) cell.imageView.image=[[UIImage alloc]initWithContentsOfFile:file.filePath];
        else cell.imageView.image=[UIImage imageNamed:file.imageName];
        UIView *toolView=[[UIView alloc]init];
        
        
        if(![[file.fileName pathExtension] isEqualToString:@""]){
            toolView.frame=CGRectMake(cell.frame.size.width-60, cell.frame.origin.y, 60, cell.frame.size.height);
            UIButton *selectBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            selectBtn.frame=CGRectMake(0, 0, toolView.frame.size.width, toolView.frame.size.height);
            CGRect frame=selectBtn.frame;
            if ([self.selectedFiles containsObject:file]) {
                [selectBtn setImage:[UIImage imageNamed:@"sel"] forState:UIControlStateNormal];
            }else [selectBtn setImage:[UIImage imageNamed:@"def"] forState:UIControlStateNormal];
            
            selectBtn.tag=indexPath.row;
            [selectBtn addTarget:self action:@selector(selectFile:) forControlEvents:UIControlEventTouchUpInside];
            [toolView addSubview:selectBtn];
            cell.accessoryView=toolView;
        }
    }
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.allFetchResult!=nil && self.allFetchResult.count>0) {
        //预览文件
        PreviewController *preView=[[UIStoryboard storyboardWithName:@"guanLi" bundle:nil]instantiateViewControllerWithIdentifier:@"preView"];
        PHAsset *asset=self.allFetchResult[indexPath.row];
        PHContentEditingInputRequestOptions *options=[[PHContentEditingInputRequestOptions alloc]init];
        [asset requestContentEditingInputWithOptions:options completionHandler:^(PHContentEditingInput * _Nullable contentEditingInput, NSDictionary * _Nonnull info) {
            NSURL *imageUrl=contentEditingInput.fullSizeImageURL;
            preView.imageUrl=imageUrl;
            [self.navigationController pushViewController:preView animated:YES];
        }];
        
    }else{
        
        
        Files *file=self.files[indexPath.row];
        NSString *extenion=[file.fileName pathExtension];
        NSLog(@"文件拓展名:%@",extenion);
        if ([extenion isEqualToString:@""] && file.fileName!=nil) {
            //打开文件夹
            _currentFilePath=file.filePath;
            [self getFileByDirectoryPath:_currentFilePath];
        }else if ( extenion!=nil && [extenion isEqualToString:@"dmg"]){
            [ViewTools showAlertViewByTitle:@"这个是app" withMessage:nil] ;
        }else{
            //预览文件
            PreviewController *preView=[[UIStoryboard storyboardWithName:@"guanLi" bundle:nil]instantiateViewControllerWithIdentifier:@"preView"];
            if(file.filePath) preView.filePath=file.filePath;
            else if(file.imageUrl) preView.imageUrl=file.imageUrl;
            [self.navigationController pushViewController:preView animated:YES];
        }
        
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}



#pragma mark 文件视图
-(void) fileManagerView
{
    
    //获取document目录
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath=[paths lastObject];
    _currentFilePath=docPath;
    
    [self getFileByDirectoryPath:docPath];


}

#pragma mark 获取文件夹内容
-(void) getFileByDirectoryPath:(NSString *) url
{
    [self.files removeAllObjects];
    NSFileManager *fm= [NSFileManager defaultManager];
    //列出目录的内容
    NSArray *files= [fm directoryContentsAtPath:url];
    NSString *forderName=[url lastPathComponent];
    if ([forderName isEqualToString:@"相簿"]) {
        
        
        
        PHFetchOptions *options=[[PHFetchOptions alloc]init];
        options.sortDescriptors=@[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
        PHFetchResult *allResults=[PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:options];
        
        Files *file=[[Files alloc]init];
        file.allFetchResults=allResults;
        self.allFetchResult=allResults;
        
        [self.files addObject:file];
        
        [self.tableview reloadData];
        
        //        PhotoViewController *photoViewController=[ViewControllerByStory initViewControllerWithStoryBoardName:@"ChuanShu" withViewId:@"photoView"];
        //        photoViewController.allResults=allResults;
        //        [self.navigationController pushViewController:photoViewController animated:YES];
    }else{
        if (files>0) {
            for (NSString *fileName in files) {
                //将path添加到现有路径末尾
                Files *file=[Files FileWithFileName:fileName withImage:nil withFilePath:[_currentFilePath stringByAppendingPathComponent:fileName]];
                file.imageName=[file getFileImage:fileName];
                [self.files addObject:file];
            }
        }
        [self.tableview reloadData];
    }

}


#pragma mark 滑动页面协议
-(void)YHJTabPageScrollView:(YHJTabPageScrollView *)tabPageScrollView didPageItemSelected:(YHJTabPageScrollViewPageItem *)pageItem withTabIndex:(NSInteger)tabIndex
{
    
    if(tabIndex==0) {
        currentViewIndex=0;
        //        [view1 addSubview:_CollectionView];
        //  [self fileManagerView];
        //[View2 addSubview:_CollectionView];
        //        if(self.array.count>0) return;
        //        else{
        //            [self downLodaPhoto];
        //        }
    }
    
    if (tabIndex==1) {
        currentViewIndex=1;
        //        [View2 addSubview:_CollectionView];
        //        if(self.array.count>0) return;
        //        else{
        //            [self downLodaPhoto];
        //        }
        [self downLodaPhoto];
        
    }
}

#pragma mark 图片加载
-(void) downLodaPhoto
{

//    //    创建可变数组存储资源图片
//    _array = [NSMutableArray array];
//    //创建资源库来访问相册资源
//    library = [[ALAssetsLibrary alloc]init];
////    //遍历资源库中所有相册，usingBlock会调用多少次
//    [library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
//        //如果存在group在遍历
//        if (group) {
//            //遍历相册中所有资源（照片视频）
//            [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
//                if (result) {
//                    [self.array addObject:result];
//                    label1.text = [NSString stringWithFormat:@"相机胶卷(%ld)",_array.count];
//                    NSLog(@"%@",_array);
//                }
//            }];
//            [_CollectionView reloadData];
//        }
//    } failureBlock:^(NSError *error) {
//        NSLog(@"访问失败");
//    }];
    
    [self.files removeAllObjects];
    PHFetchOptions *options=[[PHFetchOptions alloc]init];
    options.sortDescriptors=@[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    PHFetchResult *allResults=[PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:options];
    
    Files *file=[[Files alloc]init];
    file.allFetchResults=allResults;
    self.allFetchResult=allResults;
    
    [self.files addObject:file];
    [self.CollectionView reloadData];
}


#pragma mark - collectionview
//设置分区
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
//设置元素大小框
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    UIEdgeInsets top = {10,25,40,20};
    return top;
}
//设置分区上元素个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.files.count==0) {
        label1.text = @"相机胶卷(0)";
        return 0;
    }else{
        Files *file=self.files[section];
        label1.text = [NSString stringWithFormat:@"相机胶卷(%ld)",self.allFetchResult.count];
        return file.allFetchResults.count;
    }
    
    //return _array.count;
}
//创建UICollectionviewcell
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    PHAsset *asset=self.allFetchResult[indexPath.item];
    if(currentViewIndex==1){
        // 新建图片视图
        UIImageView *ImgView = [[UIImageView alloc] initWithFrame:cell.bounds];
        UIImageView *imgView1 = [[UIImageView alloc]init];
        ImgView.tag = 1000;
        imgView1.tag = 3000;
        
        [self.imageManger requestImageForAsset:asset targetSize:ImgView.frame.size contentMode:PHImageContentModeDefault options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            
            ImgView.image=result;
            imgView1.image = result;
            
            
            
            UIButton *selectButton = [[UIButton alloc] init];
            selectButton.tag = indexPath.row;
            if ([self.selectedRecipes containsObject:asset]) {
                [selectButton setImage:[UIImage imageNamed:@"sel"] forState:UIControlStateNormal];
            }else [selectButton setImage:[UIImage imageNamed:@"def"] forState:UIControlStateNormal];
            //            [selectButton setImage:[UIImage imageNamed:@"def"] forState:UIControlStateNormal];
            //            [selectButton setImage:[UIImage imageNamed:@"sel"] forState:UIControlStateSelected];
            CGFloat width = cell.bounds.size.width;
            selectButton.frame = CGRectMake(width - 25, 0, 25, 25);
            [selectButton addTarget:self action:@selector(checkClick:) forControlEvents:UIControlEventTouchUpInside];
            //    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(maxImage)];
            //    [imgView1 addGestureRecognizer:tap];
            [cell addSubview:ImgView];
            [cell addSubview:imgView1];
            [cell addSubview:selectButton];
            
            
        }];
        
        
        
        
        //        //取出图片视图
        //        ALAsset *result = _array[indexPath.row];
        //        //获取到压缩图
        //        CGImageRef cimg = [result thumbnail];
        //        //转换为UIimage
        //        UIImage *img = [UIImage imageWithCGImage:cimg];
        //        //显示图片
        //        ImgView.image = img;
        //        //获取原图
        //        CGImageRef ref = [[result  defaultRepresentation]fullScreenImage];
        //        //转换为uiimage
        //        UIImage *img1 = [UIImage imageWithCGImage:ref];
        //        //获取原图
        //        imgView1.image = img1;
        
        
    }
    return cell;
}
//设置collectionviewcell大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(80, 80);
}
#pragma mark - 局部放大
//-(UIImage *)maxImage:(NSIndexPath *)indexPath
//{
////        PHAsset *asset=self.allFetchResult[indexPath.item];
////                [self.imageManger requestImageForAsset:asset targetSize:CGSizeMake(160, 160) contentMode:PHImageContentModeDefault options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
////                    UIImage *image=[[UIImage alloc]init];
////                    image=result;
////                    
////                }];
////    return image;
//}

//获取选中的图片数组
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    if (!isSelected) {
//        //通过使用indexPath确定选定项目
//        NSString *selectedRecipe = [_array[indexPath.section]objectAtIndex:indexPath.row];
//        [_selectedRecipes addObject:selectedRecipe];
//    }
//    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    //    if (!isSelected) {
    //        //通过使用indexPath确定选定项目
    //        NSString *selectedRecipe = [_array[indexPath.section]objectAtIndex:indexPath.row];
    //        [_selectedRecipes addObject:selectedRecipe];
    //    }
     UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    
//    NSLog(@"局部放大");
//    NSLog(@"%ld",(long)indexPath.row);
//     self.imageView = [cell viewWithTag:1000];
    PHAsset *asset=self.allFetchResult[indexPath.item];
//            [self.imageManger requestImageForAsset:asset targetSize:self.view.frame.size contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
//                UIImageView *imageView=[[UIImageView alloc]init];
//                imageView.image=result;
//                [showImage ShowImage:self.imageView];
    
    PreviewController *pre=[[UIStoryboard storyboardWithName:@"guanLi" bundle:nil]instantiateViewControllerWithIdentifier:@"preView"];
    
    [asset requestContentEditingInputWithOptions:self.edOption completionHandler:^(PHContentEditingInput * _Nullable contentEditingInput, NSDictionary * _Nonnull info) {
        pre.imageUrl=contentEditingInput.fullSizeImageURL;
        [self.navigationController pushViewController:pre animated:YES];
    }];
    
    
    
//            }];

}
#pragma mark - 点击选择
//点击完成跳转
-(void)finish
{
//    blueTooth *fin = [[UIStoryboard storyboardWithName:@"ChuanShu" bundle:nil]instantiateViewControllerWithIdentifier:@"blueTooth"];
//    [self.navigationController pushViewController:fin animated:YES];
//    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"请选择传输方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"蓝牙",@"WiFi", nil];
//    [actionSheet showInView:self.view];
    [self browserForDevices];
}

#pragma mark 选择要发送的文件
-(void)selectFile:(UIButton *) button
{
    NSLog(@"button tag: %d",button.tag);
    button.selected=!button.selected;
    if (button.selected==YES) {
        [button setImage:[UIImage imageNamed:@"sel"] forState:UIControlStateNormal];
        NSLog(@"选择了第%d个",button.tag);
        Files *file= self.files[button.tag];
        [self.selectedFiles addObject:file];
        
    }else if (button.selected==NO){
        [button setImage:[UIImage imageNamed:@"def"] forState:UIControlStateNormal];
        NSLog(@"取消选择第%d个",button.tag);
        Files *file= self.files[button.tag];
        [self.selectedFiles removeObject:file];
    }
}

-(void)selectedImage:(UIButton *) button
{
    
    NSLog(@"button tag: %d",button.tag);
    button.selected=!button.selected;
    if (button.selected==YES) {
        [button setImage:[UIImage imageNamed:@"sel"] forState:UIControlStateNormal];
        NSLog(@"选择了第%d个",button.tag);
        PHAsset *asset=self.allFetchResult[button.tag];
        [asset requestContentEditingInputWithOptions:_edOption completionHandler:^(PHContentEditingInput * _Nullable contentEditingInput, NSDictionary * _Nonnull info) {
            Files *file=[[Files alloc]init];
            file.flag=button.tag;
            file.imageUrl=contentEditingInput.fullSizeImageURL;
            [self.selectedFiles addObject:file];
        }];
        
    }else if (button.selected==NO){
        [button setImage:[UIImage imageNamed:@"def"] forState:UIControlStateNormal];
        NSLog(@"取消选择第%d个",button.tag);
        Files *file=[self getFileFromSelectedFiles:button.tag];
        [self.selectedFiles removeObject:file];
    }
    
    
}

#pragma mark 查找已选择的文件
-(Files *) getFileFromSelectedFiles:(int *) tag
{
    Files *sendFile;
    for (Files *file in self.selectedFiles) {
        if (tag==file.flag) {
            sendFile=file;
        }
    }
    
    return sendFile;
    
}

//选中图片切换按钮
-(void)checkClick:(UIButton*)button
{

        button.selected = !button.selected;//每次都改变按钮状态
    PHAsset *asset=self.allFetchResult[button.tag];
    if (button.selected ==YES) {
        NSLog(@"选择这张图片的tag%d",button.tag);
        [button setImage:[UIImage imageNamed:@"sel"] forState:UIControlStateNormal];
        //取出图片视图
        [asset requestContentEditingInputWithOptions:self.edOption completionHandler:^(PHContentEditingInput * _Nullable contentEditingInput, NSDictionary * _Nonnull info) {
//            Files *file=[[Files alloc]init];
//            file.imageUrl=contentEditingInput.fullSizeImageURL;
//            file.flag=button.tag;
//            [self.selectedFiles addObject:file];
        NSString *filename=[contentEditingInput.fullSizeImageURL lastPathComponent];
                            NSFileManager *fileManger = [NSFileManager defaultManager];
                            NSString *tempPath=NSTemporaryDirectory();
                            NSLog(@"%@",tempPath);
                            NSString *filePath = [tempPath stringByAppendingPathComponent:filename];
                            NSLog(@"%@",filePath);
                            BOOL isSuccess= [fileManger createFileAtPath:filePath contents:nil attributes:nil];
                            if (isSuccess ==YES) {
                                NSLog(@"成功");
                                //写数据到文件
                                NSData *data;
                                NSArray *imageExtensions=@[@"jpg",@"jpeg",@"JPG",@"JPEG"];
                                if ([imageExtensions containsObject:[filename pathExtension]]==YES) {
            
                                    data = UIImageJPEGRepresentation(contentEditingInput.displaySizeImage, 0.5);
                                    NSLog(@"%d",data.length);
                                } else {
            
                                    data = UIImagePNGRepresentation(contentEditingInput.displaySizeImage);
                                     NSLog(@"%d",data.length);
                                }
                                BOOL IsSuccess=[data writeToFile:filePath atomically:YES];
                                if (IsSuccess ==YES) {
                                    NSLog(@"成功");
                                    Files *file = [[Files alloc]init];
                                    file.filePath = filePath;
                                    file.fileName = filename;
                                    
                                    [self.selectedFiles addObject:file];
                                }
                            }
        }];
        [self.selectedRecipes addObject:asset];
        
        
        
        
        
//        ALAsset *result = _array[button.tag];
//        ALAssetRepresentation *representation = [result defaultRepresentation];
//        NSString *url = [representation url];
//        NSString *filename = [representation filename];
////        NSData *filedata= [[NSData alloc]init];
//        long chang = [representation size];
//        
//
////        NSURL   *photoURL  = [result  valueForProperty:ALAssetPropertyAssetURL];
////            UIImageView *img= [[UIImageView alloc]initWithFrame:CGRectMake(5, 100, 60, 60)];
////        NSString * nsALAssetPropertyURLs = [ result valueForProperty:ALAssetPropertyURLs ] ;
////        NSLog(@"%@",nsALAssetPropertyURLs);
//        NSURL * nsALAssetPropertyAssetURL = [ result valueForProperty:ALAssetPropertyAssetURL ] ;
//        
//        ALAssetsLibrary *lib = [[ALAssetsLibrary alloc] init];
//        [lib assetForURL:nsALAssetPropertyAssetURL resultBlock:^(ALAsset *asset) {
//            ALAssetRepresentation *rep = asset.defaultRepresentation;
//            CGImageRef imageRef = rep.fullResolutionImage;
//            UIImage *image = [UIImage imageWithCGImage:imageRef scale:rep.scale orientation:(UIImageOrientation)rep.orientation];
//            if (image) {
//                NSLog(@"成功");
////                selectImg = image;
//                NSFileManager *fileManger = [NSFileManager defaultManager];
//                NSString *tempPath=NSTemporaryDirectory();
//                NSLog(@"%@",tempPath);
//                NSString *filePath = [tempPath stringByAppendingPathComponent:filename];
//                NSLog(@"%@",filePath);
//                BOOL isSuccess= [fileManger createFileAtPath:filePath contents:nil attributes:nil];
//                if (isSuccess ==YES) {
//                    NSLog(@"成功");
//                    //写数据到文件
//                    NSData *data;
//                    NSArray *imageExtensions=@[@"jpg",@"jpeg",@"JPG",@"JPEG"];
//                    if ([imageExtensions containsObject:[filename pathExtension]]==YES) {
//                        
//                        data = UIImageJPEGRepresentation(image, 0.5);
//                        NSLog(@"%d",data.length);
//                    } else {
//                        
//                        data = UIImagePNGRepresentation(image);
//                         NSLog(@"%d",data.length);
//                    }
//                    BOOL IsSuccess=[data writeToFile:filePath atomically:YES];
//                    if (IsSuccess ==YES) {
//                        NSLog(@"成功");
//                        Files *file = [[Files alloc]init];
//                        file.filePath = filePath;
//                        file.fileName = filename;
//                        
//                        [self.selectedFiles addObject:file];
//                    }
//                    
//                }
//            }
//        } failureBlock:^(NSError *error) {
//            
//        }];
//
//        NSLog(@"文件集合的数量%ld",_selectedFiles.count);
        
    }
    else if (button.selected ==NO){
         NSLog(@"移除这张图片的tag%d",button.tag);
        [button setImage:[UIImage imageNamed:@"def"] forState:UIControlStateNormal];
        Files *file=   [self getFileFromSelectedFiles:button.tag];
        [self.selectedFiles removeObject:file];
        [self.selectedRecipes removeObject:asset];
    }
    NSLog(@"数据图片的个数%ld",_selectedRecipes.count);
    NSLog(@"选中数据图片的个数%ld",self.selectedFiles.count);
}


#pragma mark - uisheetdelete
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
            blueTooth *fin = [[UIStoryboard storyboardWithName:@"ChuanShu" bundle:nil]instantiateViewControllerWithIdentifier:@"Multipeer"];
            [self.navigationController pushViewController:fin animated:YES];
    }
}

#pragma mark -鼠标点击事件
//点击后退的返回事件
-(void)BackBtnAction:(UIButton *)navBackBtn{
    
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath=[paths lastObject];
    if ([docPath isEqualToString:_currentFilePath]) {
        FirstViewController *vc = [[UIStoryboard storyboardWithName:@"ZhuYe" bundle:nil]instantiateViewControllerWithIdentifier:@"FirstViewController"];
        
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        _currentFilePath=[_currentFilePath stringByDeletingLastPathComponent];
        [self getFileByDirectoryPath:_currentFilePath];
        
    }
}
#pragma mark 文件发送
-(void) sendData:(UIButton *) button
{

//    if (self.selectedRecipes.count ==0) {
//        [ViewTools showAlertViewByTitle:@"信息内容" withMessage:@"请选择图片"];
//        return;
//    }
//    else{
//        Multipeer *mu = [[UIStoryboard storyboardWithName:@"ChuanShu" bundle:nil]instantiateViewControllerWithIdentifier:@"Multipeer"];
//        mu.imageArray = _selectedRecipes;
//        [self.navigationController pushViewController:mu animated:YES];
//    }
//    UIImageView *img= [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 60, 60)];
//    UIImage *image = [[UIImage alloc]init];
//    for (Files *file in self.selectedFiles) {
//        NSData *data = [[NSData alloc]init];
//        data = [NSData dataWithContentsOfURL:[NSURL URLWithString:file.fileName]];
        
////        UIImage *image = [[UIImage alloc]initWithData:data];
//        [img setImage:image];
//        [img setNeedsDisplay];
//        NSString *fileUrl=[NSURL fileURLWithPath:file.filePath];
//        NSLog(@"%@",fileUrl);
//        [UIImage imageForAssetUrl:fileUrl success:^(UIImage * aImg) {// 使用本地图片
//            img.image = aImg;
//        } fail:^{// 使用app内置图片
//            img.backgroundColor = [UIColor yellowColor];
//            NSLog(@"失败");
////        }];
//        NSURL *asseturl = [NSURL URLWithString:file.filePath];
//        ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
//        
////        NSString *asseturl = @"assets-library://asset/asset.JPG?id=1000000477&ext=JPG";
//        
//        [assetslibrary assetForURL:asseturl
//                       resultBlock:nil
//                      failureBlock:^(NSError *error) {
//                          NSLog(@"error couldn't get photo");
//                      }];
//        
//        [self.view addSubview:img];
//    }
//    
//    
//    
//    
//    
//    return;
//    for (Files *file in _selectedFiles) {
//        UIImageView *img= [[UIImageView alloc]initWithFrame:CGRectMake(5, 100, 60, 60)];
//    ALAssetsLibrary *lib = [[ALAssetsLibrary alloc] init];
//    [lib assetForURL:file.filePath resultBlock:^(ALAsset *asset) {
//        ALAssetRepresentation *rep = asset.defaultRepresentation;
//        CGImageRef imageRef = rep.fullResolutionImage;
//        UIImage *image = [UIImage imageWithCGImage:imageRef scale:rep.scale orientation:(UIImageOrientation)rep.orientation];
//        if (image) {
//            NSLog(@"成功");
//            [img setImage:image];
//            [self.view addSubview:img];
//        }
//    } failureBlock:^(NSError *error) {
//        
//    }];
//    }
//    
//    return;
    
    
    
    
    NSMutableArray *values=[NSMutableArray array];
    NSMutableArray *keys=[NSMutableArray array];
    
    //获取文件页面的文件
    if(self.selectedFiles.count==0){
        [ViewTools showAlertViewByTitle:@"信息内容" withMessage:@"请选择文件"];
        return;
    }else{
       
        //获取后缀名
//        NSString *extension = [fileName pathExtension];
 NSArray *imageExtensions=@[@"jpg",@"png",@"jpeg",@"JPG",@"PNG",@"JPEG"];
//        if ([imageExtensions containsObject:extension]==YES)
        for (Files *file in self.selectedFiles) {
            [self getFileData:file];
            if (!file.imageData == nil) {
                [values addObject:file.filePath];
            }else if(!file.fileData == nil){
                [values addObject:file.filePath];
            }
            else if ([imageExtensions containsObject:[file.fileName pathExtension]]==YES)
            {
                [values addObject:file.filePath];
            }
        }
        
        [self.selectedFiles removeAllObjects];
        [self.selectedFiles addObjectsFromArray:values];
        
        //        Multipeer *mu=[ViewControllerByStory initViewControllerWithStoryBoardName:@"ChuanShu" withViewId:@"Multipeer"];
        //        mu.filePaths=values;
        //        mu.tableView=self.tableview;
        //        [self.navigationController pushViewController:mu animated:YES];
        
        //将数据注入要发送的方法中，当回调成功后执行发送
        // [self excuteSend:values];
        //开启广播，选择要发送的设备
        [self browserForDevices];
        
    }
    
}
#pragma mark 实现广播
-(void)browserForDevices
{
    [[_appDelegate multipeer] setupBrowser];
    [[_appDelegate multipeer].browser setDelegate:self];
    
    [self presentViewController:[[_appDelegate multipeer] browser] animated:YES completion:nil];
    
    
}

#pragma mark 广播选择页面协议
-(void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController
{
    [self.appDelegate.multipeer.browser dismissViewControllerAnimated:YES completion:^{
        FirstViewController *vc = [[UIStoryboard storyboardWithName:@"ZhuYe" bundle:nil]instantiateViewControllerWithIdentifier:@"FirstViewController"];
        [self.navigationController pushViewController:vc animated:YES ];
        [self excuteSend:self.selectedFiles];
    }];
}
#pragma mark 异步执行发送数据
-(void) excuteSend:(NSMutableArray *) array

{
    NSLog(@"发送到数据数量:%d",array.count);
    for (int i=0; i<array.count; i++) {

        
        NSString *filePath=[array objectAtIndex:i];
        NSString *fileName=[filePath lastPathComponent];
        NSString *fileUrl=[NSURL fileURLWithPath:filePath];
//         NSURL *fileUrl=[NSURL fileURLWithPath:filePath];
//        NSData *fileUrlData=[[fileUrl absoluteString] dataUsingEncoding:NSUTF8StringEncoding];
//        //进行base64对url加密
//      NSString *fileUrlBase64=  [fileUrlData base64EncodedStringWithOptions:0];
//      fileUrl=  [NSURL URLWithString:fileUrlBase64];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSProgress *progress=[_appDelegate.multipeer.session sendResourceAtURL:fileUrl withName:fileName toPeer:[_appDelegate.multipeer.session connectedPeers][0] withCompletionHandler:^(NSError * _Nullable error) {
                if (error) {
                    NSLog(@"error is %@",[error localizedDescription]);
                }
                else{
                    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@发送成功",fileName] message:nil delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
                    [alertView performSelectorOnMainThread:@selector(show) withObject:nil     waitUntilDone:NO];
                    NSFileManager *fileManager=[NSFileManager defaultManager];
                    NSArray *files=[fileManager directoryContentsAtPath:_currentFilePath];
                    NSString *foderPath=nil;
                    for (NSString *foderName in files) {
                        if ([foderName isEqualToString:@"已发送"]) {
                            foderPath=[_currentFilePath stringByAppendingPathComponent:foderName];
                            foderPath=[foderPath stringByAppendingPathComponent:fileName];
                        }
                    };
                    
                  BOOL isCopy=  [fileManager copyItemAtPath:fileUrl toPath:foderPath error:nil];
                    NSLog(@"isCopy:%d",isCopy);
                    
                }
            }];
            [progress addObserver:self forKeyPath:@"fractionCompleted" options:NSKeyValueObservingOptionNew context:nil];
        });
    }
}
        //获取后缀名
//        NSString *extension = [fileName pathExtension];
//         NSArray *imageExtensions=@[@"jpg",@"png",@"jpeg",@"JPG",@"PNG",@"JPEG"];
//        if ([imageExtensions containsObject:extension]==YES) {
//            Files *file = [[Files alloc]init];
//            NSURL *url = file.imageUrl;
//            //异步发送
//            dispatch_async(dispatch_get_main_queue(), ^{
//                NSProgress *progress=[_appDelegate.multipeer.session sendResourceAtURL:url withName:fileName toPeer:[_appDelegate.multipeer.session connectedPeers][0] withCompletionHandler:^(NSError * _Nullable error) {
//                    if (error) {
//                        NSLog(@"error is %@",[error localizedDescription]);
//                    }
//                    else{
//                        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@发送成功",fileName] message:nil delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
//                        [alertView performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
//                    }
//                }];
//                [progress addObserver:self forKeyPath:@"fractionCompleted" options:NSKeyValueObservingOptionNew context:nil];
//            });
//        }
        
//        else{
        //异步发送
        
       
    
//}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    NSString *sendingMessage = [NSString stringWithFormat:@"- Sending %.f%%",
                                [(NSProgress *)object fractionCompleted] * 100
                                ];
    NSLog(@"文件发送进度:%@",sendingMessage);
    [_tableview performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
}
-(void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController
{
    [self.appDelegate.multipeer.browser dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 文件处理
-(void) getFileData:(Files *)file
{
    //获取后缀名
            NSString *extension = [file.fileName pathExtension];
    NSArray *imageExtensions=@[@"jpg",@"png",@"jpeg",@"JPG",@"PNG",@"JPEG"];
    //        if ([imageExtensions containsObject:extension]==YES)
    NSLog(@"filePath:%@\n",file.filePath);
    if ([imageExtensions containsObject:extension]==YES) {
//        UIImage *image=[[UIImage alloc]initWithContentsOfFile:file.filePath];
//        file.imageData=UIImageJPEGRepresentation(image, 1.0f);
        file.imageData ==nil;
    }
        else{
        NSFileHandle *readHandle=[NSFileHandle fileHandleForReadingAtPath:file.filePath];
        NSData *fileData=[readHandle readDataToEndOfFile];
        file.fileData=fileData;
        [readHandle closeFile];
    }
    
}

#pragma mark - 懒加载
-(NSMutableArray *)array
{
    if (_array == nil) {
        _array = [NSMutableArray array];
    }
    return _array;
}
-(NSMutableArray *)selectedRecipes
{
    if (_selectedRecipes ==nil) {
        _selectedRecipes = [NSMutableArray array];
    }
    return _selectedRecipes;
}

-(NSMutableArray *) files
{
    if (_files==nil) {
        NSMutableArray *arrray=[NSMutableArray array];
        _files=arrray;
    }
    return _files;
}
-(NSMutableArray *) selectedFiles
{
    if (_selectedFiles==nil) {
        _selectedFiles=[NSMutableArray array];
    }
    return _selectedFiles;
}
@end
