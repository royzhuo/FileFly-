//
//  PreviewController.m
//  FileFly
//
//  Created by Roy on 16/5/4.
//  Copyright © 2016年 Roy. All rights reserved.
//

#import "PreviewController.h"


@interface PreviewController()<QLPreviewControllerDataSource,QLPreviewControllerDelegate>{
    QLPreviewController *previewController;

}

@end

@implementation PreviewController

-(void)viewDidLoad{

    self.navigationItem.title=@"界面预览";
    if (self.filePath != nil || self.imageUrl!=nil) {
        previewController=[[QLPreviewController alloc]init];
        CGRect frame=previewController.view.frame;
        frame=CGRectMake(0, 64, frame.size.width, frame.size.height);
        previewController.view.frame=frame;
        previewController.dataSource=self;
        previewController.delegate=self;
        [self.view addSubview: previewController.view];
        
        [previewController setCurrentPreviewItemIndex:0];
    }
    if (self.imageInfo !=nil) {
        UIImageView *imageview=[[UIImageView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64)];
        CGRect frame=imageview.frame;
        UIImage *image=[UIImage imageWithData:self.imageInfo];
        imageview.image=image;
        imageview.backgroundColor=[UIColor blackColor];
        [self.view addSubview:imageview];
    }
    
}

-(NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller
{
    return 1;
}
-(id<QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index
{
    
    if (self.filePath) {
        NSLog(@"aaaaa:%@\n %@",[self.filePath class],self.filePath);
        NSURL *fileUrl=[NSURL fileURLWithPath:self.filePath];
        return fileUrl;
    }else if (self.imageUrl){
        return self.imageUrl;
    }else{
        return nil;
    }
}

@end
