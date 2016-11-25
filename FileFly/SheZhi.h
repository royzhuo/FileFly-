//
//  SheZhi.h
//  FileFly
//
//  Created by jx on 16/5/4.
//  Copyright © 2016年 jx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SheZhi : UIViewController
//头像按钮图片
@property (weak, nonatomic) IBOutlet UIButton *ImgBtn;
//用户名称
@property (weak, nonatomic) IBOutlet UILabel *Namelabel;
//表格
@property (strong, nonatomic) IBOutlet UITableView *table;

- (IBAction)switchAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *tuPian;


@property(nonatomic)BOOL *imageIsSave;
+(instancetype) controller;



@end
