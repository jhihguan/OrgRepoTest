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

/**
 *  load organization, return repo url if succeed
 *
 *  @param name     organization name
 *  @param complete complete block to pass url or error back
 */
- (void)loadOrganization:(NSString *)name completion:(GHRepoURLBlock)complete;

/**
 *  load organization repo list
 *
 *  @param repoListUrl repo url from api
 *  @param complete    pass repo list or error back
 */
- (void)loadOrgRepoList:(NSString *)repoListUrl completion:(GHArrayBlock)complete;

/**
 *  load repo watch events
 *
 *  @param repoWatchUrl watch event url
 *  @param complete     pass events or error back
 */
- (void)loadRepoEventList:(NSString *)repoEventUrl completion:(GHArrayBlock)complete;

@end
