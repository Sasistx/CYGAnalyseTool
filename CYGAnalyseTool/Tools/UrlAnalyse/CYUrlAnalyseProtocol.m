//
//  CYUrlAnalyseProtocol.m
//  ChunyuClinic
//
//  Created by 高天翔 on 16/9/7.
//  Copyright © 2016年 SpringRain. All rights reserved.
//

#import "CYUrlAnalyseProtocol.h"
#import "CYUrlAnalyseManager.h"
#import "CYUrlAnalyseDemux.h"

@interface CYUrlAnalyseProtocol() <NSURLSessionDataDelegate>
@property (nonatomic, strong) NSDate* startDate;
@property (nonatomic, strong) NSMutableDictionary* urlInfo;
@end

@implementation CYUrlAnalyseProtocol

+ (BOOL)canInitWithRequest:(NSURLRequest *)request {

    NSString *scheme = [request.URL scheme];
    if ( ([scheme caseInsensitiveCompare:@"http"] == NSOrderedSame ||
          [scheme caseInsensitiveCompare:@"https"] == NSOrderedSame))
    {
        if ([NSURLProtocol propertyForKey:CYURLProtocolHandledKey inRequest:request]) {
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

- (void)startLoading
{
    _startDate = [NSDate date];
    _urlInfo = [NSMutableDictionary dictionary];
    _urlInfo[CYRequestUid] = [NSUUID UUID].UUIDString;
    NSMutableURLRequest *mutableReqeust = [[self request] mutableCopy];
    [[self class] setProperty:@YES forKey:CYURLProtocolHandledKey inRequest:mutableReqeust];
    
    self.task = [[[self class] sharedDemux] dataTaskWithRequest:mutableReqeust delegate:self];
    [self.task resume];
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
    if (self.task != nil) {
        
        [self.task cancel];
        self.task = nil;
    }
}

+ (CYUrlAnalyseDemux *)sharedDemux {

    static dispatch_once_t onceToken;
    static CYUrlAnalyseDemux* analyseDemux;
    dispatch_once(&onceToken, ^{
        
        NSURLSessionConfiguration * config = [NSURLSessionConfiguration defaultSessionConfiguration];
        config.protocolClasses = @[self];
        analyseDemux = [[CYUrlAnalyseDemux alloc] initWithConfiguration:config];
    });
    
    return analyseDemux;
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task willPerformHTTPRedirection:(NSHTTPURLResponse *)response newRequest:(NSURLRequest *)newRequest completionHandler:(void (^)(NSURLRequest *))completionHandler {

    NSMutableURLRequest* redirectRequest = [newRequest mutableCopy];
    
    [[self class] removePropertyForKey:CYURLProtocolHandledKey inRequest:redirectRequest];
    
    [[self client] URLProtocol:self wasRedirectedToRequest:redirectRequest redirectResponse:response];
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

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {

    if (error) {
        
        _urlInfo[CYRequestErrorInfo] = error.userInfo;
        [self.client URLProtocol:self didFailWithError:error];
    } else {
        
        [self.client URLProtocolDidFinishLoading:self];
    }
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask willCacheResponse:(NSCachedURLResponse *)proposedResponse completionHandler:(void (^)(NSCachedURLResponse *))completionHandler
{
    completionHandler(proposedResponse);
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *))completionHandler
{
    completionHandler(NSURLSessionAuthChallengePerformDefaultHandling, nil);
}

@end
