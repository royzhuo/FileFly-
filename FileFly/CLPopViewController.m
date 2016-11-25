//
//  CLPopViewController.m
//  CLPopoerView
//
//  Created by nil on 16/3/16.
//  Copyright © 2016年 CenLei. All rights reserved.
//

#import "CLPopViewController.h"
#import "SecondViewController.h"
#import "SheZhi.h"
#import "about.h"
#import "SaoMiaoViewController.h"
@interface CLPopViewController () <UITableViewDataSource, UITableViewDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *leftCell;

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *addArray;

@end

@implementation CLPopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.scrollEnabled = NO;
//    self.tableView.backgroundColor = [UIColor yellowColor];
    self.addArray = [[NSMutableArray alloc] initWithObjects:@"扫一扫",@"设置",@"关于我们" ,nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.addArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        static NSString *identifer = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
        }
        cell.textLabel.text = [NSString stringWithFormat:@"%@", self.addArray[indexPath.row]];
        return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        SaoMiaoViewController *sao = [[UIStoryboard storyboardWithName:@"ZhuYe" bundle:nil]instantiateViewControllerWithIdentifier:@"SaoMiaoView"];
        [self presentViewController:sao animated:NO completion:nil];
    }
    if (indexPath.row ==1) {
        SheZhi *se = [[UIStoryboard storyboardWithName:@"ZhuYe" bundle:nil]instantiateViewControllerWithIdentifier:@"SheZhi"];
        [self presentViewController:se animated:NO completion:nil];
    }
    if (indexPath.row ==2) {
         about *ab = [[UIStoryboard storyboardWithName:@"ZhuYe" bundle:nil]instantiateViewControllerWithIdentifier:@"about"];
        [self presentViewController:ab animated:NO completion:nil];
    }
}
//重写preferredContentSize，返回popover的大小
- (CGSize)preferredContentSize {
    if (self.presentingViewController && self.tableView != nil) {
        CGSize tempSize = self.presentingViewController.view.bounds.size;
        tempSize.width = 150;
        CGSize size = [self.tableView sizeThatFits:tempSize];  //sizeThatFits返回的是最合适的尺寸，但不会改变控件的大小
        return size;
    }else {
        return [super preferredContentSize];
    }
}

@end
