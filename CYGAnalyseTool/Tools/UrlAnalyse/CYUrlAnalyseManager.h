//
//  CYUrlAnalyseManager.h
//  ChunyuClinic
//
//  Created by 高天翔 on 16/9/7.
//  Copyright © 2016年 SpringRain. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString* const CYUrlAnalyseChangeKey;
extern NSString* const CYURLProtocolHandledKey;
extern NSString* const CYURLStatusCode;
extern NSString* const CYMIMEType;
extern NSString* const CYHttpMethod;
extern NSString* const CYRequestUrl;
extern NSString* const CYRequestHeaderFields;
extern NSString* const CYRequestBody;
extern NSString* const CYResponseBody;
extern NSString* const CYResponseUrl;
extern NSString* const CYResponseHeaderFields;
extern NSString* const CYRequestErrorInfo;
extern NSString* const CYResponseTime;
extern NSString* const CYRequestUid;

@interface CYUrlAnalyseManager : NSObject

@property (nonatomic, strong, readonly) NSMutableArray* urlArray;
@property (nonatomic) BOOL isShown;

+ (CYUrlAnalyseManager*)defaultManager;

- (void)addObjectToUrlArray:(NSDictionary*)infoDict;

- (void)cleanAllObejct;

- (void)registAnalyse;

- (void)logoutAnalyse;

@end
