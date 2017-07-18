//
//  CYUrlAnalyseManager.m
//  ChunyuClinic
//
//  Created by 高天翔 on 16/9/7.
//  Copyright © 2016年 SpringRain. All rights reserved.
//

#import "CYUrlAnalyseManager.h"
#import "CYUrlAnalyseListViewController.h"
#import "CYUrlAnalyseProtocol.h"
#import "CYGToolDefines.h"
#import <CoreMotion/CoreMotion.h>

NSString* const CYUrlAnalyseChangeKey = @"CYUrlAnalyseChangeKey";
NSString* const CYURLProtocolHandledKey = @"CYURLProtocolHandledKey";
NSString* const CYURLStatusCode = @"CYURLStatusCode";
NSString* const CYMIMEType = @"CYMIMEType";
NSString* const CYHttpMethod = @"CYHttpMethod";
NSString* const CYRequestUrl = @"CYRequestUrl";
NSString* const CYRequestHeaderFields = @"CYRequestHeaderFields";
NSString* const CYRequestBody = @"CYRequestBody";
NSString* const CYResponseBody = @"CYResponseBody";
NSString* const CYResponseUrl = @"CYResponseUrl";
NSString* const CYResponseHeaderFields = @"CYResponseHeaderFields";
NSString* const CYRequestErrorInfo = @"CYRequestErrorInfo";
NSString* const CYResponseTime = @"CYResponseTime";
NSString* const CYRequestUid = @"CYRequestUid";

@interface CYUrlAnalyseManager ()
@property (nonatomic, strong) CMMotionManager *cmManager;
@property (nonatomic, weak) UIViewController* urlController;
@property (nonatomic, weak) UIButton* overlayBtn;
@end

@implementation CYUrlAnalyseManager

static CYUrlAnalyseManager* defaultManager = nil;

+ (CYUrlAnalyseManager*)defaultManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        defaultManager = [[self alloc] init];
        
    });
    return defaultManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _urlArray = [NSMutableArray array];
        
        _enableOverlay = YES;
        _enableUrlAnalyse = YES;
    }
    return self;
}

- (void)addObjectToUrlArray:(NSDictionary*)infoDict
{
    if (_urlArray.count > 30) {
        
        [_urlArray removeObjectAtIndex:29];
    }
    [_urlArray insertObject:infoDict atIndex:0];
    [[NSNotificationCenter defaultCenter] postNotificationName:CYUrlAnalyseChangeKey object:nil userInfo:nil];
}

- (void)cleanAllObejct
{
    [_urlArray removeAllObjects];
    [[NSNotificationCenter defaultCenter] postNotificationName:CYUrlAnalyseChangeKey object:nil userInfo:nil];
}

- (void)cleanUrlController {

    self.urlController = nil;
}

- (void)registAnalyse
{
    if (_cmManager) {
        
        return;
    }
    
    CMMotionManager *motionManager = [[CMMotionManager alloc] init];
    if (!motionManager.accelerometerAvailable) {
        NSLog(@"CMMotionManager unavailable");
    }
    motionManager.accelerometerUpdateInterval = 0.1; // 数据更新时间间隔
    
    @weakify(self);
    [motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue]withHandler:^(CMAccelerometerData *accelerometerData,NSError *error) {
        double x = accelerometerData.acceleration.x;
        double y = accelerometerData.acceleration.y;
        double z = accelerometerData.acceleration.z;
        
        @strongify(self);
        if (fabs(x)>2.0 ||fabs(y)>2.0 ||fabs(z)>2.0) {
            
            [self performSelectorOnMainThread:@selector(showAnalyseView) withObject:nil waitUntilDone:YES];
        }
    }];
    
    _cmManager = motionManager;
    
    [NSURLProtocol registerClass:[CYUrlAnalyseProtocol class]];
}

- (void)logoutAnalyse
{
    if (_cmManager) {
        
        [_cmManager stopAccelerometerUpdates];
        _cmManager = nil;
        
        [NSURLProtocol unregisterClass:[CYUrlAnalyseProtocol class]];
    }
}

- (void)showAnalyseView {
    
    CYUrlAnalyseListViewController* controller = [[CYUrlAnalyseListViewController alloc] init];
    UINavigationController* navi = [[UINavigationController alloc] initWithRootViewController:controller];
    UIViewController* currentController = [UIApplication sharedApplication].keyWindow.rootViewController;
    [currentController presentViewController:navi animated:YES completion:Nil];
    _urlController = controller;
}

@end
