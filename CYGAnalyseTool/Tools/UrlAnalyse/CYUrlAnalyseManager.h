//
//  CYUrlAnalyseManager.h
//  ChunyuClinic
//
//  Created by 高天翔 on 16/9/7.
//  Copyright © 2016年 SpringRain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CYNetworkFlow.h"
#import "CYUrlAnalyseModel.h"

extern NSString* const CYUrlAnalyseChangeKey;
extern NSString* const CYURLProtocolHandledKey;

@interface CYUrlAnalyseManager : NSObject

@property (nonatomic, strong, readonly) NSMutableArray <CYUrlAnalyseModel *>* urlArray;

@property (nonatomic, getter=isEnableUrlAnalyse) BOOL enableUrlAnalyse; //default is YES
@property (nonatomic, getter=isEnableOverlay) BOOL enableOverlay; //default is YES

@property (nonatomic, strong) CYNetworkFlow* networkFlow;

+ (CYUrlAnalyseManager *)defaultManager;

- (void)addObjectToUrlArray:(CYUrlAnalyseModel *)urlModel;

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

- (void)writeUrlDataToPlistWithfinishBlock:(void (^)(BOOL success))finishBlock;

@end
