//
//  MultipeerTools.m
//  FileFly
//
//  Created by Roy on 16/5/29.
//  Copyright © 2016年 jx. All rights reserved.
//

#import "MultipeerTools.h"


@implementation MultipeerTools

-(id)init
{
    self=[super init];

    if (self) {
        self.peerID=nil;
        self.session=nil;
        self.advertiser=nil;
        self.browser=nil;
    }
    return self;

}

#pragma 初始化方法
-(void)setupPeerAndSessionByDisplayname:(NSString *)displayName
{
    self.peerID=[[MCPeerID alloc]initWithDisplayName:displayName];
    self.session=[[MCSession alloc]initWithPeer:self.peerID];
    self.session.delegate=self;

}
-(void)setupBrowser
{
    self.browser=[[MCBrowserViewController alloc]initWithServiceType:@"chat" session:self.session];
}

-(void)setupAdvertiser
{
    self.advertiser=[[MCAdvertiserAssistant alloc]initWithServiceType:@"chat" discoveryInfo:nil session:self.session];
    [self.advertiser start];
}

#pragma mark session协议
//消息中心用字典
-(void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state
{
    NSLog(@"state :%d",state);
    NSDictionary *dict = @{@"peerID": peerID,
                           @"state" : [NSNumber numberWithInt:state]
                           };
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MCDidChangeStateNotification"
                                                        object:nil
                                                      userInfo:dict];
}
-(void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID
{

}

-(void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID
{

}

-(void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress
{
    NSDictionary *dict = @{@"resourceName"  :   resourceName,
                           @"peerID"        :   peerID,
                           @"progress"      :   progress
                           };
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MCDidStartReceivingResourceNotification"
                                                        object:nil
                                                      userInfo:dict];
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [progress addObserver:self
                   forKeyPath:@"fractionCompleted"
                      options:NSKeyValueObservingOptionNew
                      context:nil];
    });

}

-(void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error
{
    NSDictionary *dict = @{@"resourceName"  :   resourceName,
                           @"peerID"        :   peerID,
                           @"localURL"      :   localURL
                           };
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didFinishReceivingResourceNotification"
                                                        object:nil
                                                      userInfo:dict];
}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MCReceivingProgressNotification"
                                                        object:nil
                                                      userInfo:@{@"progress": (NSProgress *)object}];

}

@end
