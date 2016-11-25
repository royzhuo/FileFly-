//
//  ViewTools.m
//  FileFly
//
//  Created by Roy on 16/5/11.
//  Copyright © 2016年 jx. All rights reserved.
//

#import "ViewTools.h"

@interface ViewTools()
{


}

@end





@implementation ViewTools

//-(NSArray *)getAlAssetBy:(ALAssetsGroup *)group
//{
//    NSMutableArray *array=[NSMutableArray array];
//    dispatch_queue_t gloabQueue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    //异步刷新
//dispatch_async(gloabQueue, ^{
//    [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
//        if ([result valueForProperty:ALAssetTypePhoto]) {
//            [array addObject:result];
//        }
//    }];
//});
//
//    return array;
//}






+(void)showAlertViewByTitle:(NSString *)titleName withMessage:(NSString *)message
{
    UIAlertView *aa=[[UIAlertView alloc]initWithTitle:titleName message:message delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
    [aa show];
    
}

@end


