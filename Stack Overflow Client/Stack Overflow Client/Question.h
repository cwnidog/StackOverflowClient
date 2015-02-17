//
//  Question.h
//  Stack Overflow Client
//
//  Created by John Leonard on 2/17/15.
//  Copyright (c) 2015 John Leonard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Question : NSObject

+ (NSArray *) questionsFromJSON:(NSData *)jsonData;

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *avatarURL;
@property (strong, nonatomic) UIImage *image;

@end
