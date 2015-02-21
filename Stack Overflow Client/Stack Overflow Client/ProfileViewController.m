//
//  ProfileViewController.m
//  Stack Overflow Client
//
//  Created by John Leonard on 2/18/15.
//  Copyright (c) 2015 John Leonard. All rights reserved.
//

#import "ProfileViewController.h"
#import "Profile.h"
#import "StackOverflowService.h"

@interface ProfileViewController() <UIScrollViewDelegate>

@property (retain, nonatomic) UIScrollView *scrollView;
@property (retain, nonatomic) UILabel *displayNameLabel;
@property (retain, nonatomic) UILabel *bronzeCountLabel;
@property (retain, nonatomic) UILabel *silverCountLabel;
@property (retain, nonatomic) UILabel *goldCountLabel;
@property (retain, nonatomic) UITextField *bronzeCountTextField;
@property (retain, nonatomic) UITextField *silverCountTextField;
@property (retain, nonatomic) UITextField *goldCountTextField;

@property (retain, nonatomic) NSArray *profiles;

@end

@implementation ProfileViewController

- (void) viewDidLoad
{
  [super viewDidLoad];
  
  // put subviews onto the profile VC's view programmatically
  
  // I know that I'm playing with a lot more subviews here than I really need to -
  // it's practice arranging subviews
  
  // the scroll view holds everything
  self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
  self.scrollView.contentSize = CGSizeMake(2000, 2000);
  [self.view addSubview: self.scrollView];
  
  // Create the displayName label
 
  self.displayNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.origin.x + 50, self.view.frame.origin.y + 50, 200, 50)];
  [self.displayNameLabel setText:@"Display Name"];
  [self.scrollView addSubview:self.displayNameLabel];
  
  // Create badgeCount labels
  self.bronzeCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.origin.x + 50, self.view.frame.origin.y + 100, 200, 50)];
  [self.bronzeCountLabel setText:@"Bronze Count:"];
  [self.scrollView addSubview:self.bronzeCountLabel];
  
  self.silverCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.origin.x + 50, self.view.frame.origin.y + 150, 200, 50)];
  [self.silverCountLabel setText:@"Silver Count:"];
  [self.scrollView addSubview:self.silverCountLabel];
  
  self.goldCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.origin.x + 50, self.view.frame.origin.y + 200, 200, 50)];
  [self.goldCountLabel setText:@"Gold Count:"];
  [self.scrollView addSubview:self.goldCountLabel];
  
  // Create badgeCount text fields
  self.bronzeCountTextField = [[UITextField alloc] initWithFrame:CGRectMake(self.view.frame.origin.x + 200, self.view.frame.origin.y + 100, 200, 50)];
  [self.scrollView addSubview:self.bronzeCountTextField];
  
  self.silverCountTextField = [[UITextField alloc] initWithFrame:CGRectMake(self.view.frame.origin.x + 200, self.view.frame.origin.y + 150, 200, 50)];
  [self.scrollView addSubview:self.silverCountTextField];
  
  self.goldCountTextField = [[UITextField alloc] initWithFrame:CGRectMake(self.view.frame.origin.x + 200, self.view.frame.origin.y + 200, 200, 50)];
  [self.scrollView addSubview:self.goldCountTextField];
  
  self.scrollView.delegate = self;
  
  } // viewDidLoad

-(void) viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  // request the user's profile information from Stack Overflow and display it
  [[StackOverflowService sharedService]fetchProfile: ^(NSArray *results, NSString *error)
   {
     if (!results.count) // could find this user
     {
       // lifted from StackOverflow - somehow seems appropriate
       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Results" message:@"Stack Overflow returned no profile for this user's account." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
       [alert show];
     }
     self.profiles = results;
     if (error)
     {
       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ResultsError" message:@"Received an unspecified error getting account profile." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
       [alert show];
     } // if error
     
     // only ever interested in the first profile - should only ever be one returned
     Profile *profile = self.profiles[0];
     [self updateProfileDisplay:profile]; // update the display with profie data
   }]; // fetchProfile block

} // viewWillAppear()

// user scrolled the view bounds to look at subviews
- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
  // just log the offsets
  NSLog(@"x: %f, y: %f", scrollView.contentOffset.x, scrollView.contentOffset.y);
} // scrollViewDidScroll()

// update the My Profile display with user's data
- (void) updateProfileDisplay:(Profile *)profile
{
  // turn the numeric data into strings for display
  NSString *bronzeStr = [NSString stringWithFormat: @"%@", [profile.bronzeCount stringValue]];
  NSString *silverStr = [NSString stringWithFormat: @"%@", [profile.silverCount stringValue]];
  NSString *goldStr = [NSString stringWithFormat: @"%@", [profile.goldCount stringValue]];
  
  // set the display text to show the new data
  [self.displayNameLabel setText:profile.displayName];
  [self.bronzeCountTextField setText: bronzeStr];
  [self.silverCountTextField setText: silverStr];
  [self.goldCountTextField setText: goldStr];
    
} // updateProfileDisplay

- (void)dealloc
{
  // release all property storage
  [self.scrollView release];
  [self.displayNameLabel release];
  [self.bronzeCountLabel release];
  [self.silverCountLabel release];
  [self.goldCountLabel release];
  [self.bronzeCountTextField release];
  [self.silverCountTextField release];
  [self.goldCountTextField release];
  [self.profiles release];

  [super dealloc];
} // dealloc


@end
