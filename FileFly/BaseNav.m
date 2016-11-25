//
//  BaseNav.m
//  MeiPei
//
//  Created by quanwei.wang on 15/5/24.
//  Copyright (c) 2015年 haiyan. All rights reserved.
//

#import "BaseNav.h"

@implementation BaseNav

-(void)viewDidLoad{
    
    [super viewDidLoad];
    
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars=NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationBar.translucent = NO;
    
}

- (void) pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    if(![viewController isKindOfClass:[UITabBarController class]])
    {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}


@end
