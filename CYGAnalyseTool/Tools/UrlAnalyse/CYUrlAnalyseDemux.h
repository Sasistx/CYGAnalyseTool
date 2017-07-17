//
//  CYUrlAnalyseDemux.h
//  CYGAnalyseTool
//
//  Created by 高天翔 on 2017/7/17.
//  Copyright © 2017年 CYGTX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CYUrlAnalyseDemux : UIView

@property (atomic, strong, readonly) NSURLSession* session;

- (instancetype)initWithConfiguration:(NSURLSessionConfiguration*)config;

- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request delegate:(id<NSURLSessionDataDelegate>)delegate;

@end
