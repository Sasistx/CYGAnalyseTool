//
//  CYUrlAnalyseModel.h
//  CYGAnalyseTool
//
//  Created by 高天翔 on 2017/8/1.
//  Copyright © 2017年 CYGTX. All rights reserved.
//

#import <Foundation/Foundation.h>

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

- (NSDictionary *)transformToDictionary;

@end
