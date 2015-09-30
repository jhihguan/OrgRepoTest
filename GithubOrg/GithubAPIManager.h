//
//  GithubAPIManager.h
//  GithubOrg
//
//  Created by Wane Wang on 2015/9/30.
//  Copyright (c) 2015年 Wane Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^GHArrayBlock) (NSError *error, NSArray *dataArray);
typedef void(^GHRepoURLBlock) (NSError *error, NSString *repoURL);

@interface GithubAPIManager : NSObject

+ (instancetype)sharedInstance;

- (void)loadOrganization:(NSString *)name completion:(GHRepoURLBlock)complete;
- (void)loadOrgRepoList:(NSString *)repoListUrl completion:(GHArrayBlock)complete;

@end
