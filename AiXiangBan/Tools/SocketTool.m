//
//  SocketTool.m
//  AiXiangBan
//
//  Created by 曾洪磊 on 2017/10/14.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import "SocketTool.h"
@interface SocketTool() <GCDAsyncSocketDelegate>



@end
@implementation SocketTool
+(SocketTool *)Share

{
    
    static SocketTool *manager=nil;
    
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        
        manager=[[SocketTool alloc]init];
        
        manager.asyncsocket=[[GCDAsyncSocket alloc]initWithDelegate:manager delegateQueue:dispatch_get_main_queue()];
        
        
        
    });
    
    return manager;
    
}



-(void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port

{
    
    if ([self.delegate respondsToSelector:@selector(socket:didConnectToHost:port:)]) {
        
        [self.delegate socket:sock didConnectToHost:host port:port];
        
    }
    
}

-(void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err

{
    
    if ([self.delegate respondsToSelector:@selector(socketDidDisconnect:withError:)]) {
        
        [self.delegate socketDidDisconnect:sock withError:err];
        
    }
    
}





-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag

{
    
    if ([self.delegate respondsToSelector:@selector(socket:didReadData:withTag:)]) {
        
        [self.delegate socket:sock didReadData:data withTag:tag];
        
    }
    
    
    
    //    [sock disconnect];
    
}





-(void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag

{
    
    if ([self.delegate respondsToSelector:@selector(socket:didWriteDataWithTag:)]) {
        
        [self.delegate socket:sock didWriteDataWithTag:tag];
        
    }
    
}





-(NSTimeInterval)socket:(GCDAsyncSocket *)sock shouldTimeoutWriteWithTag:(long)tag elapsed:(NSTimeInterval)elapsed bytesDone:(NSUInteger)length

{
    
    NSLog(@"timeout");
    
    return 0;
    
}



-(BOOL)destroy

{
    
    [_asyncsocket disconnect];
    
    return YES;
    
}

@end
