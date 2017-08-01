//
//  CYUrlAnalyseModel.h
//  CYGAnalyseTool
//
//  Created by 高天翔 on 2017/8/1.
//  Copyright © 2017年 CYGTX. All rights reserved.
//

#import <Foundation/Foundation.h>

//NSString* const CYUrlAnalyseChangeKey = @"CYUrlAnalyseChangeKey";
//NSString* const CYURLProtocolHandledKey = @"CYURLProtocolHandledKey";
//NSString* const CYURLStatusCode = @"CYURLStatusCode";
//NSString* const CYMIMEType = @"CYMIMEType";
//NSString* const CYHttpMethod = @"CYHttpMethod";
//NSString* const CYRequestUrl = @"CYRequestUrl";
//NSString* const CYRequestHeaderFields = @"CYRequestHeaderFields";
//NSString* const CYRequestBody = @"CYRequestBody";
//NSString* const CYResponseBody = @"CYResponseBody";
//NSString* const CYResponseUrl = @"CYResponseUrl";
//NSString* const CYResponseHeaderFields = @"CYResponseHeaderFields";
//NSString* const CYRequestErrorInfo = @"CYRequestErrorInfo";
//NSString* const CYResponseTime = @"CYResponseTime";
//NSString* const CYRequestUid = @"CYRequestUid";
//NSString* const CYRequestContent = @"CYRequestContent";
//NSString* const CYRequestHeaderLength = @"CYRequestHeaderLength";
//NSString* const CYRequestBodyLength = @"CYRequestBodyLength";
//NSString* const CYResponseHeaderLength = @"CYResponseHeaderLength";
//NSString* const CYResponseBodyLength = @"CYResponseBodyLength";

@interface CYUrlAnalyseModel : NSObject

@property (nonatomic) NSInteger statusCode;
@property (nonatomic, strong) NSDictionary* errorInfo;
@property (nonatomic, copy) NSString* mimeType;
@property (nonatomic, copy) NSString* requestUid;

@property (nonatomic, copy) NSString* httpMethod;
@property (nonatomic, copy) NSString* requestUrl;
@property (nonatomic, copy) NSString* requestBody;
@property (nonatomic, strong) NSDictionary* requestHeaderFields;
@property (nonatomic) double requestHeaderLength;   //kb
@property (nonatomic) double requestBodyLength;     //kb

@property (nonatomic, copy) NSString* responseUrl;
@property (nonatomic, copy) NSString* responseBody;
@property (nonatomic, copy) NSString* responseContent;
@property (nonatomic, strong) NSDictionary* responseHeaderFields;
@property (nonatomic) NSTimeInterval responseTime;
@property (nonatomic) double responseHeaderLength;  //kb
@property (nonatomic) double responseBodyLength;    //kb

@end
