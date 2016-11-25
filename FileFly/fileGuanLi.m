//
//  ViewController.m
//  FileFly
//
//  Created by Roy on 16/4/25.
//  Copyright © 2016年 Roy. All rights reserved.
//

#import "fileGuanLi.h"
#import "Files.h"
#import "PreviewController.h"
#import "TextViewController.h"

const NSString *identifier=@"collectionViewCell";


@interface fileGuanLi ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,TextViewDelegate>
{
    ALAssetsLibrary *alibrary;
    
    
    //判断页面是否是编辑状态
    BOOL isCollectionViewEditing;
    //判断是否进行复制操作
    BOOL isCopy;
    UIButton *selectBtn;
    UIButton *leftBtn;
    
    
    

}

//文件夹个数
@property(nonatomic,strong) NSMutableArray *foders;
//文件夹名称
@property(nonatomic,copy) NSString *foderName;
//文件名称
@property(nonatomic,copy) NSString *fileName;
//当前文件地址
@property(nonatomic,copy) NSString *currentPath;
//装配临时文件的集合
@property(nonatomic,copy) NSMutableArray *tempFilePaths;
//临时文件的地址
@property(nonatomic,copy) NSString *tempFilePath;
//临时地址
@property(nonatomic,copy) NSMutableArray  *tempPaths;
//图片url路径
@property(nonatomic,copy) NSMutableArray *tempPhotoUrls;
//缓存文件夹中图片文件
@property(nonatomic,copy) NSString *picFileName;


@end

@implementation fileGuanLi

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"文件编辑器";
    //collectionview背景颜色
    self.collectionView.backgroundColor=[UIColor whiteColor];
    //导航栏右边按钮
    selectBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
    [selectBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [selectBtn setTitle:@"确定" forState:UIControlStateSelected];
    [selectBtn addTarget:self action:@selector(selectBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBtn=[[UIBarButtonItem alloc]initWithCustomView:selectBtn];
    //导航栏返回按钮
    leftBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    [leftBtn setImage:[UIImage imageNamed:@"houtui_icon"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBtnItem=[[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    leftBtn.hidden=NO;
    
    self.navigationItem.rightBarButtonItem=rightBtn;
    self.navigationItem.leftBarButtonItem=leftBtnItem;
    
    self.toolView.hidden=YES;
    
    isCollectionViewEditing=NO;
    self.toolView.backgroundColor=RGB(18, 183, 245);
    isCopy=NO;
    
    //程序根目录
    //NSString *homePath=NSHomeDirectory();
    
    //获取document目录
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath=[paths lastObject];
    _currentPath=docPath;
    
    
    
    
    //创建相簿文件夹
//    NSString *forderName=@"相簿";
//    BOOL isExisit=[self isExsitForder:forderName withPath:_currentPath];
//    if(isExisit == NO) [self createForderByForderName:forderName withPath:_currentPath];
//    [self createForderByForderName:forderName withPath:_currentPath];
    //获取Library目录
//    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
//    NSString *librayPath=[paths lastObject];
    
    //获取Library中的Cache
//    NSArray *path=NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
//    NSString *cachePath=[path lastObject];
    [self getFoderName:docPath];
    
    
    
   // [self createFileInCache];
    
}


#pragma mark collectionview协议
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    //判断返回按钮是否隐藏
    [self isHiddenLeftBtn];
    return self.foders.count;
}


//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

    //static NSString *identified=@"collectionViewCell";
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    if (!cell) {
        
    }
    
   // NSLog(@"对象是否是file:%@",[self.foders[indexPath.row] class]);
     Files *file=[self.foders objectAtIndex:indexPath.row];
    if (file.fileName!=nil && file.thorImageData==nil) {
        //Files *file=[self.foders objectAtIndex:indexPath.row];
        file.imageName=[file getFileImage:file.fileName];
        UIImageView *imageView=[cell viewWithTag:1000];
        if ([file.fileName isEqualToString:file.imageName]){
            
            imageView.image=[self generatePhotoThumbnail:[UIImage imageNamed:file.filePath]];
            //imageView.contentMode=UIViewContentModeScaleAspectFit;
            UILabel *label=[cell viewWithTag:2000];
            label.text=file.fileName;
            label.numberOfLines=1;
        }else{
            imageView.image=[UIImage imageNamed:file.imageName];;imageView.image=[UIImage imageNamed:file.imageName];
            UILabel *label=[cell viewWithTag:2000];
            label.text=file.fileName;
            label.numberOfLines=0;
        }
        
        
        
    }else if (file.fileName==nil&&file.thorImageData!=nil){
//        ALAsset *{alasset=self.foders[indexPath.row];
//        NSString *type=[alasset valueForProperty:ALAssetPropertyType];
//        if ([type isEqualToString:ALAssetTypePhoto]) {
//            NSLog(@"照片");
//        }
//        CGImageRef *cif=  [alasset thumbnail];
//        UIImage *imag=[UIImage imageWithCGImage:cif];
        
        UIImageView *imageview=[cell viewWithTag:1000];
       // Files *file=self.foders[indexPath.row];
        imageview.image=[UIImage imageWithData:file.thorImageData];
        UILabel *label=[cell viewWithTag:2000];
        label.text=@"aaaa.jpg";
//
//        
//        NSString *imagePath=[pics[indexPath.row] base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
//       if(pics != nil) label.text=imagePath;
       // NSArray photoUrl=[]
        //NSURL *url=alasset.defaultRepresentation.url;
        //NSString *url=[[[alasset defaultRepresentation] url]description];
        //label.text=_tempPhotoUrls[indexPath.row];

    }
    //打勾
    UIImageView *dagouView=[cell viewWithTag:3000];
    CGRect frame=dagouView.frame;
    dagouView.hidden=YES;
    
    
    return cell;
}



//定义每个UICollectionView 的大小
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return CGSizeMake(70, 100);
//}

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    UICollectionViewCell *cell=[collectionView cellForItemAtIndexPath:indexPath];
    UIImageView *imageView=[cell viewWithTag:1000];
    UILabel *label=[cell viewWithTag:2000];
    NSLog(@"class is %@",[_foders[indexPath.row] class]);
    //Files *file=_foders[indexPath.row];
    NSLog(@"fileName:%@",label.text);
    NSString *fileName=label.text;
    if (isCollectionViewEditing==YES && isCopy==NO) {
        //打勾view
        UIImageView *dagouView=[cell viewWithTag:3000];
        if(dagouView.hidden==YES) {
            dagouView.hidden=NO;
            if([_foders[indexPath.row] class]==[Files class]) [self.tempFilePaths addObject:_foders[indexPath.row]];
            
        }
        else if(dagouView.hidden==NO) {
            dagouView.hidden=YES;
            if([_foders[indexPath.row] class]==[Files class]) [self.tempFilePaths removeObject:_foders[indexPath.row]];
            
        }
        
        
    }else if (isCollectionViewEditing==NO || isCopy==YES){
        if ([[fileName pathExtension] isEqualToString:@""]||[[fileName pathExtension] isEqualToString:@"FileFly"]) {
            //打开目录
            _currentPath=[_currentPath stringByAppendingPathComponent:fileName];//file.filePath;
            [self getFoderName:_currentPath];
        }else{
            Files *file=_foders[indexPath.row];
            //读取文件
            if (file.fileName!=nil && file.thorImageData == nil) {
               NSString *fullFileName= [_currentPath stringByAppendingPathComponent:label.text];
                [self readFile:fullFileName withImageData:nil];
            }
            if (file.fileName == nil && file.thorImageData != nil) {
                [self readFile:nil withImageData:file.originData];
            }
                
            
        }
    }
    
    

}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"是否可编辑");
    return YES;
}

//设置元素的边框大小
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    UIEdgeInsets top = {10,5,1,5};  //{10,8,1,5};
    return top;
}

-(void)getTextViewContent:(NSString *)content withTitle:(NSString *)titleName
{
    NSFileHandle *outFile;
    //NSString *fileName=[NSString stringWithFormat:@"%@.txt",titleName];
    NSString *fullFileName=[_currentPath stringByAppendingPathComponent:titleName];
    
    outFile=[NSFileHandle fileHandleForWritingAtPath:fullFileName];
    NSData *contenData=[content dataUsingEncoding:NSUTF8StringEncoding];
    [outFile writeData:contenData];
    
    [outFile closeFile];

}
#pragma mark 获取图片缩略图
-(UIImage *)generatePhotoThumbnail:(UIImage *)image {
    // Create a thumbnail version of the image for the event object.
    CGSize size = image.size;
    CGSize croppedSize;
    CGFloat ratioX = 70.0;
    CGFloat ratioY = 70.0;
    CGFloat offsetX = 0.0;
    CGFloat offsetY = 0.0;
    
    // check the size of the image, we want to make it
    // a square with sides the size of the smallest dimension
    if (size.width > size.height) {
        offsetX = (size.height - size.width) / 2;
        croppedSize = CGSizeMake(size.height, size.height);
    } else {
        offsetY = (size.width - size.height) / 2;
        croppedSize = CGSizeMake(size.width, size.width);
    }
    
    // Crop the image before resize
    CGRect clippedRect = CGRectMake(offsetX * -1, offsetY * -1, croppedSize.width, croppedSize.height);
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], clippedRect);
    // Done cropping
    // Resize the image
    CGRect rect = CGRectMake(0.0, 0.0, ratioX, ratioY); // 设置图片缩微图的区域（（0，0），宽：75  高：60）
    UIGraphicsBeginImageContext(rect.size);
    [[UIImage imageWithCGImage:imageRef] drawInRect:rect];
    UIImage *thumbnail = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    // Done Resizing
    return thumbnail;
}
#pragma mark 懒加载
-(NSArray *)foders{
    if (_foders==nil) {
        _foders=[NSMutableArray array];
    }
    return _foders;
}
-(NSArray *) tempFilePaths{
    if (_tempFilePaths==nil) {
        NSMutableArray *array=[NSMutableArray array];
        _tempFilePaths=array;
    }
    return _tempFilePaths;
}
-(NSArray *) tempPaths{
    if (_tempPaths==nil) {
        NSMutableArray *array=[NSMutableArray array];
        _tempPaths=array;
    }
    return _tempPaths;
}
-(NSArray *) tempPhotoUrls
{
    if (_tempPhotoUrls==nil) {
        _tempPhotoUrls=[NSMutableArray array];
    }
    return _tempPhotoUrls;
}


#pragma mark 获取文件夹url
-(void)getFoderName:(NSString *)foderPath
{
    
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath=[paths lastObject];
    //if (![docPath isEqualToString:foderPath]) leftBtn.hidden=NO;
    NSFileManager *fileManager=[NSFileManager defaultManager];
    NSArray *files= [fileManager directoryContentsAtPath:foderPath];
    [self.foders removeAllObjects];
    
    if ([foderPath.lastPathComponent isEqualToString:@"相簿"]) {

        dispatch_queue_t queue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            //创建相簿库
            alibrary=[[ALAssetsLibrary alloc]init];
            //遍历相簿库内的所有文件夹
            [alibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                //异步下载图片
                if (group) {
dispatch_async(queue, ^{
    
        NSLog(@"group:%@\n",group);
        [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            if ([result valueForProperty:ALAssetTypePhoto]) {
                Files *file=[[Files alloc]init];
                //缩略图
                UIImage *thumbnailImage=[UIImage imageWithCGImage:result.thumbnail];
                file.thorImageData=UIImagePNGRepresentation(thumbnailImage);
                //原图
                UIImage *originImage=[UIImage imageWithCGImage:
                                      result.defaultRepresentation.fullScreenImage];
                file.originData=UIImagePNGRepresentation(originImage);
                [self.tempPhotoUrls addObject:file.originData];
                [self.foders addObject:file];
                [self downLoadImage];
           }
            
            
        }];
   
});
    }
            } failureBlock:^(NSError *error) {
                NSLog(@"相片获取失败");
            }];
            

        
        
        /*
         
         if (group) {
         NSLog(@"group:%@\n",group);
         //遍历文件夹中的资源
         [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
         //index表示它的位置
         //判断资源类型
         if ([result valueForProperty:ALAssetTypePhoto]) {
         
         //                                [self.foders addObject:result];
         //                                [self.tempPhotoUrls addObject:[result defaultRepresentation].url.absoluteString];
         
         Files *file=[[Files alloc]init];
         
         //缩略图
         UIImage *thumbnailImage=[UIImage imageWithCGImage:result.thumbnail];
         file.thorImageData=UIImagePNGRepresentation(thumbnailImage);
         //原图
         UIImage *originImage=[UIImage imageWithCGImage:
         result.defaultRepresentation.fullScreenImage];
         file.originData=UIImagePNGRepresentation(originImage);
         [self.foders addObject:file];
         
         }
         [self.collectionView reloadData];
         
         }];
         
         }
         */

   
    }else{
    for (NSString *forderName in files) {
        NSString *fullName=[foderPath stringByAppendingString:[NSString stringWithFormat:@"/%@",forderName]];
        Files *file=[Files FileWithFileName:forderName withImage:nil withFilePath:fullName];
        [self.foders addObject:file];
    }
        [self.collectionView reloadData];
    }
    
    
    
    
}

#pragma mark 加载相簿
-(void) downLoadImage{
dispatch_sync(dispatch_get_main_queue(), ^{
    [self.collectionView reloadData];
    
//   BOOL isSuccess= [self.tempPhotoUrls writeToFile:self.picFileName atomically:YES];
//    if(isSuccess==YES) NSLog(@"文件写入成功");
//    else NSLog(@"文件写入失败");
});
}


#pragma mark 设置文件图片
-(NSString *)getFileImage:(NSString *) fileName
{
    NSString *extension=[fileName pathExtension];
    NSArray *imageExtensions=@[@"jpg",@"png",@"jpeg"];
    NSArray *yasuobaos=@[@"zip",@"rap"];
    NSArray *txtTypes=@[@"txt",@"java",@"plist"];
    NSArray *wordTypes=@[@"doc",@"docx"];
    if (![extension isEqualToString:@""]) {
        if ([imageExtensions containsObject:extension]==YES ) {
            return fileName;
        }else if ([wordTypes containsObject:extension]==YES){
            return @"word";
        }else if ([extension isEqualToString:@"excel"]){
            return @"excel";
        }else if ([extension isEqualToString:@"ppt"]){
            return @"ppt";
        }else if ([txtTypes containsObject:extension]==YES){
            return @"txt";
        }else if ([yasuobaos containsObject:extension]==YES){
            return @"2";
        }else{
            return @"wenjian";
        }
    }else return @"wenjian";

}

#pragma mark 按钮编辑
-(void) selectBtnAction:(UIButton *) button
{
    button.selected=!button.selected;
    if (button.selected==YES) {
        [button setTitle:@"确定" forState:UIControlStateNormal];
        [UIView animateWithDuration:0.5f animations:^{
            self.toolView.alpha=0;
            self.toolView.frame=CGRectMake(0, self.view.frame.size.height, self.toolView.frame.size.width, self.toolView.frame.size.height);
        } completion:^(BOOL finished) {
            isCollectionViewEditing=YES;
             self.toolView.hidden=NO;
            self.toolView.alpha=1;
            self.toolView.frame=CGRectMake(0, self.view.frame.size.height-self.toolView.frame.size.height, self.toolView.frame.size.width, self.toolView.frame.size.height);
           
        }];
        
        
    }else{
        [button setTitle:@"编辑" forState:UIControlStateNormal];
        self.toolView.hidden=YES;
        isCollectionViewEditing=NO;
        [self.collectionView reloadData];
    }

}

#pragma mark 功能菜单功能


- (IBAction)reName:(id)sender {
    NSFileManager *fm=[NSFileManager defaultManager];
    NSLog(@"当前路径:%@",_currentPath);
    if (self.tempFilePaths.count==0) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"信息" message:@"请选择文件" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"好的", nil];
        [alert show];
        return ;
    }
    Files *file;
    for (int i=0; i<_tempFilePaths.count; i++) {
        if ([_tempFilePaths[i] class]==[Files class]) {
            file=_tempFilePaths[i];
        }
    }
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"文件名" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *confirmAction=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *newFileName=[NSString stringWithFormat:@"%@",self.fileName];
        NSString *newFilePath=[_currentPath stringByAppendingPathComponent:newFileName];
        BOOL isReName= [fm moveItemAtPath:file.filePath toPath:newFilePath error:nil];
        if (isReName==YES) {
            [self getFoderName:_currentPath];
        }
    }];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        NSString *name=[file.fileName stringByDeletingPathExtension];
        textField.text=name;
        [textField addTarget:self action:@selector(getNewName:) forControlEvents:UIControlEventEditingChanged];
    }];
    [alert addAction:cancelAction];
    [alert addAction:confirmAction];
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (IBAction)deleteAll:(id)sender {
    NSFileManager *fileManager=[NSFileManager defaultManager];
    
    UIAlertController *alertViewController=[UIAlertController alertControllerWithTitle:@"确定删除？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *yesAction=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"当前路径:%@",_currentPath);
        for  (Files *file in _foders) {
            if([file.fileName isEqualToString:@"历史"]|| [file.fileName isEqualToString:@"已接收"]|| [file.fileName isEqualToString:@"已发送"]){
                continue;
            }
            BOOL isRemove= [fileManager removeItemAtPath:file.filePath error:nil];
            if (isRemove==NO) {
                NSLog(@"删除失败");
            }
        }
        
        [self getFoderName:_currentPath];

    }];
    
    UIAlertAction *noAction=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alertViewController addAction:yesAction];
    [alertViewController addAction:noAction];
    
    
    [self presentViewController:alertViewController animated:YES completion:nil];
    
    
    
   }

//新建文件
- (IBAction)createFile:(id)sender {
//    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"新建文件" message:@"aaa" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//    [alertView show];
    
    UIAlertController *alertController=[UIAlertController alertControllerWithTitle:@"新建文件" message:@"写入文件名" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *conFirmAction=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
        [self createFileByFileName:_fileName];
        
        
    }];
    conFirmAction.enabled=NO;
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder=@"填写文件名";
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alertTextFieldDidChange:) name:UITextFieldTextDidChangeNotification  object:textField];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:conFirmAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
}
//新建文件夹
- (IBAction)createForder:(id)sender {
    UIAlertController *alertController=[UIAlertController alertControllerWithTitle:@"新建文件夹" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *conFirmAction=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
        //获取document路径
        NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docPath=[paths lastObject];
        if ([_currentPath isEqualToString:docPath]&& [self isExsitForder:_foderName withPath:_currentPath]==YES) {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"信息" message:@"文件夹重名" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"好的", nil];
            [alert show];
        }else [self createForderByForderName:_foderName withPath:_currentPath];
        
        
    }];
    conFirmAction.enabled=NO;
    //按钮
    [alertController addAction:cancelAction];
    [alertController addAction:conFirmAction];
    //文本
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder=@"请输入文件夹名称";
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alertTextFieldDidChange:) name:UITextFieldTextDidChangeNotification object:textField];
    }];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

- (IBAction)deleteFile:(id)sender {
    NSFileManager *fm=[NSFileManager defaultManager];
    NSLog(@"当前路径:%@",_currentPath);
    NSError *error;
    if(_tempFilePaths.count==0){
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"信息" message:@"请选择文件" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"好的", nil];
        [alert show];
        return ;
    }
    for (int i=0; i<_tempFilePaths.count; i++) {
        if ([Files class]== [_tempFilePaths[i] class]) {
            Files *file=_tempFilePaths[i];
            [fm removeItemAtPath:file.filePath error:&error];
            [_foders removeObject:file];
            
        }
    }
    [_tempFilePaths removeAllObjects];
    [self.collectionView reloadData];
    
}

- (IBAction)moreMenus:(id)sender {
}

- (IBAction)copyFile:(id)sender {
    UIButton *button=(UIButton *)sender;
    NSFileManager *fm=[NSFileManager defaultManager];
    NSLog(@"当前路径:%@",_currentPath);
        if (isCopy==NO) {
            if (self.tempFilePaths.count==0) {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"信息内容" message:@"请选择文件" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"好的", nil];
                [alert show];
                return;
            }

        for (int i=0; i<_tempFilePaths.count; i++) {
            if ([Files class]==[_tempFilePaths[i] class]) {
                Files *file=_tempFilePaths[i];
                [self.tempPaths addObject:file.filePath];
            }
        }
            [self copyFile:button withPath:nil];
        [_tempFilePaths removeAllObjects];
    }else if (isCopy==YES){
        if(self.tempPaths.count == 0) return;
        for (NSString *path in self.tempPaths) {
            NSString *fileName=[path lastPathComponent];
            NSString *finalPath=[_currentPath stringByAppendingPathComponent:fileName];
            [fm copyItemAtPath:path toPath:finalPath error:nil];
        }
        [self.tempPaths removeAllObjects];
        [button setTitle:@"复制" forState:UIControlStateNormal];
        isCopy=NO;
        [self getFoderName:_currentPath];
        
        
    }
    
    
}

-(void)copyFile:(UIButton *) btn withPath:(NSString *)path
{
    btn.selected=!btn.selected;
    if (btn.selected==YES) {
        [btn setTitle:@"粘贴" forState:UIControlStateNormal];
        isCopy=YES;
        //_tempFilePath=path;
    }else if (btn.selected==NO){
        [btn setTitle:@"复制" forState:UIControlStateNormal];
        isCopy=NO;
    }
}

- (IBAction)moveFile:(id)sender {
}

//激活确定按钮
-(void)alertTextFieldDidChange:(NSNotification *) nsNotification
{

    UIAlertController *alertController=(UIAlertController *)self.presentedViewController;
    if (alertController) {
        UITextField *forderField=alertController.textFields.firstObject;
        UIAlertAction *okAction=alertController.actions.lastObject;
        okAction.enabled=forderField.text.length>0;
        if(okAction.enabled==YES) {
            if ([alertController.title isEqualToString:@"新建文件夹"]) _foderName=forderField.text;
            else _fileName=forderField.text;
        }
    }

}

//创建文件夹
-(void) createForderByForderName:(NSString *)forderName withPath:(NSString *) path
{
    NSLog(@"name:%@",forderName);
    NSFileManager *fm=[NSFileManager defaultManager];
    
    NSData *foderData=[forderName dataUsingEncoding:NSUTF8StringEncoding];
    NSString *forderPath=[path stringByAppendingPathComponent:forderName];
    //创建文件夹
    BOOL isCreate=[fm createDirectoryAtPath:forderPath attributes:nil];
    if (isCreate==NO) {
            NSLog(@"文件创建失败");
    }else{
       
        [self getFoderName:path];
    }
    
}

//新建文件
-(void) createFileByFileName:(NSString *) fileName
{
    NSString *newFileName=[NSString stringWithFormat:@"%@.txt",fileName];
    NSFileManager *fileManager=[NSFileManager defaultManager];
    for (int i=0; i<self.foders.count; i++) {
        Files *file=self.foders[i];
        if ([newFileName isEqualToString:file.fileName]) {
            newFileName=[NSString stringWithFormat:@"%@(%d).txt",fileName,i+1];
        }
    }
    
    NSString *path=[_currentPath stringByAppendingPathComponent:newFileName];
    
   BOOL isSuccess= [fileManager createFileAtPath:path contents:nil attributes:nil];
    if (isSuccess==YES) {
        TextViewController *textViewController=[ViewControllerByStory initViewControllerWithStoryBoardName:@"guanLi" withViewId:@"textView"];
        textViewController.titleName=newFileName;
        textViewController.delegate=self;
        [self.navigationController presentViewController:textViewController animated:YES completion:nil];
        //再次读取当前路径
        [self getFoderName:_currentPath];
        _toolView.hidden=YES;
        isCollectionViewEditing=NO;
        [selectBtn setTitle:@"编辑" forState:UIControlStateNormal];
        NSLog(@"button Name:%@",selectBtn.titleLabel.text);
        [self selectBtnAction:selectBtn];
        NSLog(@"button Name:%@",selectBtn.titleLabel.text);
        [self.toolView setHidden:YES];
    }
    

}

//在缓存文件夹中创建文件
-(void) createFileInCache
{
    NSFileManager *fm=[NSFileManager defaultManager];
        NSArray *path=NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *cachePath=[path lastObject];
    self.picFileName=@"pic.plist";
    _picFileName=[cachePath stringByAppendingPathComponent:_picFileName];
    
    BOOL isExsite=[fm fileExistsAtPath:_picFileName];
    if (isExsite==NO) {
        BOOL isSuccess=[fm createFileAtPath:_picFileName contents:nil attributes:nil];
        if (isSuccess==YES) {
            NSLog(@"图片文件创建成功");
        }else NSLog(@"图片文件创建失败");
    }else NSLog(@"文件已存在");
    
    

}

//读取文件
-(void)readFile:(NSString *)fullFileName withImageData:(NSData *)imageData
{
//    NSFileHandle *inFile,*outFile;
//    //输入流
//    inFile=[NSFileHandle fileHandleForReadingAtPath:fullFileName];
//    if (inFile==nil) {
//        NSLog(@"文件读取失败");
//    }else{
//    //写入数据
//        outFile=[NSFileHandle fileHandleForWritingAtPath:fullFileName];
//        NSString *content=@"zheng yang tao sha bi a";
//        NSData *data=[content dataUsingEncoding:NSUTF8StringEncoding];
//        [outFile writeData:data];
//        
//        //读取数据
//      NSData *readData=  [inFile readDataToEndOfFile];
//        NSString *readString=[[NSString alloc]initWithData:readData encoding:NSUTF8StringEncoding];
//        NSLog(@"文件数据:%@",readString);
//    
//    }
//    [outFile closeFile];
//    [inFile closeFile];
    
   // _fileName=[_currentPath stringByAppendingPathComponent:fullFileName];
    
   // NSLog(@"当前路径 is :%@",_fileName);
    PreviewController *p=[[UIStoryboard storyboardWithName:@"guanLi" bundle:nil] instantiateViewControllerWithIdentifier:@"preView"];
    p.filePath=fullFileName;
    p.imageInfo=imageData;
    
    [self.navigationController pushViewController:p animated:YES];
}


//是否存在相同的文件夹
-(BOOL) isExsitForder:(NSString *)forderName withPath:(NSString *)path
{
    NSFileManager *fm=[NSFileManager defaultManager];
    NSString *fulDirectory=[path stringByAppendingPathComponent:forderName];
    BOOL isDir=YES;
    return [fm fileExistsAtPath:fulDirectory isDirectory:&isDir];
}

//菜单返回上一级目录
-(void)back:(UIButton *) button
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath=[paths lastObject];

    if([_currentPath isEqualToString:docPath]) [self dismissViewControllerAnimated:YES completion:nil];
    else{
        //获取上一级路径
        NSString *tmpUrl=[_currentPath stringByDeletingLastPathComponent];
        _currentPath=tmpUrl;
        [self getFoderName:tmpUrl];
    }

}

//获取新文件名
-(void)getNewName:(UITextField *)textField
{
    //NSLog(@"textFile is %@",textField.text);
    self.fileName=textField.text;
}
-(void)isHiddenLeftBtn
{
//    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *docPath=[paths lastObject];
//    if([_currentPath isEqualToString:docPath]) leftBtn.hidden=YES;
//    else leftBtn.hidden=NO;
}


@end
