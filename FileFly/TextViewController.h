//
//  TextViewController.h
//  FileFly
//
//  Created by Roy on 16/5/5.
//  Copyright © 2016年 Roy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TextViewDelegate <NSObject>

@optional
-(void)getTextViewContent:(NSString *) content withTitle:(NSString *) titleName;

@end

@interface TextViewController : UIViewController

@property(nonatomic,strong) NSString *titleName;

@property(nonatomic,assign) id<TextViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIView *topView;

- (IBAction)quxiaoEvent:(id)sender;


- (IBAction)finishEvent:(id)sender;


@property (weak, nonatomic) IBOutlet UILabel *titleLabel;





@end
