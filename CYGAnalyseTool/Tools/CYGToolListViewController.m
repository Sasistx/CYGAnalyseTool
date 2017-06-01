//
//  CYGToolListViewController.m
//  CYGAnalyseTool
//
//  Created by 高天翔 on 2017/6/1.
//  Copyright © 2017年 CYGTX. All rights reserved.
//

#import "CYGToolListViewController.h"
#import "CYUrlAnalyseListViewController.h"
#import "CYUrlAnalyseManager.h"

@interface CYGToolListViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView* tableview;
@end

@implementation CYGToolListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableview = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.view addSubview:self.tableview];
    
    UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(closeCurrentView:)];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)closeCurrentView:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:Nil];
    [CYUrlAnalyseManager defaultManager].isShown = NO;
}

#pragma mark - tableview delegate & datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 2;
}

- (UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString* cellId = @"CYGListCell";
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:cellId];
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (indexPath.row == 0) {
        //request
        cell.textLabel.text = @"request 请求记录";
    }else if (indexPath.row == 1){
        //overlay
        cell.textLabel.text = @"打开Overlay";
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        
        CYUrlAnalyseListViewController* controller = [[CYUrlAnalyseListViewController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    }else if (indexPath.row == 1){
        
#ifdef DEBUG
        id informationOverlay = NSClassFromString(@"UIDebuggingInformationOverlay");
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        [informationOverlay performSelector:@selector(prepareDebuggingOverlay)];
        [[informationOverlay performSelector:@selector(overlay)] performSelector:@selector(toggleVisibility)];
#pragma clang diagnostic pop
#endif
    }
}

@end
