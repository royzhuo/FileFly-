//
//  history.h
//  FileFly
//
//  Created by jx on 16/5/22.
//  Copyright © 2016年 jx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface history : UIViewController
//@property(nonatomic,strong)NSString *historyForderPath;
+(instancetype)controller;
@property(strong,nonatomic)NSMutableArray *files;
+(void)getFilePathUrl:(NSString *)url;
@end
