//
//  LeftMenuController.h
//  FileFly
//
//  Created by jx on 16/4/25.
//  Copyright © 2016年 jx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ITRAirSideMenu.h"
@interface LeftMenuController : UIViewController<UITableViewDataSource,UITabBarDelegate,ITRAirSideMenuDelegate>
@property (strong, nonatomic) IBOutlet UIButton *imgBtn;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
+ (instancetype) controller;
@end
