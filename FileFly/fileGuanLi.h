//
//  ViewController.h
//  FileFly
//
//  Created by Roy on 16/4/25.
//  Copyright © 2016年 Roy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <QuickLook/QuickLook.h>

@interface fileGuanLi : UIViewController

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;


@property (weak, nonatomic) IBOutlet UIView *toolView;


- (IBAction)reName:(id)sender;


- (IBAction)deleteAll:(id)sender;

- (IBAction)createFile:(id)sender;

- (IBAction)createForder:(id)sender;

- (IBAction)deleteFile:(id)sender;

//- (IBAction)moreMenus:(id)sender;

- (IBAction)copyFile:(id)sender;

//- (IBAction)moveFile:(id)sender;


@property (weak, nonatomic) IBOutlet UIButton *createFileBtn;

@property (weak, nonatomic) IBOutlet UIButton *createForderBtn;

@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;




@end

