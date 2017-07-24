//
//  CYUrlAnalyzeDetailViewController.m
//  ChunyuClinic
//
//  Created by 高天翔 on 16/9/8.
//  Copyright © 2016年 SpringRain. All rights reserved.
//

#import "CYUrlAnalyzeDetailViewController.h"
#import "CYUrlAnalyseManager.h"

@interface CYUrlAnalyzeDetailViewController ()
@property (nonatomic, strong) UIScrollView* scrollView;
@property (nonatomic, copy) NSString* urlString;
@end

@implementation CYUrlAnalyzeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Detail";
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_scrollView];
    
    UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithTitle:@"Copy" style:UIBarButtonItemStylePlain target:self action:@selector(copyButtonClicked:)];
    self.navigationItem.rightBarButtonItem = item;
    
    [self showUrlInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    
}

- (void)showUrlInfo
{
    NSMutableString* requestString = [[NSMutableString alloc] initWithString:@"Request:\n\n"];
    [requestString appendFormat:@"Url: %@\n\n", _urlInfo[CYRequestUrl]];
    [requestString appendFormat:@"Body: %@\n\n", _urlInfo[CYRequestBody]];
    [requestString appendFormat:@"HeaderField:\n"];
    if ([_urlInfo[CYRequestHeaderFields] isKindOfClass:[NSDictionary class]]) {
        
        NSDictionary* headerFields = _urlInfo[CYRequestHeaderFields];
        __block NSMutableString* requestFieldString = [[NSMutableString alloc] init];
        [headerFields enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
           
            [requestFieldString appendFormat:@"%@ : %@\n", key, obj];
        }];
        
        [requestString appendString:requestFieldString];
    }
    
    
    UILabel* requestLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 20, [UIScreen mainScreen].bounds.size.width - 60, 0)];
    requestLabel.numberOfLines = 0;
    requestLabel.text = requestString;
    [requestLabel sizeToFit];
    
    [_scrollView addSubview:requestLabel];
    
    CGFloat labelOriY = requestLabel.frame.origin.y + requestLabel.frame.size.height + 20;
    
    UILabel* errorLabel = [[UILabel alloc] initWithFrame:CGRectMake(requestLabel.frame.origin.x, labelOriY, requestLabel.frame.size.width, 0)];
    errorLabel.numberOfLines = 0;
    [_scrollView addSubview:errorLabel];
 
    NSMutableString* errorString = [[NSMutableString alloc] init];
    
    if ([_urlInfo[CYRequestErrorInfo] isKindOfClass:[NSDictionary class]]) {
        
        [errorString appendString:@"\n\nError:\n\n"];
        NSDictionary* errorInfo = _urlInfo[CYRequestErrorInfo];
        [errorString appendFormat:@"Url: %@\n\n", errorInfo[NSURLErrorFailingURLStringErrorKey]];
        [errorString appendFormat:@"Decription: %@\n\n", errorInfo[NSLocalizedDescriptionKey]];
        [errorString appendFormat:@"Other: %@\n\n", errorInfo[NSUnderlyingErrorKey]];
    }
    
    if (errorString.length > 0) {
        
        errorLabel.text = errorString;
        [errorLabel sizeToFit];
        labelOriY += (errorLabel.frame.size.height + 20);
    }else {
        errorLabel.hidden = YES;
    }
    
    UILabel* responseLabel = [[UILabel alloc] initWithFrame:CGRectMake(requestLabel.frame.origin.x, labelOriY, requestLabel.frame.size.width, 0)];
    responseLabel.numberOfLines = 0;
    [_scrollView addSubview:responseLabel];
    NSMutableString* responseString = [[NSMutableString alloc] init];
    [responseString appendString:@"\n\nResponse:\n\n"];
    [responseString appendFormat:@"response time:%0.4fs\n\n", [_urlInfo[CYResponseTime] floatValue]];
    [responseString appendFormat:@"Method:%@  StatusCode:%@\n\n", _urlInfo[CYHttpMethod], _urlInfo[CYURLStatusCode]];
    [responseString appendFormat:@"MIME type: %@\n\n", _urlInfo[CYMIMEType]];
    [responseString appendFormat:@"Url: %@\n\n", _urlInfo[CYResponseUrl]];
    [responseString appendFormat:@"Body: %@\n\n", _urlInfo[CYResponseBody]];
    [responseString appendFormat:@"HeaderFields:\n\n"];
    if ([_urlInfo[CYResponseHeaderFields] isKindOfClass:[NSDictionary class]]) {
        
        NSDictionary* headerFields = _urlInfo[CYResponseHeaderFields];
        __block NSMutableString* responseFieldString = [[NSMutableString alloc] init];
        [headerFields enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            
            [responseFieldString appendFormat:@"%@ : %@\n", key, obj];
        }];
        
        [responseString appendString:responseFieldString];
    }
    
    responseLabel.text = responseString;
    [responseLabel sizeToFit];
    
    labelOriY += (responseLabel.frame.size.height + 20);
    
    [_scrollView setContentSize:CGSizeMake(self.view.frame.size.width, labelOriY)];
    
    _urlString = _urlInfo[CYRequestUrl];
}

- (void)copyButtonClicked:(id)sender
{
    @weakify(self);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"Select" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"cancel"
                                                      style:UIAlertActionStyleCancel
                                                    handler:^(UIAlertAction *action) {
                                                        
                                                    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"url"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction *action) {
                                                        
                                                        @strongify(self);
                                                        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                                                        [pasteboard setString:self.urlString];
                                                    }];
    [alertController addAction:action1];
    [alertController addAction:action2];
    [self.navigationController presentViewController:alertController animated:YES completion:Nil];
}

@end
