//
//  CYUrlAnalyseListViewController.m
//  ChunyuClinic
//
//  Created by 高天翔 on 16/9/8.
//  Copyright © 2016年 SpringRain. All rights reserved.
//

#import "CYUrlAnalyseListViewController.h"
#import "CYUrlAnalyseManager.h"
#import "CYUrlAnalyseListCell.h"
#import "CYUrlAnalyzeDetailViewController.h"
#import "CYUrlBaseViewController.h"

@interface CYUrlAnalyseListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView* tableView;

@end

@implementation CYUrlAnalyseListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Analyse List";
    
    UIBarButtonItem* leftItem = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(closeCurrentView:)];
    self.navigationItem.rightBarButtonItem = leftItem;
    
    if ([CYUrlAnalyseManager defaultManager].isEnableUrlAnalyse) {
        
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(urlAnalyseChanged:) name:CYUrlAnalyseChangeKey object:nil];
    }
    
    if ([CYUrlAnalyseManager defaultManager].isEnableOverlay) {
        
        UIBarButtonItem* rightItem = [[UIBarButtonItem alloc] initWithTitle:@"overLay" style:UIBarButtonItemStylePlain target:self action:@selector(showOverlay:)];
        self.navigationItem.leftBarButtonItem = rightItem;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)showOverlay:(id)sender {

    [self.presentingViewController dismissViewControllerAnimated:YES completion:Nil];
    [[CYUrlAnalyseManager defaultManager] cleanUrlController];
#ifdef DEBUG
    id informationOverlay = NSClassFromString(@"UIDebuggingInformationOverlay");
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    [informationOverlay performSelector:@selector(prepareDebuggingOverlay)];
    [[informationOverlay performSelector:@selector(overlay)] performSelector:@selector(toggleVisibility)];
#pragma clang diagnostic pop
#endif
}

- (void)closeCurrentView:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:Nil];
    [[CYUrlAnalyseManager defaultManager] cleanUrlController];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[CYUrlAnalyseManager defaultManager].urlArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 95;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellId = @"cellId";
    CYUrlAnalyseListCell* cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        
        cell = [[CYUrlAnalyseListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    CYUrlAnalyseModel* urlModel = [CYUrlAnalyseManager defaultManager].urlArray[indexPath.row];
    [cell updateListInfo:urlModel];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CYUrlBaseViewController* controller = [[CYUrlBaseViewController alloc] init];
    controller.urlModel = [CYUrlAnalyseManager defaultManager].urlArray[indexPath.row];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)urlAnalyseChanged:(NSNotification*)note
{
    [_tableView reloadData];
}

@end
