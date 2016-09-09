//
//  CYUrlAnalyseProtocol.m
//  ChunyuClinic
//
//  Created by 高天翔 on 16/9/7.
//  Copyright © 2016年 SpringRain. All rights reserved.
//

#import "CYUrlAnalyseProtocol.h"
#import "CYUrlAnalyseManager.h"

@interface CYUrlAnalyseProtocol()
@property (nonatomic, strong) NSURLConnection* connection;
@property (nonatomic, strong) NSDate* startDate;
@property (nonatomic, strong) NSMutableDictionary* urlInfo;
@end

@implementation CYUrlAnalyseProtocol

+ (BOOL)canInitWithRequest:(NSURLRequest *)request
{
    //只处理http和https请求
    NSString *scheme = [[request URL] scheme];
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
    self.connection = [NSURLConnection connectionWithRequest:mutableReqeust delegate:self];
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
    [self.connection cancel];
}

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
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

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.client URLProtocol:self didLoadData:data];
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
    [self.client URLProtocolDidFinishLoading:self];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    _urlInfo[CYRequestErrorInfo] = error.userInfo;
    [self.client URLProtocol:self didFailWithError:error];
}

@end
