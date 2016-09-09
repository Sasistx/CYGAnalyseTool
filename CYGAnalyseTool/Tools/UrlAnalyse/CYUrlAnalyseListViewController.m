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

@interface CYUrlAnalyseListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView* tableView;

@end

@implementation CYUrlAnalyseListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Url List";
    // Do any additional setup after loading the view.
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(urlAnalyseChanged:) name:CYUrlAnalyseChangeKey object:nil];
    
    UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(closeCurrentView:)];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)closeCurrentView:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:Nil];
    [CYUrlAnalyseManager defaultManager].isShown = NO;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[CYUrlAnalyseManager defaultManager].urlArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellId = @"cellId";
    CYUrlAnalyseListCell* cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        
        cell = [[CYUrlAnalyseListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    NSDictionary* urlInfo = [CYUrlAnalyseManager defaultManager].urlArray[indexPath.row];
    [cell updateListInfo:urlInfo];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CYUrlAnalyzeDetailViewController* controller = [[CYUrlAnalyzeDetailViewController alloc] init];
    controller.urlInfo = [CYUrlAnalyseManager defaultManager].urlArray[indexPath.row];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)urlAnalyseChanged:(NSNotification*)note
{
    [_tableView reloadData];
}

@end
