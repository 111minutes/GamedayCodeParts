//
//  MDTemplateLibrary.h
//  matchday
//
//  Created by Andriy Fedin on 8/4/16.
//  Copyright © 2016 111 Minutes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MDTemplateGroup.h"


@interface MDTemplateLibrary : NSObject

@property (strong, nonatomic, readonly) NSArray<MDTemplateGroup *> *templateGroups;
@property (strong, nonatomic, readonly) NSArray<MDCardOverlay *> *overlays;
@property (strong, nonatomic, readonly) NSArray<NSString *> *headlines;

+ (MDTemplateLibrary *)sharedLibrary;

- (void)loadTemplates;
- (void)loadTemplatesWithSuccess:(void (^)(NSArray *templates))success
                         failure:(void (^)(NSError *error))failure;
- (MDCardOverlay *)overlayForID:(NSString *)templateID;

@end
