//
//  showImage.m
//  FileFly
//
//  Created by jx on 16/5/4.
//  Copyright © 2016年 jx. All rights reserved.
//

#import "showImage.h"
static CGRect oldframe;
@interface showImage ()

@end

@implementation showImage
+(void)ShowImage:(UIImageView
                  *)avatarImageView{
    
    UIImage
    *image=avatarImageView.image;
    
    UIWindow
    *window=[UIApplication sharedApplication].keyWindow;
    
    UIView
    *backgroundView=[[UIView alloc]initWithFrame:CGRectMake(0,
                                                            0,
                                                            [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    
    oldframe=[avatarImageView
              convertRect:avatarImageView.bounds toView:window];
    
    backgroundView.backgroundColor=[UIColor
                                    blackColor];
    
    backgroundView.alpha=0;
    
    UIImageView
    *imageView=[[UIImageView alloc]initWithFrame:oldframe];
    
    imageView.image=image;
    
    imageView.tag=1;
    
    [backgroundView
     addSubview:imageView];
    
    [window
     addSubview:backgroundView];
    
    
    
    UITapGestureRecognizer
    *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
    
    [backgroundView
     addGestureRecognizer: tap];
    
    
    
    [UIView
     animateWithDuration:0.3
     
     animations:^{
         
         imageView.frame=CGRectMake(0,([UIScreen
                                        mainScreen].bounds.size.height-image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width)/2,
                                    [UIScreen mainScreen].bounds.size.width, image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width);
         
         backgroundView.alpha=1;
         
     }
     completion:^(BOOL finished) {
         
         
         
     }];
    
}



+(void)hideImage:(UITapGestureRecognizer*)tap{
    
    UIView
    *backgroundView=tap.view;
    
    UIImageView
    *imageView=(UIImageView*)[tap.view viewWithTag:1];
    
    [UIView
     animateWithDuration:0.3
     
     animations:^{
         
         imageView.frame=oldframe;
         
         backgroundView.alpha=0;
         
     }
     completion:^(BOOL finished) {
         
         [backgroundView
          removeFromSuperview];
         
     }];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
