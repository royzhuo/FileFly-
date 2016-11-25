//
//  YHJTabPageScrollView.h
//  不同列表
//
//  Created by yhj on 16/1/12.
//  Copyright © 2016年 QQ:1787354782. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  Page Item for init YHJTabPageScrollView
 */
@interface YHJTabPageScrollViewPageItem : NSObject

@property (nonatomic,strong) NSString *tabName;

@property (nonatomic,strong) UIView *tabView;

-(instancetype)initWithTabName:(NSString*)tabName andTabView:(UIView*)tabView;

@end


@class YHJTabPageScrollView;

@protocol YHJTabPageScrollViewDelegate<NSObject>

@optional
-(void)YHJTabPageScrollView:(YHJTabPageScrollView*)tabPageScrollView
          decorateTabButton:(UIButton*)tabButton;

-(void)YHJTabPageScrollView:(YHJTabPageScrollView*)tabPageScrollView
        didPageItemSelected:(YHJTabPageScrollViewPageItem*)pageItem
               withTabIndex:(NSInteger)tabIndex;

@end

@interface YHJTabPageScrollViewParameter : NSObject

@property (nonatomic,assign) NSInteger tabHeight;

@property (nonatomic,strong) UIColor *indicatorColor;

@property (nonatomic,assign) NSInteger indicatorHeight;

@property (nonatomic,strong) UIColor *separatorColor;

@property (nonatomic,assign) NSInteger separatorHeight;

@property (nonatomic,assign) CGFloat indicatorWidthFactor;

@end


@interface YHJTabPageScrollView : UIView

@property (nonatomic,weak) id<YHJTabPageScrollViewDelegate> delegate;

/**
 *  init with Array of YHJTabPageScrollViewPageItem
 *
 *  @param pageItems Array of YHJTabPageScrollViewPageItem
 *
 *  @return new tab page scroll view
 */
-(instancetype)initWithPageItems:(NSArray *)pageItems;
-(instancetype)initWithPageItems:(NSArray *)pageItems withParameter:(YHJTabPageScrollViewParameter*)parameter;

@end
