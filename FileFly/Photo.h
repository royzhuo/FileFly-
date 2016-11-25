//
//  Photo.h
//  FileFly
//
//  Created by Roy on 16/6/6.
//  Copyright © 2016年 jx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@interface Photo : NSObject

@property(nonatomic,strong) NSURL *photoUrl;
@property(nonatomic,strong) NSString *photoName;
@property(nonatomic,strong) PHFetchResult *fecthResult;
@property(nonatomic,strong) PHAsset *asset;
@property(nonatomic,strong) PHImageManager *imageManager;
@property(nonatomic,strong) PHFetchOptions *options;


-(void) getFecthResults;
-(NSMutableArray *) getPHAsset:(PHFetchResult *) fetchResult;



@end
