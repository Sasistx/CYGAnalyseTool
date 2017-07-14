//
//  CYUrlAnalyseProtocol.m
//  ChunyuClinic
//
//  Created by 高天翔 on 16/9/7.
//  Copyright © 2016年 SpringRain. All rights reserved.
//

#import "CYUrlAnalyseProtocol.h"
#import "CYUrlAnalyseManager.h"

@interface CYUrlAnalyseProtocol() <NSURLSessionTaskDelegate>
@property (nonatomic, strong) NSURLSessionTask* sessionTask;
@property (nonatomic, strong) NSDate* startDate;
@property (nonatomic, strong) NSMutableDictionary* urlInfo;
@end

@implementation CYUrlAnalyseProtocol

+ (BOOL)canInitWithTask:(NSURLSessionTask *)task {
    
    NSString *scheme = [task.originalRequest.URL scheme];
    if ( ([scheme caseInsensitiveCompare:@"http"] == NSOrderedSame ||
          [scheme caseInsensitiveCompare:@"https"] == NSOrderedSame))
    {
        if ([NSURLProtocol propertyForKey:CYURLProtocolHandledKey inRequest:task.originalRequest]) {
            return NO;
        }
        return YES;
    }
    return NO;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request
{
    return request;
}

+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)a toRequest:(NSURLRequest *)b
{
    return [super requestIsCacheEquivalent:a toRequest:b];
}

- (void)startLoading
{
    _startDate = [NSDate date];
    _urlInfo = [NSMutableDictionary dictionary];
    _urlInfo[CYRequestUid] = [NSUUID UUID].UUIDString;
    NSMutableURLRequest *mutableReqeust = [[self request] mutableCopy];
    [NSURLProtocol setProperty:@YES forKey:CYURLProtocolHandledKey inRequest:mutableReqeust];
    NSURLSession* session = [NSURLSession sharedSession];
    [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:nil];
    self.sessionTask = [session dataTaskWithRequest:mutableReqeust];
    [self.sessionTask resume];
}

- (void)stopLoading
{
    NSTimeInterval divTime = [[NSDate date] timeIntervalSinceDate:_startDate];
        NSString* requestBody = [[NSString alloc] initWithData:self.request.HTTPBody encoding:NSUTF8StringEncoding];
    _urlInfo[CYResponseTime] = @(divTime);
    _urlInfo[CYRequestUrl] = self.request.URL.absoluteString;
    _urlInfo[CYRequestBody] = requestBody ? : @"";
    _urlInfo[CYRequestHeaderFields] = self.request.allHTTPHeaderFields;
    _urlInfo[CYHttpMethod] = self.request.HTTPMethod;
    [[CYUrlAnalyseManager defaultManager] addObjectToUrlArray:_urlInfo];
    if (self.sessionTask != nil) {
        
        [self.sessionTask cancel];
        self.sessionTask = nil;
    }
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {

    NSString* string = [[NSString alloc] initWithData:self.request.HTTPBody encoding:NSUTF8StringEncoding];
    _urlInfo[CYResponseBody] = string ? : @"";
    _urlInfo[CYResponseUrl] = response.URL.absoluteString;
    _urlInfo[CYMIMEType] = response.MIMEType;
    if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
        _urlInfo[CYResponseHeaderFields] = ((NSHTTPURLResponse*)response).allHeaderFields;
        _urlInfo[CYURLStatusCode] = @(((NSHTTPURLResponse*)response).statusCode);
    }
    
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data {

    [self.client URLProtocol:self didLoadData:data];
}

-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {

    if (error) {
        
        _urlInfo[CYRequestErrorInfo] = error.userInfo;
        [self.client URLProtocol:self didFailWithError:error];
    } else {
        
        [self.client URLProtocolDidFinishLoading:self];
    }
}


@end
