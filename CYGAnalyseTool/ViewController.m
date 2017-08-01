//
//  ViewController.m
//  CYGAnalyseTool
//
//  Created by 高天翔 on 16/9/8.
//  Copyright © 2016年 CYGTX. All rights reserved.
//

#import "ViewController.h"
#import "CYUrlAnalyseProtocol.h"
#import "CYUrlAnalyseManager.h"
#import "CYUrlAnalyseListViewController.h"

@interface ViewController () <NSURLSessionDelegate, UIWebViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIWebView* webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:webView];
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.apple.com/cn/"]];
    [webView loadRequest:request];
    
    UIBarButtonItem* leftItem = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(closeAnalyse:)];
    self.navigationItem.rightBarButtonItem = leftItem;
    
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc] initWithTitle:@"network" style:UIBarButtonItemStylePlain target:self action:@selector(openAnalyse:)];
    self.navigationItem.leftBarButtonItem = rightItem;
    
    
    [[CYUrlAnalyseManager defaultManager].networkFlow startblock:^(u_int32_t sendFlow, u_int32_t receivedFlow) {
       
        
    }];
//    NSURLSessionConfiguration* config = [NSURLSessionConfiguration defaultSessionConfiguration];
//    config.protocolClasses = @[self];
//    NSURLSession* session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
//    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request];
//    [task resume];
}

- (void)closeAnalyse:(id)sender {

    [[CYUrlAnalyseManager defaultManager] logoutAnalyse];
}

- (void)openAnalyse:(id)sender {

    CYNetworkFlow* networkFlow = [CYUrlAnalyseManager defaultManager].networkFlow;
    NSLog(@"--up--%@", [networkFlow getUpFlow]);
    NSLog(@"--down--%@", [networkFlow getDownFlow]);
    NSLog(@"--wifi-send--%u", networkFlow.kWiFiSent);
    NSLog(@"--wifi-receive--%u", networkFlow.kWiFiReceived);
    NSLog(@"--wwan-send--%u", networkFlow.kWWANSent);
    NSLog(@"--wwan-receive--%u", networkFlow.kWWANReceived);
    
    CYUrlAnalyseListViewController* controller = [[CYUrlAnalyseListViewController alloc] init];
    UINavigationController* navi = [[UINavigationController alloc] initWithRootViewController:controller];
    UIViewController* currentController = [UIApplication sharedApplication].keyWindow.rootViewController;
    [currentController presentViewController:navi animated:YES completion:Nil];
    
    //[[CYUrlAnalyseManager defaultManager] registAnalyse];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)buttonClicked:(UIButton *)button {

    
}

//- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
//
//    
//}
//
//- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
//
//    
//}
//
//- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
//
//    
//}
//
//- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
//
//    
//}
//
//- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
//    
//
//}
//
//- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
//    didReceiveData:(NSData *)data {
//    
//    
//}
//
//-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
//    
//}



@end
