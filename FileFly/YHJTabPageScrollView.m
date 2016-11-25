//
//  YHJTabPageScrollView.m
//  不同列表
//
//  Created by yhj on 16/1/12.
//  Copyright © 2016年 QQ:1787354782. All rights reserved.
//

#import "YHJTabPageScrollView.h"
#import "Masonry.h"

#define APPW [UIScreen mainScreen].bounds.size.width
#define APPH [UIScreen mainScreen].bounds.size.height

#define SCREEN_WIDTH                    ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT                   ([UIScreen mainScreen].bounds.size.height)

#define UIColorFromRGB(rgbValue)        [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0f green:((float)((rgbValue & 0xFF00) >> 8))/255.0f blue:((float)(rgbValue & 0xFF))/255.0f alpha:1.0f]
#define UIColorWithRGBA(r,g,b,a)        [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

@implementation YHJTabPageScrollViewPageItem

-(instancetype)initWithTabName:(NSString *)tabName andTabView:(UIView *)tabView{
    self = [super init];
    if(self){
        _tabName = tabName;
        _tabView = tabView;
    }
    return self;
}
@end

@implementation YHJTabPageScrollViewParameter

- (instancetype)init
{
    self = [super init];
    if (self) {
        _tabHeight = 50;
        // 滑块的颜色
        _indicatorColor=RGB(18, 183, 245);
        _indicatorHeight = 2;
        // 下面长线的颜色
        _separatorColor=[UIColor grayColor];
        _separatorHeight = 1;
        _indicatorWidthFactor = 2.0/3.0;
    }
    return self;
}
@end


@interface YHJTabPageScrollView ()<UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView *contentView;

@property (nonatomic,strong) NSArray *pageItems;

@property (nonatomic,strong) NSMutableArray *tabButtons;

@property (nonatomic,strong) UIView *indicatorView;

@property (nonatomic,strong) UIView *separatorView;

@property (nonatomic,strong)YHJTabPageScrollViewParameter *parameter;

@end

@implementation YHJTabPageScrollView

- (instancetype)initWithPageItems:(NSArray *)pageItems withParameter:(YHJTabPageScrollViewParameter *)parameter{
    self = [super init];
    if(self){
        if(parameter == nil){
            _parameter = [YHJTabPageScrollViewParameter new];
        }else{
            self.parameter = parameter;
        }
        _tabButtons = [NSMutableArray new];
        _pageItems = pageItems;
        [self loadUI];
    }
    return self;
}

- (instancetype)initWithPageItems:(NSArray *)pageItems{
    return [self initWithPageItems:pageItems withParameter:nil];
}

-(void)loadUI{
    UIView *rootView = self;
    // Load tabs
    UIView *tabView = [UIView new];
    [rootView addSubview:tabView];
    [tabView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(rootView.mas_left);
        make.top.equalTo(rootView.mas_top);
        make.right.equalTo(rootView.mas_right);
        make.height.equalTo(@50);
    }];
    
    [self subloadTabView:tabView];
    
    // Load content
    _contentView = [UIScrollView new];
    [rootView addSubview:_contentView];
    _contentView.pagingEnabled = YES;
    _contentView.showsVerticalScrollIndicator = NO;
    _contentView.showsHorizontalScrollIndicator = NO;
    _contentView.delegate = self;
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(rootView.mas_left);
        make.right.equalTo(rootView.mas_right);
        make.bottom.equalTo(rootView.mas_bottom);
        make.top.equalTo(tabView.mas_bottom);
    }];
    
    [self subloadContentView];
}

-(void)subloadTabView:(UIView*)tabView{
    // Load tab buttons
    [_pageItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL * stop) {
        YHJTabPageScrollViewPageItem *item = obj;
        
        UIButton *button = [UIButton new];
        [tabView addSubview:button];
        [_tabButtons addObject:button];
        
        [button setTitle:item.tabName forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:RGB(18, 183, 245) forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont systemFontOfSize:18];
        
        if(_delegate && [_delegate respondsToSelector:@selector(YHJTabPageScrollView:decorateTabButton:)]){
            [_delegate YHJTabPageScrollView:self decorateTabButton:button];
        }
        
        [button addTarget:self action:@selector(tabButtonTouchup:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = idx;
        
        [button mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(tabView.mas_top);
            make.height.equalTo(@(_parameter.tabHeight - _parameter.indicatorHeight - _parameter.separatorHeight)); // 1 for line , 2 for indicator
            
            if(idx == 0){
                // first item
                make.left.equalTo(tabView.mas_left);
            }else if(idx == _pageItems.count - 1){
                // last item
                make.right.equalTo(tabView.mas_right);
            }
            
            if(idx > 0){
                // except for the first item
                UIButton *leftButton = (UIButton*)_tabButtons[idx - 1];
                make.left.equalTo(leftButton.mas_right);
                
                // same width
                make.width.equalTo(leftButton.mas_width);
            }
        }];
    }];
    
    // Load separator
    _separatorView = [UIView new];
    [tabView addSubview:_separatorView];
    _separatorView.backgroundColor = _parameter.separatorColor;
    [_separatorView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(tabView.mas_left);
        make.right.equalTo(tabView.mas_right);
        make.height.equalTo(@(_parameter.separatorHeight));
        make.bottom.equalTo(tabView.mas_bottom);
    }];
    
    // Load indicator
    UIButton *firstButton = (UIButton*)_tabButtons[0]; // default
    firstButton.selected = YES;
    
    _indicatorView = [UIView new];
    [tabView addSubview:_indicatorView];
    _indicatorView.backgroundColor = _parameter.indicatorColor;
    [_indicatorView mas_makeConstraints:^(MASConstraintMaker *make){
        make.width.equalTo(@(SCREEN_WIDTH / _pageItems.count * _parameter.indicatorWidthFactor));
        make.bottom.equalTo(_separatorView.mas_top).offset(-5);
        make.height.equalTo(@(_parameter.indicatorHeight));
        make.centerX.equalTo(firstButton.mas_centerX);
    }];
    
}
-(void)subloadContentView{
    
    UIView *rootView = _contentView;
    
    __block UIView *leftPageView = nil;
    [_pageItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL * stop) {
        YHJTabPageScrollViewPageItem *item = obj;
        
        UIView *pageView = [UIView new];
        [rootView addSubview:pageView];
        [pageView mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(rootView.mas_bottom);
            make.width.equalTo(rootView.mas_width);
            make.height.equalTo(rootView.mas_height);
            
            if(idx == 0){
                make.left.equalTo(rootView.mas_left);
            }else if(idx == _pageItems.count - 1){
                make.right.equalTo(rootView.mas_right);
            }
            if(idx > 0){
                make.left.equalTo(leftPageView.mas_right);
            }
        }];
        
        [pageView addSubview:item.tabView];
        [item.tabView mas_makeConstraints:^(MASConstraintMaker *make){
            make.edges.equalTo(pageView);
        }];
        
        leftPageView = pageView;
    }];
}

-(void)tabButtonTouchup:(id)sender{
    UIButton *button = sender;
    NSUInteger index = button.tag;
    [_contentView setContentOffset:CGPointMake(index * SCREEN_WIDTH, 0) animated:YES];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat width = scrollView.frame.size.width;
    int tabIndex = (scrollView.contentOffset.x + (0.5f * width)) / width;
    
    for(UIButton *button in _tabButtons){
        button.selected = NO;
    }
    UIButton *button = _tabButtons[tabIndex];
    button.selected = YES;
    
    //    这里为什么mas_update centerX 会不行呢
    //    [_indicatorView mas_updateConstraints:^(MASConstraintMaker *make){
    //        make.centerX.equalTo(button.mas_centerX);
    //    }];
    
    [_indicatorView mas_remakeConstraints:^(MASConstraintMaker *make){
        make.width.equalTo(@(APPW / _pageItems.count / 3 * 2));
        make.bottom.equalTo(_separatorView.mas_top).offset(-5);
        make.height.equalTo(@2);
        
        make.centerX.equalTo(button.mas_centerX);
    }];
    [UIView animateWithDuration:0.3f animations:^{
        [self layoutIfNeeded];
    }];
    
    if(_delegate && [_delegate respondsToSelector:@selector(YHJTabPageScrollView:didPageItemSelected:withTabIndex:)]){
        [_delegate YHJTabPageScrollView:self didPageItemSelected:_pageItems[tabIndex] withTabIndex:tabIndex];
    }
}

@end