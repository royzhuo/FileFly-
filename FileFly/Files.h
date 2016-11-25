//
//  Files.h
//  FileFly
//
//  Created by Roy on 16/4/25.
//  Copyright © 2016年 Roy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface Files : NSObject

@property(nonatomic,copy) NSString *fileName;
@property(nonatomic,copy) NSString *filePath;
@property(nonatomic,assign) NSString *imageName;
@property(nonatomic,copy) NSData *thorImageData;
@property(nonatomic,copy) NSData *originData;
@property(nonatomic,copy) NSData *imageData;
@property(nonatomic,copy) NSData *fileData;
@property(nonatomic)BOOL fileState;
@property(nonatomic,copy)NSURL *imageUrl;
@property(nonatomic,strong) PHFetchResult *allFetchResults;
@property(nonatomic,assign) int flag;
+(Files *) FileWithFileName:(NSString *)fileName withImage:(NSString *)imageName withFilePath:(NSString *)path;

-(NSString *)getFileImage:(NSString *) fileName;
@end
