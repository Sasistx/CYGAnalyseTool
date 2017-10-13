//
//  CYUrlAnalyseModel.m
//  CYGAnalyseTool
//
//  Created by 高天翔 on 2017/8/1.
//  Copyright © 2017年 CYGTX. All rights reserved.
//

#import "CYUrlAnalyseModel.h"

NSString* const CYUrlModelStatusCode = @"Status Code";
NSString* const CYUrlModelErrorInfo = @"Error Info";
NSString* const CYUrlModelMimeType = @"MIME";
NSString* const CYUrlModelReqUid = @"Id";
NSString* const CYUrlModelHttpMethod = @"Method";
NSString* const CYUrlModelReqUrl = @"Request Url";
NSString* const CYUrlModelReqBody = @"Request Body";
NSString* const CYUrlModelReqHeaderFields = @"Req Header fields";
NSString* const CYUrlModelReqHeaderLength = @"Req Header length";
NSString* const CYUrlModelReqBodyLength = @"Req Body length";
NSString* const CYUrlModelResponseUrl = @"Response Url";
NSString* const CYUrlModelResponseBody = @"Response Body";
NSString* const CYUrlModelResponseContent = @"Response Content";
NSString* const CYUrlModelResponseTime = @"Response time";
NSString* const CYUrlModelRespHeaderFields = @"Resp Header fields";
NSString* const CYUrlModelRespHeaderLength = @"Resp Header length";
NSString* const CYUrlModelRespBodyLength = @"Resp Body length";

@implementation CYUrlAnalyseModel

- (NSDictionary *)transformToDictionary {

    NSMutableDictionary* modelDict = [NSMutableDictionary dictionary];
    
    modelDict[CYUrlModelReqUid] = [self ensureStrNotEmpty:self.requestUid];
    modelDict[CYUrlModelStatusCode] = @(self.statusCode);
    modelDict[CYUrlModelMimeType] = [self ensureStrNotEmpty:self.mimeType];
    modelDict[CYUrlModelHttpMethod] = [self ensureStrNotEmpty:self.httpMethod];
    modelDict[CYUrlModelReqUrl] = [self ensureStrNotEmpty:self.requestUrl];
    modelDict[CYUrlModelReqBody] = [self ensureStrNotEmpty:self.requestBody];
    modelDict[CYUrlModelReqHeaderFields] = self.requestHeaderFields ? : @{};
    modelDict[CYUrlModelRespHeaderLength] = [NSString stringWithFormat:@"%f kb", self.requestHeaderLength];
    modelDict[CYUrlModelReqBodyLength] = [NSString stringWithFormat:@"%f kb", self.requestBodyLength];
    modelDict[CYUrlModelResponseUrl] = [self ensureStrNotEmpty:self.responseUrl];
    modelDict[CYUrlModelResponseBody] = [self ensureStrNotEmpty:self.responseBody];
    modelDict[CYUrlModelResponseContent] = [self ensureStrNotEmpty:self.responseContent];
    modelDict[CYUrlModelResponseTime] = [NSString stringWithFormat:@"%0.4fs", self.responseTime];
    modelDict[CYUrlModelRespHeaderFields] = self.responseHeaderFields ? : @{};
    modelDict[CYUrlModelRespHeaderLength] = [NSString stringWithFormat:@"%f kb", self.responseHeaderLength];
    modelDict[CYUrlModelRespBodyLength] = [NSString stringWithFormat:@"%f kb", self.responseBodyLength];
    
    return modelDict;
}

- (NSString *)ensureStrNotEmpty:(NSString *)str{

    if (![str isKindOfClass:[NSString class]]) {
        
        return @"";
    }
    
    if (str == nil) {
        
        return @"";
    }
    
    return str;
}

@end
