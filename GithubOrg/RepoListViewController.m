//
//  RepoListViewController.m
//  GithubOrg
//
//  Created by Wane Wang on 2015/9/30.
//  Copyright (c) 2015年 Wane Wang. All rights reserved.
//

#import "RepoListViewController.h"
#import "RepoDetailViewController.h"
#import "GithubAPIManager.h"
#import <SVProgressHUD.h>

static NSString *const USUAL_CELL = @"REPO_TITLE_CELL";

@interface RepoListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation RepoListViewController {
    NSArray *_dataArray;
}

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadRepos];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Network

- (void)loadRepos {
    [SVProgressHUD showWithStatus:@"Loading..."];
    [[GithubAPIManager sharedInstance] loadOrgRepoList:self.repoURL completion:^(NSError *error, NSArray *dataArray) {
        [SVProgressHUD dismiss];
        if (!error) {
            _dataArray = dataArray;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
    }];
}

#pragma mark - TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *repoDict = [_dataArray objectAtIndex:indexPath.row];
    NSLog(@"%@", repoDict);
}

#pragma mark - TableView DataSource

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *repoDict = [_dataArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [repoDict valueForKey:@"name"];
    cell.detailTextLabel.text = [[NSString alloc] initWithFormat:@"star: %@", [repoDict valueForKey:@"stargazers_count"]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:USUAL_CELL forIndexPath:indexPath];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    static NSString *const CELL_SEGUE = @"repolist_detail";
    if ([segue.identifier isEqualToString:CELL_SEGUE]) {
        RepoDetailViewController *detailVC = segue.destinationViewController;
        detailVC.repoDictionary = [_dataArray objectAtIndex:[self.tableView indexPathForSelectedRow].row];
    }
}

/*
 * #pragma mark - Navigation
 *
 * // In a storyboard-based application, you will often want to do a little preparation before navigation
 * - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 *  // Get the new view controller using [segue destinationViewController].
 *  // Pass the selected object to the new view controller.
 * }
 */

@end
