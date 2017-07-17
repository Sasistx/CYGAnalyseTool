//
//  CYUrlAnalyseDemux.m
//  CYGAnalyseTool
//
//  Created by 高天翔 on 2017/7/17.
//  Copyright © 2017年 CYGTX. All rights reserved.
//

#import "CYUrlAnalyseDemux.h"

@interface CYUrlAnalyseDemux () <NSURLSessionDataDelegate>
@property (nonatomic, weak) id <NSURLSessionDataDelegate> delegate;
@end

@implementation CYUrlAnalyseDemux

- (instancetype)initWithConfiguration:(NSURLSessionConfiguration*)config {

    self = [super init];
    if (self) {
        
        _session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
        config = [NSURLSessionConfiguration defaultSessionConfiguration];
    }
    return self;
}

- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request delegate:(id<NSURLSessionDataDelegate>)delegate {

    NSURLSessionDataTask *task = [_session dataTaskWithRequest:request];
    
    return task;
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    
    if ([self.delegate respondsToSelector:@selector(URLSession:dataTask:didReceiveResponse:completionHandler:)]) {
        
        [self.delegate URLSession:session dataTask:dataTask didReceiveResponse:response completionHandler:completionHandler];
    }
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data {
    
    if ([self.delegate respondsToSelector:@selector(URLSession:dataTask:didReceiveData:)]) {
        
        [self.delegate URLSession:session dataTask:dataTask didReceiveData:data];
    }
}

-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    
    if ([self.delegate respondsToSelector:@selector(URLSession:task:didCompleteWithError:)]) {
        
        [self.delegate URLSession:session task:task didCompleteWithError:error];
    }
}

@end
