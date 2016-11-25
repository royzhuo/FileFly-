//
//  Files.m
//  FileFly
//
//  Created by Roy on 16/4/25.
//  Copyright © 2016年 Roy. All rights reserved.
//

#import "Files.h"

@implementation Files


+(Files *)FileWithFileName:(NSString *)fileName withImage:(NSString *)imageName withFilePath:(NSString *)path
{
    Files *file=[[Files alloc]init];
    file.fileName=fileName;
    file.imageName=imageName;
    file.filePath=path;
    return file;
}


-(NSString *)getFileImage:(NSString *) fileName
{
    //获取后缀名
    NSString *extension=[fileName pathExtension];
    //文件除了后缀名的文件名
    NSString *name=[fileName stringByDeletingPathExtension];
    NSArray *imageExtensions=@[@"jpg",@"png",@"jpeg",@"JPG",@"PNG",@"JPEG"];
    NSArray *yasuobaos=@[@"zip",@"rap"];
    NSArray *txtTypes=@[@"txt",@"java",@"plist"];
    NSArray *wordTypes=@[@"doc",@"docx"];
    if (![extension isEqualToString:@""]) {
        if ([imageExtensions containsObject:extension]==YES ) {
            return fileName;
        }else if ([wordTypes containsObject:extension]==YES){
            return @"word";
        }else if ([extension isEqualToString:@"excel"]){
            return @"excel";
        }else if ([extension isEqualToString:@"ppt"]){
            return @"ppt";
        }else if ([txtTypes containsObject:extension]==YES){
            return @"txt";
        }else if ([yasuobaos containsObject:extension]==YES){
            return @"zip-(2)";
        }else if ([extension isEqualToString:@"dmg"]){
            return @"app";
        }
        else{
            return @"txt";
        }
    }else return @"wenjian";
    
}

@end
