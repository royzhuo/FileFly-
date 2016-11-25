//
//  ViewControllerByStory.m
//  智能社区
//
//  Created by Roy on 16/3/30.
//  Copyright © 2016年 Roy. All rights reserved.
//

#import "ViewControllerByStory.h"

@implementation ViewControllerByStory

+(id)initViewControllerWithStoryBoardName:(NSString *)storyName withViewId:(NSString *)identified
{
    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:storyName bundle:nil];
    UIViewController *view=[storyBoard instantiateViewControllerWithIdentifier:identified];
    return view;
}

@end
