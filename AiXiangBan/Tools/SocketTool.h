//
//  SocketTool.h
//  AiXiangBan
//
//  Created by 曾洪磊 on 2017/10/14.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncSocket.h"
@protocol TcpManagerDelegate <NSObject>

-(void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port;



-(void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err;



-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag;

-(void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag;

@end



@interface SocketTool : NSObject

@property(strong,nonatomic) GCDAsyncSocket *asyncsocket;

@property(nonatomic,strong)id<TcpManagerDelegate>delegate;

+(SocketTool *)Share;

-(BOOL)destroy;
@end
