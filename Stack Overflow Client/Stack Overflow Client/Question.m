//
//  Question.m
//  Stack Overflow Client
//
//  Created by John Leonard on 2/17/15.
//  Copyright (c) 2015 John Leonard. All rights reserved.
//

#import "Question.h"

@implementation Question

+ (NSArray *)questionsFromJSON:(NSData *)jsonData
{
  NSError *error;
  NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
  
  if (error)
  {
    NSLog(@"Error serializing JSON data: %@", error.localizedDescription);
    return nil; // bail
  }
  
  NSArray *items = [jsonDictionary objectForKey:@"items"];
  NSMutableArray *temp = [[NSMutableArray alloc] init];
  
  // parse the JSON data for the queustion and user photos
  for (NSDictionary *item in items)
  {
    Question *question = [[Question alloc] init];
    question.title = item[@"title"];
    NSDictionary *userInfo = item[@"owner"];
    question.avatarURL = userInfo[@"profile_image"];
    
    // put the question on the array of questions
    [temp addObject:question];
  } // for item
  
  // cast the NSMutableArray temp as a NSArray and return it
  NSArray *final = [[NSArray alloc] initWithArray:temp];
  return final;
  
} // questionsFromJSON()

@end
