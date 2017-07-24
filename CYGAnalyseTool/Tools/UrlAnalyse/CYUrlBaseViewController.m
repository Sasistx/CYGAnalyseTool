//
//  CYUrlBaseViewController.m
//  CYGAnalyseTool
//
//  Created by 高天翔 on 2017/7/24.
//  Copyright © 2017年 CYGTX. All rights reserved.
//

#import "CYUrlBaseViewController.h"
#import "CYUrlAnalyzeDetailViewController.h"
#import "CYUrlContentViewController.h"

@interface CYUrlBaseViewController ()
@property (nonatomic, strong) NSMutableArray* segControllers;
@end

@implementation CYUrlBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UISegmentedControl* segment = [[UISegmentedControl alloc] initWithItems:@[@"request", @"content"]];
    [segment addTarget:self action:@selector(segmentDidChanged:) forControlEvents:UIControlEventValueChanged];
    segment.selectedSegmentIndex = 0;
    self.navigationItem.titleView = segment;
    
    _segControllers = [NSMutableArray array];
    CYUrlAnalyzeDetailViewController* detailController = [[CYUrlAnalyzeDetailViewController alloc] init];
    detailController.urlInfo = _urlInfo;
    [self.view addSubview:detailController.view];
    [self addChildViewController:detailController];
    [_segControllers addObject:detailController];
    
    CYUrlContentViewController* contentController = [[CYUrlContentViewController alloc] init];
    contentController.urlInfo = _urlInfo;
    [self.view addSubview:contentController.view];
    [self addChildViewController:contentController];
    [_segControllers addObject:contentController];
    
    [self.view bringSubviewToFront:detailController.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)segmentDidChanged:(UISegmentedControl *)segment {

    NSInteger selectedIndex = segment.selectedSegmentIndex;
    UIViewController* controller = nil;
    controller = _segControllers[selectedIndex];
    [self.view bringSubviewToFront:controller.view];
}

@end
