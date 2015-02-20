//
//  StackOverflowService.h
//  Stack Overflow Client
//
//  Created by John Leonard on 2/17/15.
//  Copyright (c) 2015 John Leonard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StackOverflowService : NSObject

+ (id) sharedService;
- (void) fetchQuestionsWithSearchTerm:(NSString *)searchTerm completionHandler: (void (^) (NSArray *results, NSString *error)) completionHandler;
- (void) fetchUserImage:(NSString *)avatarURL completionHandler: (void (^) (UIImage *image)) completionHandler;
- (void) fetchProfile: (void (^)(NSArray *, NSString *))completionHandler;


@end
