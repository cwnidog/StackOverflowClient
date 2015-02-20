//
//  Profile.m
//  Stack Overflow Client
//
//  Created by John Leonard on 2/18/15.
//  Copyright (c) 2015 John Leonard. All rights reserved.
//

#import "Profile.h"

@implementation Profile

// parse the received JSON data for relevant information
+(NSArray *) profileFromJSON: (NSData*)jsonData
{
  NSError * error;
  NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
  
  if (error)
  {
    NSLog(@"Received error %@", error.localizedDescription);
    return nil;
  } // if error

  NSArray *items = [jsonDictionary objectForKey:@"items"];
  NSMutableArray *temp = [[NSMutableArray alloc] init];
  for (NSDictionary *item in items)
  {
    Profile *profile = [[Profile alloc] init];
    profile.displayName = item[@"display_name"];
    
    NSDictionary *badgeCounts = item[@"badge_counts"];
    profile.bronzeCount = badgeCounts[@"bronze"];
    profile.silverCount = badgeCounts[@"silver"];
    profile.goldCount = badgeCounts[@"gold"];
    
    [temp addObject:profile];
  } // for item
  
  NSArray *final = [[NSArray alloc] initWithArray:temp];
  return final;

} // profileFromJSON()



@end
