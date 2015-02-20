//
//  StackOverflowService.m
//  Stack Overflow Client
//
//  Created by John Leonard on 2/17/15.
//  Copyright (c) 2015 John Leonard. All rights reserved.
//

#import "StackOverflowService.h"
#import "Question.h"
#import "Profile.h"

@implementation StackOverflowService

NSString *const stackExchangeURL = @"https://api.stackexchange.com/2.2/";
NSString *const searchUri = @"search?order=desc&sort=activity&site=stackoverflow&intitle=";
NSString *const myProfileUri = @"me?order=desc&sort=reputation&site=stackoverflow";
NSString *const appKey = @"&key=avJjvvhdC6BgbgxmMjBhAQ((";

+ (id) sharedService
{
  static StackOverflowService *mySharedService;
  static dispatch_once_t onceToken;
  
  dispatch_once(&onceToken, ^{
    mySharedService = [[StackOverflowService alloc] init];
  });
  return mySharedService;
} // sharedService singleton

// ask Stack Overflow for the set of questions containing a specified search sring
- (void) fetchQuestionsWithSearchTerm:(NSString *)searchTerm completionHandler:(void (^)(NSArray *, NSString *))completionHandler
{
  // build the URL by accretion
  NSString *urlString = stackExchangeURL;
  urlString = [urlString stringByAppendingString:searchUri];
  urlString = [urlString stringByAppendingString:searchTerm];
  
  // if we have a token, use it
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  NSString *token = [defaults objectForKey:@"token"];
  if (token)
  {
    urlString = [urlString stringByAppendingString:@"&access_token="];
    urlString = [urlString stringByAppendingString:token];
    urlString = [urlString stringByAppendingString:appKey];
  }
  
  // put the GET request together
  NSURL *url = [NSURL URLWithString:urlString];
  NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
  request.HTTPMethod = @"GET";
  
  // get the NSURL session together in anticipation of sending an HTTP message
  NSURLSession *session = [NSURLSession sharedSession];
  NSURLSessionTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
  {
    if (error)
    {
      completionHandler(nil, @"Could not connect.");
    }
    
    else // no error
    {
      // cast the response as an http resposnse, so can get the statusCode
      NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
      NSInteger statusCode = httpResponse.statusCode;
      
      switch (statusCode)
      {
        case 200 ... 299: // good response
        {
          NSLog(@"Status code: %ld", (long)statusCode);
          NSArray *results = [Question questionsFromJSON:data];
          
          dispatch_async(dispatch_get_main_queue(), ^{
            if(results)
            {
              completionHandler(results, nil);
            }
            
            else
            {
              completionHandler(nil, @"Search could not be completed.");
            }
          });
          break;
        } // case 200 - 299
          
        default: // some kind of error
          NSLog(@"Status code: %ld", (long)statusCode);
          break;
      } // switch
    } // else - no error
  }]; // dataTask
  
  [dataTask resume]; // actually sends the request message
  
} // fetchQuestionsWithSearchTerm()

// get the avatar image for the user that asked the question
- (void) fetchUserImage:(NSString *)avatarURL completionHandler:(void (^)(UIImage *))completionHandler
{
  // send the rquest asynchronously
  dispatch_queue_t imageQueue = dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0);
  dispatch_async(imageQueue, ^{
    NSURL *url = [NSURL URLWithString:avatarURL];
    NSData *data = [[NSData alloc] initWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData:data];
    
    dispatch_async(dispatch_get_main_queue(), ^{
      completionHandler(image);
    });
  });
} // fetchUserImage()

// get the user's profile data from Stack Overflow - pretty much like getting the list of questions
- (void) fetchProfile: (void (^)(NSArray *, NSString *))completionHandler
{
  NSString *urlString = stackExchangeURL;
  urlString = [urlString stringByAppendingString:myProfileUri];
  
  // if we have a token, use it
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  NSString *token = [defaults objectForKey:@"token"];
  if (token)
  {
    urlString = [urlString stringByAppendingString:@"&access_token="];
    urlString = [urlString stringByAppendingString:token];
    urlString = [urlString stringByAppendingString:appKey];
  }
  
  NSLog(@"URL: %@", urlString);
  
  NSURL *url = [NSURL URLWithString:urlString];
  NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
  request.HTTPMethod = @"GET";
  
  NSURLSession *session = [NSURLSession sharedSession];
  NSURLSessionTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
  {
    if (error)
    {
      completionHandler(nil, @"Could not connect.");
    }
    
    else // no error
    {
      NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
      NSInteger statusCode = httpResponse.statusCode;
      
      switch (statusCode)
      {
        case 200 ... 299: // good response
        {
          NSLog(@"Status code: %ld", (long)statusCode);
          NSArray *results = [Profile profileFromJSON:data];
          
          dispatch_async(dispatch_get_main_queue(), ^{
            if(results)
            {
              completionHandler(results, nil);
            }
            
            else
            {
              completionHandler(nil, @"Search could not be completed.");
            }
          });
          break;
        } // case 200 - 299
        default:
          NSLog(@"Status code: %ld", (long)statusCode);
          break;
      } // switch
    } // else - no error
  }]; // dataTask
  [dataTask resume];
 
}

@end
