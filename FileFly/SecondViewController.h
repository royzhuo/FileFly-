//
//  SecondViewController.h
//  FileFly
//
//  Created by jx on 16/4/25.
//  Copyright © 2016年 jx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecondViewController : UIViewController<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate>
+(instancetype) controller;
@property(strong,nonatomic)UICollectionView *CollectionView;
@property(strong,nonatomic)NSMutableArray *array;
@end
