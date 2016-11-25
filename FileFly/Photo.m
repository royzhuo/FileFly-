//
//  Photo.m
//  FileFly
//
//  Created by Roy on 16/6/6.
//  Copyright © 2016年 jx. All rights reserved.
//

#import "Photo.h"

@implementation Photo

-(instancetype)init
{
    self=  [super init];
    if (self) {
        self.imageManager=[[PHImageManager alloc]init];
        self.options=[[PHFetchOptions alloc]init];
    }
    return self;
}

-(void)getFecthResults
{
  PHFetchResult *result=  [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    
    self.fecthResult=result;

}

-(NSMutableArray *) getPHAsset:(PHFetchResult *)fetchResult
{
    NSMutableArray *array=[[NSMutableArray alloc]init];
    NSLog(@"class is:%@",[fetchResult class]);
    if ([fetchResult isKindOfClass:[PHAssetCollection class]]) {
        for (PHAsset *asset in fetchResult) {
            [self.imageManager requestImageForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeDefault options:self.options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                                NSLog(@"image:%@,info:%@",result,info);
                [array addObject:result];
            }];
        }
    }
    return array;
}

@end
