//
//  GithubAPIManager.m
//  GithubOrg
//
//  Created by Wane Wang on 2015/9/30.
//  Copyright (c) 2015年 Wane Wang. All rights reserved.
//

#import "GithubAPIManager.h"
#import "GithubAPIURL.h"
#import <AFNetworking.h>

@interface GithubAPIManager ()

@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;

@end

@implementation GithubAPIManager

+ (instancetype)sharedInstance {
    static GithubAPIManager *_manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[GithubAPIManager alloc] init];
        _manager.manager = [AFHTTPRequestOperationManager manager];
        [_manager.manager.requestSerializer setValue:@"application/vnd.github.v3+json" forHTTPHeaderField:@"Accept"];
    });
    return _manager;
}

- (void)loadOrganization:(NSString *)name completion:(GHRepoURLBlock)complete {
    NSString *urlString = [[NSString alloc] initWithFormat:GITHUB_ORG, name];
    [_manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseData) {
        NSString *repoURL = [responseData valueForKey:@"repos_url"];
        if (repoURL) {
            complete(nil, repoURL);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        complete(error, @"");
    }];
}

- (void)loadOrgRepoList:(NSString *)repoListUrl completion:(GHArrayBlock)complete {
    [_manager GET:repoListUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseData) {
        NSLog(@"%@", operation.response.allHeaderFields);
        complete(nil, responseData);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        complete(error, nil);
    }];
}


@end
