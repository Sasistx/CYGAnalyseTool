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
extern NSString* const CYRequestContent;

@interface CYUrlAnalyseManager : NSObject

@property (nonatomic, strong, readonly) NSMutableArray* urlArray;

@property (nonatomic, getter=isEnableUrlAnalyse) BOOL enableUrlAnalyse; //default is YES
@property (nonatomic, getter=isEnableOverlay) BOOL enableOverlay; //default is YES

+ (CYUrlAnalyseManager*)defaultManager;

- (void)addObjectToUrlArray:(NSDictionary*)infoDict;

- (void)cleanAllObejct;

- (void)cleanUrlController;

/**
 需要在应用启动后，网络请求开始之前调用此方法。
 */
- (void)registAnalyse;

/**
 关闭所有测试监控
 */
- (void)logoutAnalyse;

@end
