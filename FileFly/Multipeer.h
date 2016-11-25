//
//  Multipeer.h
//  FileFly
//
//  Created by jx on 16/5/17.
//  Copyright © 2016年 jx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>
@interface Multipeer : UIViewController<MCBrowserViewControllerDelegate,MCSessionDelegate>
{
    __block BOOL _isSendDate;
    NSMutableArray *fileDate,*receiveDate;
    NSInteger noOfdata, noOfDataSend;
}

@property (nonatomic, strong) MCBrowserViewController *browserVC;
@property (nonatomic, strong) MCAdvertiserAssistant *advertiser;
@property (nonatomic, strong) MCSession *mySession;
@property (nonatomic, strong) MCPeerID *myPeerID;
@property (strong,nonatomic)NSMutableArray *imageArray;
@property(nonatomic,strong) NSData *data;
@property(nonatomic,strong) NSDictionary *dic;
@end
