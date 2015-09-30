//
//  ViewController.m
//  GithubOrg
//
//  Created by Wane Wang on 2015/9/30.
//  Copyright (c) 2015年 Wane Wang. All rights reserved.
//

#import "ViewController.h"
#import "GithubAPIManager.h"
#import "RepoListViewController.h"
#import <SVProgressHUD.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *orgTextField;

@end

@implementation ViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Action

- (IBAction)searchOrgAction:(id)sender {
    NSString *orgText = self.orgTextField.text;
    if ([orgText isEqualToString:@""]) {
        [SVProgressHUD showInfoWithStatus:@"Organization Can't be Empty"];
        return;
    }
    [SVProgressHUD showWithStatus:@"Loading..."];
    [[GithubAPIManager sharedInstance] loadOrganization:orgText completion:^(NSError *error, NSString *repoURL) {
        if (!error) {
            [SVProgressHUD dismiss];
            RepoListViewController *repoListVC = [self.storyboard instantiateViewControllerWithIdentifier:@"RepoListVC"];
            repoListVC.repoURL = repoURL;
            [self.navigationController pushViewController:repoListVC animated:YES];
        } else {
            [SVProgressHUD showErrorWithStatus:@"No Organization"];
        }
        
    }];
}


@end
