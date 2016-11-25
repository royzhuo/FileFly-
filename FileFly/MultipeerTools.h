//
//  MultipeerTools.h
//  FileFly
//
//  Created by Roy on 16/5/29.
//  Copyright © 2016年 jx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@interface MultipeerTools : NSObject<MCSessionDelegate>

@property (nonatomic, strong) MCPeerID *peerID;
@property(nonatomic,strong) MCSession *session;
@property(nonatomic,strong) MCBrowserViewController *browser;
@property(nonatomic,strong) MCAdvertiserAssistant *advertiser;

-(void) setupPeerAndSessionByDisplayname:(NSString *) displayName;
-(void) setupBrowser;
-(void) setupAdvertiser;


@end
