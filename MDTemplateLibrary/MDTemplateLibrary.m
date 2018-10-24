//
//  MDTemplateLibrary.m
//  matchday
//
//  Created by Andriy Fedin on 8/4/16.
//  Copyright © 2016 111 Minutes. All rights reserved.
//

#import "MDTemplateLibrary.h"
#import "MDCardAPIManager.h"
#import "MDAppConstants.h"
#import "MDCardOverlay.h"


@interface MDTemplateLibrary ()

@property (strong, nonatomic, readwrite) NSArray<MDTemplateGroup *> *templateGroups;
@property (strong, nonatomic, readwrite) NSArray<MDCardOverlay *> *overlays;
@property (assign, nonatomic) BOOL isLoading;
@property (strong, nonatomic, readwrite) NSArray<NSString *> *headlines;

@end


@implementation MDTemplateLibrary

+ (MDTemplateLibrary *)sharedLibrary
{
    static MDTemplateLibrary *sharedLibrary = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedLibrary = [self new];
    });
    
    return sharedLibrary;
}

- (void)loadTemplates
{
    [self loadOverlaysWithSuccess:nil failure:nil];
    [self loadTemplatesWithSuccess:nil failure:nil];
    [self loadHeadlinesWithSuccess:nil failure:nil];
}

- (void)loadTemplatesWithSuccess:(void (^)(NSArray *templates))success
                         failure:(void (^)(NSError *error))failure
{
    self.isLoading = YES;
    
    MDWeakSelf
    
    [MDCardAPIManager getAllTemplateGroupsWithSuccess:^(NSArray<MDTemplateGroup *> *templateGroups) {
        
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"groupID" ascending:YES];
        weakSelf.templateGroups = [templateGroups sortedArrayUsingDescriptors:@[sort]];
        weakSelf.isLoading = NO;

        if (success) {
            success(weakSelf.templateGroups);
        }
    } failure:^(NSError *error) {
        weakSelf.isLoading = NO;
        if (failure) {
            failure(error);
        }
    }];
}

- (void)loadOverlaysWithSuccess:(void (^)(NSArray *overlays))success
                        failure:(void (^)(NSError *error))failure
{
    self.isLoading = YES;
    MDWeakSelf
    [MDCardAPIManager getAllOverlaysWithSuccess:^(NSArray<MDCardOverlay *> *overlays) {
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"overlayName" ascending:YES];
        weakSelf.overlays = [overlays sortedArrayUsingDescriptors:@[sort]];
        weakSelf.isLoading = NO;
        
        if (success) {
            success(weakSelf.overlays);
        }

    } failure:^(NSError *error) {
        weakSelf.isLoading = NO;
        if (failure) {
            failure(error);
        }
    }];
}

- (void)loadHeadlinesWithSuccess:(void (^)(NSArray *headlines))success
                         failure:(void (^)(NSError *error))failure
{
    MDWeakSelf
    [MDCardAPIManager getAllHeadlinesWithSuccess:^(NSArray<NSString *> *headlines) {
        weakSelf.headlines = headlines;
        if (success) {
            success(headlines);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (MDCardOverlay *)overlayForID:(NSString *)templateID
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"overlayID == %@", templateID];
    return [self.overlays filteredArrayUsingPredicate:predicate].firstObject;
}

- (NSArray *)overlays
{
    MDCardOverlay *normal = [MDCardOverlay new];
    normal.overlayName = NSLocalizedString(@"Normal", @"When overlay is nil");
    
    return [@[normal] arrayByAddingObjectsFromArray:_overlays];
}

@end
