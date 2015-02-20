//
//  Profile.h
//  Stack Overflow Client
//
//  Created by John Leonard on 2/18/15.
//  Copyright (c) 2015 John Leonard. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Profile : NSObject

+(NSArray *) profileFromJSON: (NSData*)jsonData;

@property (strong, nonatomic) NSString *displayName;
@property (strong, nonatomic) NSNumber *bronzeCount;
@property (strong, nonatomic) NSNumber *silverCount;
@property (strong, nonatomic) NSNumber *goldCount;

@end
